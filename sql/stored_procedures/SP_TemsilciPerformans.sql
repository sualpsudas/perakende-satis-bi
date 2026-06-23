-- =============================================
-- SP_TEMSILCIPERFORMANS
-- Satış temsilcisi bazlı performans raporu:
-- hedef vs gerçekleşen, sıralama, durum etiketi
-- =============================================
-- Kullanım:
--   EXEC SP_TemsilciPerformans;
--   EXEC SP_TemsilciPerformans @Yil = 2024;
--   EXEC SP_TemsilciPerformans @Yil = 2024, @BolgeID = 1;
-- =============================================

USE PerakendeSatisDB;
GO

CREATE OR ALTER PROCEDURE SP_TemsilciPerformans
    @Yil     INT = NULL,
    @BolgeID INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @Yil IS NULL SET @Yil = 2024;

    WITH TemsilciSatis AS (
        SELECT
            st.TemsilciID,
            st.Ad + ' ' + st.Soyad   AS TemsilciAdi,
            b.BolgeAdi,
            st.YillikHedef,
            COUNT(DISTINCT CASE WHEN s.Durum = 'Tamamlandı' THEN s.SiparisID END)       AS SiparisAdedi,
            COUNT(DISTINCT CASE WHEN s.Durum = 'Tamamlandı' THEN s.MusteriID END)   AS HizmetVerilenMusteri,
            ISNULL(SUM(sd.Miktar), 0)                                                AS SatisAdet,
            ROUND(
                ISNULL(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0),
            2)                                                                        AS GerceklesenCiro,
            ROUND(
                ISNULL(
                    SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)),
                0),
            2)                                                                        AS ToplamBrutKar,
            COUNT(CASE WHEN s.Durum = 'İptal' THEN 1 END)                            AS IptalSiparisAdedi
        FROM SatisTemsilcileri st
        INNER JOIN Bolgeler b ON st.BolgeID = b.BolgeID
        -- Tüm yıl siparişleri (tüm statüsler) — detay JOIN'i Tamamlandı ile kısıtlı
        LEFT JOIN Siparisler s
            ON st.TemsilciID = s.TemsilciID
           AND YEAR(s.SiparisTarihi) = @Yil
        LEFT JOIN SiparisDetay sd
            ON s.SiparisID = sd.SiparisID
           AND s.Durum = 'Tamamlandı'
        LEFT JOIN Urunler u ON sd.UrunID = u.UrunID
        WHERE st.AktifMi = 1
          AND (@BolgeID IS NULL OR st.BolgeID = @BolgeID)
        GROUP BY st.TemsilciID, st.Ad, st.Soyad, b.BolgeAdi, st.YillikHedef
    )
    SELECT
        @Yil                                                              AS Yil,
        TemsilciAdi,
        BolgeAdi,
        SiparisAdedi,
        HizmetVerilenMusteri,
        SatisAdet,
        YillikHedef,
        GerceklesenCiro,
        ROUND(GerceklesenCiro / YillikHedef * 100, 2)                    AS HedefGerceklesmeYuzdesi,
        YillikHedef - GerceklesenCiro                                    AS HedefFarki,
        ToplamBrutKar,
        ROUND(
            ToplamBrutKar / NULLIF(GerceklesenCiro, 0) * 100,
        2)                                                                AS KarMarjiYuzdesi,
        IptalSiparisAdedi,
        RANK() OVER (ORDER BY GerceklesenCiro DESC)                       AS PerformansSirasi,
        -- Bölge içi sıralama
        RANK() OVER (PARTITION BY BolgeAdi ORDER BY GerceklesenCiro DESC) AS BolgeSirasi,
        -- Kümülatif ciro payı
        ROUND(
            SUM(GerceklesenCiro) OVER (ORDER BY GerceklesenCiro DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
            / NULLIF(SUM(GerceklesenCiro) OVER (), 0) * 100,
        2)                                                                AS KumulatifCiroPayi,
        CASE
            WHEN GerceklesenCiro / YillikHedef >= 1.00 THEN 'Hedef Aşıldı'
            WHEN GerceklesenCiro / YillikHedef >= 0.90 THEN 'Hedefe Yakın'
            WHEN GerceklesenCiro / YillikHedef >= 0.70 THEN 'Geliştirilmeli'
            ELSE 'Hedef Altı'
        END                                                               AS PerformansDurumu
    FROM TemsilciSatis
    ORDER BY GerceklesenCiro DESC;
END;
GO
