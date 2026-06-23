-- =============================================
-- SP_ENCOKSATANURUNLER
-- Top-N en çok satan ürünler: miktar, ciro ve
-- kar bazlı sıralama, dönem ve kategori filtresi
-- =============================================
-- Kullanım:
--   EXEC SP_EnCokSatanUrunler;
--   EXEC SP_EnCokSatanUrunler @TopN = 20, @KategoriID = 1;
--   EXEC SP_EnCokSatanUrunler @BaslangicTarihi = '2024-01-01', @BitisTarihi = '2024-06-30';
-- =============================================

USE PerakendeSatisDB;
GO

CREATE OR ALTER PROCEDURE SP_EnCokSatanUrunler
    @TopN            INT  = 10,
    @KategoriID      INT  = NULL,
    @BaslangicTarihi DATE = NULL,
    @BitisTarihi     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    IF @BaslangicTarihi IS NULL SET @BaslangicTarihi = '2023-01-01';
    IF @BitisTarihi     IS NULL SET @BitisTarihi     = '2024-12-31';

    WITH UrunOzet AS (
        SELECT
            u.UrunID,
            u.UrunKodu,
            u.UrunAdi,
            k.KategoriAdi,
            SUM(sd.Miktar)                                                          AS ToplamSatisMiktari,
            COUNT(DISTINCT s.SiparisID)                                             AS SiparisAdedi,
            COUNT(DISTINCT s.MusteriID)                                             AS BenzersizMusteri,
            ROUND(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 2) AS ToplamCiro,
            ROUND(AVG(sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 2)             AS OrtSatisFiyati,
            ROUND(
                SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)),
            2)                                                                       AS ToplamBrutKar,
            ROUND(
                SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet))
                / NULLIF(SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)), 0) * 100,
            2)                                                                       AS KarMarjiYuzdesi
        FROM SiparisDetay sd
        INNER JOIN Siparisler s ON sd.SiparisID = s.SiparisID
        INNER JOIN Urunler    u ON sd.UrunID    = u.UrunID
        INNER JOIN Kategoriler k ON u.KategoriID = k.KategoriID
        WHERE s.Durum = 'Tamamlandı'
          AND CAST(s.SiparisTarihi AS DATE) BETWEEN @BaslangicTarihi AND @BitisTarihi
          AND (@KategoriID IS NULL OR u.KategoriID = @KategoriID)
        GROUP BY u.UrunID, u.UrunKodu, u.UrunAdi, k.KategoriAdi
    )
    SELECT TOP (@TopN)
        UrunKodu,
        UrunAdi,
        KategoriAdi,
        ToplamSatisMiktari,
        SiparisAdedi,
        BenzersizMusteri,
        ToplamCiro,
        OrtSatisFiyati,
        ToplamBrutKar,
        KarMarjiYuzdesi,
        RANK() OVER (ORDER BY ToplamSatisMiktari DESC) AS MiktarSirasi,
        RANK() OVER (ORDER BY ToplamCiro DESC)         AS CiroSirasi,
        RANK() OVER (ORDER BY ToplamBrutKar DESC)      AS KarSirasi,
        -- Toplam içindeki ciro payı
        ROUND(ToplamCiro / SUM(ToplamCiro) OVER () * 100, 2) AS CiroPayiYuzdesi
    FROM UrunOzet
    ORDER BY ToplamSatisMiktari DESC;
END;
GO
