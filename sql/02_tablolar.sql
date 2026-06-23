-- =============================================
-- 02_TABLOLAR.SQL
-- Tablo tanımları, kısıtlar ve indeksler
-- =============================================

USE PerakendeSatisDB;
GO

-- =============================================
-- LOOKUP TABLOLARI
-- =============================================

CREATE TABLE Bolgeler (
    BolgeID   INT           IDENTITY(1,1) PRIMARY KEY,
    BolgeAdi  NVARCHAR(50)  NOT NULL
);
GO

CREATE TABLE Sehirler (
    SehirID   INT           IDENTITY(1,1) PRIMARY KEY,
    SehirAdi  NVARCHAR(50)  NOT NULL,
    BolgeID   INT           NOT NULL,
    CONSTRAINT FK_Sehirler_Bolgeler FOREIGN KEY (BolgeID) REFERENCES Bolgeler(BolgeID)
);
GO

CREATE TABLE Kategoriler (
    KategoriID   INT           IDENTITY(1,1) PRIMARY KEY,
    KategoriAdi  NVARCHAR(100) NOT NULL
);
GO

-- =============================================
-- ANA TABLOLAR
-- =============================================

CREATE TABLE Urunler (
    UrunID       INT             IDENTITY(1,1) PRIMARY KEY,
    UrunKodu     NVARCHAR(20)    NOT NULL,
    UrunAdi      NVARCHAR(200)   NOT NULL,
    KategoriID   INT             NOT NULL,
    BirimFiyat   DECIMAL(10,2)   NOT NULL,
    Maliyet      DECIMAL(10,2)   NOT NULL,
    StokMiktari  INT             NOT NULL DEFAULT 0,
    AktifMi      BIT             NOT NULL DEFAULT 1,
    CONSTRAINT UQ_Urunler_UrunKodu UNIQUE (UrunKodu),
    CONSTRAINT CHK_Urunler_Fiyat   CHECK (BirimFiyat > 0),
    CONSTRAINT CHK_Urunler_Maliyet CHECK (Maliyet > 0 AND Maliyet < BirimFiyat),
    CONSTRAINT FK_Urunler_Kategoriler FOREIGN KEY (KategoriID) REFERENCES Kategoriler(KategoriID)
);
GO

CREATE TABLE Musteriler (
    MusteriID    INT           IDENTITY(1,1) PRIMARY KEY,
    MusteriKodu  NVARCHAR(20)  NOT NULL,
    MusteriAdi   NVARCHAR(200) NOT NULL,
    SehirID      INT           NOT NULL,
    Segment      NVARCHAR(30)  NOT NULL,
    KayitTarihi  DATE          NOT NULL,
    AktifMi      BIT           NOT NULL DEFAULT 1,
    CONSTRAINT UQ_Musteriler_MusteriKodu UNIQUE (MusteriKodu),
    CONSTRAINT CHK_Musteriler_Segment CHECK (Segment IN ('Kurumsal','KOBİ','Bireysel')),
    CONSTRAINT FK_Musteriler_Sehirler FOREIGN KEY (SehirID) REFERENCES Sehirler(SehirID)
);
GO

CREATE TABLE SatisTemsilcileri (
    TemsilciID     INT             IDENTITY(1,1) PRIMARY KEY,
    Ad             NVARCHAR(50)    NOT NULL,
    Soyad          NVARCHAR(50)    NOT NULL,
    BolgeID        INT             NOT NULL,
    YillikHedef    DECIMAL(14,2)   NOT NULL,
    IseGirisTarihi DATE            NOT NULL,
    AktifMi        BIT             NOT NULL DEFAULT 1,
    CONSTRAINT CHK_SatisTemsilcileri_Hedef CHECK (YillikHedef > 0),
    CONSTRAINT FK_SatisTemsilcileri_Bolgeler FOREIGN KEY (BolgeID) REFERENCES Bolgeler(BolgeID)
);
GO

