-- =============================================
-- 01_VERITABANI.SQL
-- Veritabanı oluşturma scripti
-- =============================================

USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PerakendeSatisDB')
BEGIN
    ALTER DATABASE PerakendeSatisDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE PerakendeSatisDB;
END
GO

CREATE DATABASE PerakendeSatisDB
    COLLATE Turkish_CI_AS;
GO

USE PerakendeSatisDB;
GO

PRINT 'PerakendeSatisDB başarıyla oluşturuldu.';
GO
