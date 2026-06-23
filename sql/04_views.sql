-- =============================================
-- 04_VIEWS.SQL
-- Power BI bağlantısı için view'lar
-- Her view bir rapor sayfasının veri kaynağıdır.
-- =============================================

USE PerakendeSatisDB;
GO

-- =============================================
-- VW_AylikSatisOzeti
-- Sayfa 1: Zaman serisi — aylık ciro, büyüme, kar
-- =============================================
CREATE OR ALTER VIEW VW_AylikSatisOzeti AS
SELECT
    YEAR(s.SiparisTarihi)                                                       AS Yil,
    MONTH(s.SiparisTarihi)                                                      AS Ay,
    CAST(YEAR(s.SiparisTarihi) AS NVARCHAR) + '-'
        + RIGHT('0' + CAST(MONTH(s.SiparisTarihi) AS NVARCHAR), 2)              AS YilAy,
    DATEFROMPARTS(YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi), 1)             AS AyTarihi,
    COUNT(DISTINCT s.SiparisID)                                                 AS ToplamSiparis,
    COUNT(DISTINCT s.MusteriID)                                                 AS AktifMusteri,
    SUM(sd.Miktar)                                                              AS SatilanAdet,
    ROUND(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 2)    AS ToplamCiro,
    ROUND(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0))
        / NULLIF(COUNT(DISTINCT s.SiparisID), 0), 2)                            AS OrtSepetTutari,
    ROUND(SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)), 2) AS BrutKar,
    ROUND(SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet))
        / NULLIF(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0) * 100, 2) AS KarMarji
FROM Siparisler s
INNER JOIN SiparisDetay sd ON s.SiparisID = sd.SiparisID
INNER JOIN Urunler      u  ON sd.UrunID   = u.UrunID
WHERE s.Durum = 'Tamamlandı'
GROUP BY YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi);
GO

-- =============================================
-- VW_UrunPerformans
-- Sayfa 2: Ürün analizi — ciro, adet, kar, kategori
-- =============================================
CREATE OR ALTER VIEW VW_UrunPerformans AS
SELECT
    u.UrunKodu,
    u.UrunAdi,
    k.KategoriAdi,
    YEAR(s.SiparisTarihi)                                                       AS Yil,
    MONTH(s.SiparisTarihi)                                                      AS Ay,
    SUM(sd.Miktar)                                                              AS SatilanAdet,
    COUNT(DISTINCT s.SiparisID)                                                 AS SiparisAdedi,
    ROUND(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 2)    AS ToplamCiro,
    ROUND(SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)), 2) AS BrutKar,
    ROUND(SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet))
        / NULLIF(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0) * 100, 2) AS KarMarji
FROM SiparisDetay sd
INNER JOIN Siparisler  s ON sd.SiparisID  = s.SiparisID
INNER JOIN Urunler     u ON sd.UrunID     = u.UrunID
INNER JOIN Kategoriler k ON u.KategoriID  = k.KategoriID
WHERE s.Durum = 'Tamamlandı'
GROUP BY u.UrunKodu, u.UrunAdi, k.KategoriAdi,
         YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi);
GO

-- =============================================
-- VW_TemsilciPerformans
-- Sayfa 3: Temsilci — hedef vs gerçekleşen
-- =============================================
CREATE OR ALTER VIEW VW_TemsilciPerformans AS
SELECT
    st.Ad + ' ' + st.Soyad                                                     AS TemsilciAdi,
    b.BolgeAdi,
    YEAR(s.SiparisTarihi)                                                       AS Yil,
    MONTH(s.SiparisTarihi)                                                      AS Ay,
    DATEFROMPARTS(YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi), 1)             AS AyTarihi,
    st.YillikHedef,
    ROUND(st.YillikHedef / 12.0, 2)                                             AS AylikHedef,
    COUNT(DISTINCT CASE WHEN s.Durum = 'Tamamlandı' THEN s.SiparisID END)      AS SiparisAdedi,
    COUNT(DISTINCT CASE WHEN s.Durum = 'Tamamlandı' THEN s.MusteriID END)      AS HizmetVerilenMusteri,
    ROUND(ISNULL(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0), 2) AS GerceklesenCiro,
    ROUND(ISNULL(SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)), 0), 2) AS BrutKar,
    COUNT(CASE WHEN s.Durum = 'İptal' THEN 1 END)                              AS IptalSiparis
FROM SatisTemsilcileri st
INNER JOIN Bolgeler b ON st.BolgeID = b.BolgeID
LEFT JOIN Siparisler s
    ON st.TemsilciID = s.TemsilciID
   AND YEAR(s.SiparisTarihi) IN (2023, 2024)
LEFT JOIN SiparisDetay sd
    ON s.SiparisID = sd.SiparisID
   AND s.Durum = 'Tamamlandı'