CREATE TABLE Siparisler (
    SiparisID      INT           IDENTITY(1,1) PRIMARY KEY,
    SiparisNo      NVARCHAR(20)  NOT NULL,
    MusteriID      INT           NOT NULL,
    TemsilciID     INT           NOT NULL,
    SiparisTarihi  DATETIME      NOT NULL,
    TeslimatTarihi DATETIME      NULL,
    Durum          NVARCHAR(30)  NOT NULL DEFAULT 'Beklemede',
    CONSTRAINT UQ_Siparisler_SiparisNo UNIQUE (SiparisNo),
    CONSTRAINT CHK_Siparisler_Durum CHECK (Durum IN ('Tamamlandı','İptal','Beklemede','Kargoda')),
    CONSTRAINT CHK_Siparisler_Tarih CHECK (TeslimatTarihi IS NULL OR TeslimatTarihi >= SiparisTarihi),
    CONSTRAINT FK_Siparisler_Musteriler FOREIGN KEY (MusteriID) REFERENCES Musteriler(MusteriID),
    CONSTRAINT FK_Siparisler_SatisTemsilcileri FOREIGN KEY (TemsilciID) REFERENCES SatisTemsilcileri(TemsilciID)
);
GO

CREATE TABLE SiparisDetay (
    DetayID      INT           IDENTITY(1,1) PRIMARY KEY,
    SiparisID    INT           NOT NULL,
    UrunID       INT           NOT NULL,
    Miktar       INT           NOT NULL,
    BirimFiyat   DECIMAL(10,2) NOT NULL,
    IskontoOrani DECIMAL(5,2)  NOT NULL DEFAULT 0.00,
    CONSTRAINT CHK_SiparisDetay_Miktar   CHECK (Miktar > 0),
    CONSTRAINT CHK_SiparisDetay_Fiyat    CHECK (BirimFiyat > 0),
    CONSTRAINT CHK_SiparisDetay_Iskonto  CHECK (IskontoOrani BETWEEN 0 AND 50),
    CONSTRAINT UQ_SiparisDetay_SiparisUrun UNIQUE (SiparisID, UrunID),
    CONSTRAINT FK_SiparisDetay_Siparisler FOREIGN KEY (SiparisID) REFERENCES Siparisler(SiparisID),
    CONSTRAINT FK_SiparisDetay_Urunler    FOREIGN KEY (UrunID)    REFERENCES Urunler(UrunID)
);
GO

-- =============================================
-- PERFORMANS İNDEKSLERİ
-- =============================================

-- Siparisler: en sık sorgulanan kolonlar
CREATE NONCLUSTERED INDEX IX_Siparisler_SiparisTarihi
    ON Siparisler (SiparisTarihi)
    INCLUDE (MusteriID, TemsilciID, Durum);

CREATE NONCLUSTERED INDEX IX_Siparisler_MusteriID
    ON Siparisler (MusteriID);

CREATE NONCLUSTERED INDEX IX_Siparisler_TemsilciID
    ON Siparisler (TemsilciID);

CREATE NONCLUSTERED INDEX IX_Siparisler_Durum_Tarih
    ON Siparisler (Durum, SiparisTarihi);

-- SiparisDetay: join ve agregasyon için
CREATE NONCLUSTERED INDEX IX_SiparisDetay_SiparisID
    ON SiparisDetay (SiparisID)
    INCLUDE (UrunID, Miktar, BirimFiyat, IskontoOrani);

CREATE NONCLUSTERED INDEX IX_SiparisDetay_UrunID
    ON SiparisDetay (UrunID)
    INCLUDE (Miktar, BirimFiyat, IskontoOrani);

-- Urunler: kategori filtresi
CREATE NONCLUSTERED INDEX IX_Urunler_KategoriID
    ON Urunler (KategoriID)
    INCLUDE (UrunAdi, BirimFiyat, Maliyet);

-- Musteriler: şehir ve segment filtresi
CREATE NONCLUSTERED INDEX IX_Musteriler_SehirID
    ON Musteriler (SehirID);

CREATE NONCLUSTERED INDEX IX_Musteriler_Segment
    ON Musteriler (Segment);

PRINT 'Tablolar ve indeksler başarıyla oluşturuldu.';
GO
