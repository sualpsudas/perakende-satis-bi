-- =============================================
-- SP_AYLIKSATISOZETI
-- Yıl/ay bazlı satış özeti: ciro, sipariş adedi,
-- ortalama sepet tutarı ve kar marjı
-- =============================================
-- Kullanım:
--   EXEC SP_AylikSatisOzeti;                          -- Tüm veriler
--   EXEC SP_AylikSatisOzeti @Yil = 2024;
--   EXEC SP_AylikSatisOzeti @Yil = 2024, @AyBaslangic = 1, @AyBitis = 6;
-- =============================================

USE PerakendeSatisDB;
GO

CREATE OR ALTER PROCEDURE SP_AylikSatisOzeti
    @Yil         INT = NULL,
    @AyBaslangic INT = 1,
    @AyBitis     INT = 12
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        YEAR(s.SiparisTarihi)                                                   AS Yil,
        MONTH(s.SiparisTarihi)                                                  AS Ay,
        DATENAME(MONTH, s.SiparisTarihi)                                        AS AyAdi,
        COUNT(DISTINCT s.SiparisID)                                             AS ToplamSiparis,
        COUNT(DISTINCT s.MusteriID)                                             AS AktifMusteriSayisi,
        COUNT(sd.DetayID)                                                       AS ToplamKalem,
        SUM(sd.Miktar)                                                          AS SatilanUrunAdedi,
        ROUND(
            SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)),
        2)                                                                      AS ToplamCiro,
        ROUND(
            SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0))
            / NULLIF(COUNT(DISTINCT s.SiparisID), 0),
        2)                                                                      AS OrtSepetTutari,
        ROUND(
            SUM(sd.Miktar * sd.BirimFiyat * sd.IskontoOrani / 100.0),
        2)                                                                      AS ToplamIskonto,
        ROUND(
            SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)),
        2)                                                                      AS ToplamBrutKar,
        ROUND(
            SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet))
            / NULLIF(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0) * 100,
        2)                                                                      AS KarMarjiYuzdesi,
        -- Önceki aya göre ciro büyümesi (window function)
        ROUND(
            SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0))
            - LAG(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 1)
              OVER (ORDER BY YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi)),
        2)                                                                      AS OncekiAyaGoreFark,
        ROUND(
            (SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0))
            - LAG(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 1)
              OVER (ORDER BY YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi)))
            / NULLIF(
                LAG(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 1)
                OVER (ORDER BY YEAR(s.SiparisTarihi), MONTH(s.SiparisTarihi)),
            0) * 100,
        2)                                                                      AS BuyumeYuzdesi
    FROM Siparisler s
    INNER JOIN SiparisDetay sd ON s.SiparisID = sd.SiparisID
    INNER JOIN Urunler      u  ON sd.UrunID   = u.UrunID
    WHERE s.Durum = 'Tamamlandı'
      AND (@Yil IS NULL OR YEAR(s.SiparisTarihi) = @Yil)
      AND MONTH(s.SiparisTarihi) BETWEEN @AyBaslangic AND @AyBitis
    GROUP BY
        YEAR(s.SiparisTarihi),
        MONTH(s.SiparisTarihi),
        DATENAME(MONTH, s.SiparisTarihi)
    ORDER BY
        Yil, Ay;
END;
GO
