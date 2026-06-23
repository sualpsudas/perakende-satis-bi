-- =============================================
-- SP_MUSTERISEGMENTASYONU
-- RFM (Recency / Frequency / Monetary) analizi
-- ile müşteri segmentasyonu
-- =============================================
-- Metodoloji:
--   Recency  — son alışverişten bu yana geçen gün (az = iyi)
--   Frequency — toplam tamamlanmış sipariş sayısı
--   Monetary  — toplam net harcama tutarı
--   Her boyut 1-5 arası NTILE skoru alır.
--   Toplam R+F+M skoru = 3–15 arası.
-- =============================================
-- Kullanım:
--   EXEC SP_MusteriSegmentasyonu;
--   EXEC SP_MusteriSegmentasyonu @AnalizTarihi = '2024-12-31';
--   EXEC SP_MusteriSegmentasyonu @AnalizTarihi = '2024-12-31', @MinSiparis = 2;
-- =============================================

USE PerakendeSatisDB;
GO

CREATE OR ALTER PROCEDURE SP_MusteriSegmentasyonu
    @AnalizTarihi DATE = NULL,
    @MinSiparis   INT  = 1
AS
BEGIN
    SET NOCOUNT ON;

    IF @AnalizTarihi IS NULL SET @AnalizTarihi = '2024-12-31';

    WITH MusteriMetrik AS (
        SELECT
            m.MusteriID,
            m.MusteriKodu,
            m.MusteriAdi,
            sh.SehirAdi,
            b.BolgeAdi,
            m.Segment                                                            AS MusteriTipi,
            m.KayitTarihi,
            DATEDIFF(DAY, MAX(s.SiparisTarihi), @AnalizTarihi)                   AS Recency,
            COUNT(DISTINCT s.SiparisID)                                          AS Frequency,
            ROUND(
                ISNULL(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0),
            2)                                                                   AS Monetary,
            ROUND(
                ISNULL(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0)
                / NULLIF(COUNT(DISTINCT s.SiparisID), 0),
            2)                                                                   AS OrtSepetTutari
        FROM Musteriler m
        INNER JOIN Sehirler sh ON m.SehirID  = sh.SehirID
        INNER JOIN Bolgeler b  ON sh.BolgeID = b.BolgeID
        LEFT JOIN Siparisler s
            ON m.MusteriID = s.MusteriID
           AND s.Durum = 'Tamamlandı'
           AND s.SiparisTarihi <= @AnalizTarihi
        LEFT JOIN SiparisDetay sd ON s.SiparisID = sd.SiparisID
        WHERE m.AktifMi = 1
        GROUP BY
            m.MusteriID, m.MusteriKodu, m.MusteriAdi,
            sh.SehirAdi, b.BolgeAdi, m.Segment, m.KayitTarihi
        HAVING COUNT(DISTINCT s.SiparisID) >= @MinSiparis
    ),
    RFMSkorlar AS (
        SELECT
            *,
            NTILE(5) OVER (ORDER BY Recency  ASC)   AS R_Skor,
            NTILE(5) OVER (ORDER BY Frequency DESC)  AS F_Skor,
            NTILE(5) OVER (ORDER BY Monetary  DESC)  AS M_Skor
        FROM MusteriMetrik
    )
    SELECT
        MusteriKodu,
        MusteriAdi,
        SehirAdi,
        BolgeAdi,
        MusteriTipi,
        KayitTarihi,
        Recency          AS SonAlisverisGunOnce,
        Frequency        AS ToplamSiparis,
        Monetary         AS ToplamHarcama,
        OrtSepetTutari,
        R_Skor,
        F_Skor,
        M_Skor,
        R_Skor + F_Skor + M_Skor AS ToplamRFMSkor,
        CASE
            WHEN R_Skor >= 4 AND F_Skor >= 4 AND M_Skor >= 4                    THEN 'Şampiyon'
            WHEN R_Skor >= 3 AND F_Skor >= 3 AND M_Skor >= 3                    THEN 'Sadık Müşteri'
            WHEN R_Skor >= 4 AND F_Skor <= 2                                     THEN 'Yeni & Umut Verici'
            WHEN R_Skor >= 3 AND (F_Skor >= 3 OR M_Skor >= 4)                   THEN 'Potansiyel Sadık'
            WHEN R_Skor <= 2 AND F_Skor >= 4 AND M_Skor >= 4                    THEN 'Risk Altında'
            WHEN R_Skor <= 2 AND F_Skor >= 2 AND M_Skor >= 2                    THEN 'Geri Kazanılabilir'
            WHEN R_Skor = 1  AND F_Skor = 1                                      THEN 'Kaybedilen'
            ELSE 'İzlenmeli'
        END              AS RFMSegmenti,
        -- Segment içindeki sıralama (en değerli müşteriye göre)
        RANK() OVER (
            PARTITION BY
                CASE
                    WHEN R_Skor >= 4 AND F_Skor >= 4 AND M_Skor >= 4            THEN 'Şampiyon'
                    WHEN R_Skor >= 3 AND F_Skor >= 3 AND M_Skor >= 3            THEN 'Sadık Müşteri'
                    WHEN R_Skor >= 4 AND F_Skor <= 2                             THEN 'Yeni & Umut Verici'
                    WHEN R_Skor >= 3 AND (F_Skor >= 3 OR M_Skor >= 4)           THEN 'Potansiyel Sadık'
                    WHEN R_Skor <= 2 AND F_Skor >= 4 AND M_Skor >= 4            THEN 'Risk Altında'
                    WHEN R_Skor <= 2 AND F_Skor >= 2 AND M_Skor >= 2            THEN 'Geri Kazanılabilir'
                    WHEN R_Skor = 1  AND F_Skor = 1                              THEN 'Kaybedilen'
                    ELSE 'İzlenmeli'
                END
            ORDER BY Monetary DESC
        )                AS SegmentIciSira
    FROM RFMSkorlar
    ORDER BY ToplamRFMSkor DESC, Monetary DESC;
END;
GO