LEFT JOIN Urunler u ON sd.UrunID = u.UrunID
WHERE st.AktifMi = 1
GROUP BY st.Ad, st.Soyad, b.BolgeAdi, st.YillikHedef,
         YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi);
GO

-- =============================================
-- VW_MusteriSegmentleri
-- Sayfa 4: RFM segmentasyonu
-- =============================================
CREATE OR ALTER VIEW VW_MusteriSegmentleri AS
WITH MusteriMetrik AS (
    SELECT
        m.MusteriID,
        m.MusteriKodu,
        m.MusteriAdi,
        sh.SehirAdi,
        b.BolgeAdi,
        m.Segment                                                               AS MusteriTipi,
        DATEDIFF(DAY, MAX(s.SiparisTarihi), '2024-12-31')                       AS Recency,
        COUNT(DISTINCT s.SiparisID)                                             AS Frequency,
        ROUND(ISNULL(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0), 2) AS Monetary
    FROM Musteriler m
    INNER JOIN Sehirler sh ON m.SehirID  = sh.SehirID
    INNER JOIN Bolgeler b  ON sh.BolgeID = b.BolgeID
    LEFT JOIN Siparisler s
        ON m.MusteriID = s.MusteriID
       AND s.Durum = 'Tamamlandı'
    LEFT JOIN SiparisDetay sd ON s.SiparisID = sd.SiparisID
    WHERE m.AktifMi = 1
    GROUP BY m.MusteriID, m.MusteriKodu, m.MusteriAdi, sh.SehirAdi, b.BolgeAdi, m.Segment
    HAVING COUNT(DISTINCT s.SiparisID) >= 1
),
RFMSkorlar AS (
    SELECT *,
        NTILE(5) OVER (ORDER BY Recency  ASC)  AS R_Skor,
        NTILE(5) OVER (ORDER BY Frequency DESC) AS F_Skor,
        NTILE(5) OVER (ORDER BY Monetary  DESC) AS M_Skor
    FROM MusteriMetrik
)
SELECT
    MusteriKodu,
    MusteriAdi,
    SehirAdi,
    BolgeAdi,
    MusteriTipi,
    Recency,
    Frequency,
    Monetary,
    R_Skor,
    F_Skor,
    M_Skor,
    R_Skor + F_Skor + M_Skor AS ToplamRFMSkor,
    CASE
        WHEN R_Skor >= 4 AND F_Skor >= 4 AND M_Skor >= 4           THEN 'Şampiyon'
        WHEN R_Skor >= 3 AND F_Skor >= 3 AND M_Skor >= 3           THEN 'Sadık Müşteri'
        WHEN R_Skor >= 4 AND F_Skor <= 2                            THEN 'Yeni & Umut Verici'
        WHEN R_Skor >= 3 AND (F_Skor >= 3 OR M_Skor >= 4)          THEN 'Potansiyel Sadık'
        WHEN R_Skor <= 2 AND F_Skor >= 4 AND M_Skor >= 4           THEN 'Risk Altında'
        WHEN R_Skor <= 2 AND F_Skor >= 2 AND M_Skor >= 2           THEN 'Geri Kazanılabilir'
        WHEN R_Skor = 1  AND F_Skor = 1                             THEN 'Kaybedilen'
        ELSE 'İzlenmeli'
    END AS RFMSegmenti
FROM RFMSkorlar;
GO

-- =============================================
-- VW_BolgeselSatis
-- Sayfa 5: Bölge / şehir / kategori kırılımı
-- =============================================
CREATE OR ALTER VIEW VW_BolgeselSatis AS
SELECT
    b.BolgeAdi,
    sh.SehirAdi,
    k.KategoriAdi,
    YEAR(s.SiparisTarihi)                                                       AS Yil,
    MONTH(s.SiparisTarihi)                                                      AS Ay,
    COUNT(DISTINCT s.SiparisID)                                                 AS SiparisAdedi,
    COUNT(DISTINCT s.MusteriID)                                                 AS BenzersizMusteri,
    SUM(sd.Miktar)                                                              AS ToplamAdet,
    ROUND(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 2)    AS ToplamCiro,
    ROUND(SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)), 2) AS BrutKar
FROM Siparisler s
INNER JOIN SiparisDetay sd  ON s.SiparisID  = sd.SiparisID
INNER JOIN Urunler      u   ON sd.UrunID     = u.UrunID
INNER JOIN Kategoriler  k   ON u.KategoriID  = k.KategoriID
INNER JOIN Musteriler   m   ON s.MusteriID   = m.MusteriID
INNER JOIN Sehirler     sh  ON m.SehirID     = sh.SehirID
INNER JOIN Bolgeler     b   ON sh.BolgeID    = b.BolgeID
WHERE s.Durum = 'Tamamlandı'
GROUP BY b.BolgeAdi, sh.SehirAdi, k.KategoriAdi,
         YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi);
GO

PRINT 'Tüm view''lar başarıyla oluşturuldu.';
GO
