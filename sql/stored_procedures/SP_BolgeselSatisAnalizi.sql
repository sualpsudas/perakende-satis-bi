-- =============================================
-- SP_BÖLGESELSATISANALIZI
-- Bölge / şehir / kategori kırılımında satış
-- analizi; bölge içi ve genel ciro payları
-- =============================================
-- Kullanım:
--   EXEC SP_BolgeselSatisAnalizi;
--   EXEC SP_BolgeselSatisAnalizi @Yil = 2024;
--   EXEC SP_BolgeselSatisAnalizi @Yil = 2024, @KategoriID = 1;
--   EXEC SP_BolgeselSatisAnalizi @BaslangicTarihi = '2024-01-01', @BitisTarihi = '2024-06-30';
-- =============================================

USE PerakendeSatisDB;
GO

CREATE OR ALTER PROCEDURE SP_BolgeselSatisAnalizi
    @Yil             INT  = NULL,
    @KategoriID      INT  = NULL,
    @BaslangicTarihi DATE = NULL,
    @BitisTarihi     DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;

    -- @Yil verilmişse tarihleri ona göre ayarla, yoksa @Bas/@Bit kullan
    IF @Yil IS NOT NULL
    BEGIN
        SET @BaslangicTarihi = DATEFROMPARTS(@Yil, 1, 1);
        SET @BitisTarihi     = DATEFROMPARTS(@Yil, 12, 31);
    END;
    IF @BaslangicTarihi IS NULL SET @BaslangicTarihi = '2023-01-01';
    IF @BitisTarihi     IS NULL SET @BitisTarihi     = '2024-12-31';

    WITH BolgeDetay AS (
        SELECT
            b.BolgeAdi,
            sh.SehirAdi,
            k.KategoriAdi,
            COUNT(DISTINCT s.SiparisID)                                              AS SiparisAdedi,
            COUNT(DISTINCT s.MusteriID)                                              AS BenzersizMusteri,
            SUM(sd.Miktar)                                                           AS ToplamAdet,
            ROUND(
                SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0)),
            2)                                                                       AS ToplamCiro,
            ROUND(
                SUM(sd.Miktar * (sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0) - u.Maliyet)),
            2)                                                                       AS ToplamBrutKar,
            ROUND(
                SUM(sd.Miktar * sd.BirimFiyat * (1 - sd.IskontoOrani / 100.0))
                / NULLIF(COUNT(DISTINCT s.SiparisID), 0),
            2)                                                                       AS OrtSepetTutari
        FROM Siparisler s
        INNER JOIN SiparisDetay sd  ON s.SiparisID  = sd.SiparisID
        INNER JOIN Urunler      u   ON sd.UrunID     = u.UrunID
        INNER JOIN Kategoriler  k   ON u.KategoriID  = k.KategoriID
        INNER JOIN Musteriler   m   ON s.MusteriID   = m.MusteriID
        INNER JOIN Sehirler     sh  ON m.SehirID     = sh.SehirID
        INNER JOIN Bolgeler     b   ON sh.BolgeID    = b.BolgeID
        WHERE s.Durum = 'Tamamlandı'
          AND CAST(s.SiparisTarihi AS DATE) BETWEEN @BaslangicTarihi AND @BitisTarihi
          AND (@KategoriID IS NULL OR u.KategoriID = @KategoriID)
        GROUP BY b.BolgeAdi, sh.SehirAdi, k.KategoriAdi
    )
    SELECT
        BolgeAdi,
        SehirAdi,
        KategoriAdi,
        SiparisAdedi,
        BenzersizMusteri,
        ToplamAdet,
        ToplamCiro,
        ToplamBrutKar,
        ROUND(
            ToplamBrutKar / NULLIF(ToplamCiro, 0) * 100,
        2)                                                                       AS KarMarjiYuzdesi,
        OrtSepetTutari,
        -- Şehrin bölge içindeki ciro payı
        ROUND(
            ToplamCiro / NULLIF(SUM(ToplamCiro) OVER (PARTITION BY BolgeAdi), 0) * 100,
        2)                                                                       AS BolgeIciCiroPayi,
        -- Şehrin genel toplam içindeki ciro payı
        ROUND(
            ToplamCiro / NULLIF(SUM(ToplamCiro) OVER (), 0) * 100,
        2)                                                                       AS GenelCiroPayi,
        -- Bölge içi ciro sırası
        RANK() OVER (
            PARTITION BY BolgeAdi
            ORDER BY ToplamCiro DESC
        )                                                                        AS BolgeIciSira,
        -- Genel sıra
        RANK() OVER (ORDER BY ToplamCiro DESC)                                   AS GenelSira
    FROM BolgeDetay
    ORDER BY BolgeAdi, ToplamCiro DESC;
END;
GO
