-- =============================================
-- 03_ORNEK_VERI.SQL
-- Örnek veri yükleme scripti
-- Toplam: 160 ürün | 500 müşteri | 20 temsilci
--         15.000 sipariş | ~45.000 sipariş detayı
-- Tarih aralığı: Ocak 2023 – Aralık 2024
-- =============================================

USE PerakendeSatisDB;
GO

-- =============================================
-- 1. BÖLGELER
-- =============================================
INSERT INTO Bolgeler (BolgeAdi) VALUES
('Marmara'),
('Ege'),
('İç Anadolu'),
('Akdeniz'),
('Karadeniz'),
('Doğu Anadolu'),
('Güneydoğu Anadolu');
GO

-- =============================================
-- 2. ŞEHİRLER (27 şehir)
-- =============================================
INSERT INTO Sehirler (SehirAdi, BolgeID) VALUES
-- Marmara (BolgeID=1)
('İstanbul', 1), ('Bursa', 1), ('Kocaeli', 1), ('Tekirdağ', 1), ('Sakarya', 1),
-- Ege (BolgeID=2)
('İzmir', 2), ('Manisa', 2), ('Denizli', 2), ('Aydın', 2), ('Muğla', 2),
-- İç Anadolu (BolgeID=3)
('Ankara', 3), ('Konya', 3), ('Kayseri', 3), ('Eskişehir', 3),
-- Akdeniz (BolgeID=4)
('Antalya', 4), ('Adana', 4), ('Mersin', 4), ('Hatay', 4),
-- Karadeniz (BolgeID=5)
('Samsun', 5), ('Trabzon', 5), ('Ordu', 5),
-- Doğu Anadolu (BolgeID=6)
('Erzurum', 6), ('Malatya', 6), ('Van', 6),
-- Güneydoğu Anadolu (BolgeID=7)
('Gaziantep', 7), ('Diyarbakır', 7), ('Şanlıurfa', 7);
GO

-- =============================================
-- 3. KATEGORİLER
-- =============================================
INSERT INTO Kategoriler (KategoriAdi) VALUES
('Elektronik'),
('Giyim & Aksesuar'),
('Ev & Yaşam'),
('Spor & Outdoor'),
('Kozmetik & Kişisel Bakım'),
('Kitap & Kırtasiye'),
('Gıda & İçecek'),
('Oyuncak & Hobi');
GO

-- =============================================
-- 4. ÜRÜNLER (160 ürün — 20 per kategori)
-- =============================================
INSERT INTO Urunler (UrunKodu, UrunAdi, KategoriID, BirimFiyat, Maliyet, StokMiktari) VALUES
-- Elektronik (KategoriID=1)
('ELK-001', 'Samsung Galaxy S24 128GB',               1, 32999.00, 22000.00, 150),
('ELK-002', 'Apple iPhone 15 128GB',                  1, 44999.00, 30000.00, 120),
('ELK-003', 'Xiaomi Redmi Note 13 Pro 256GB',         1, 12999.00,  8500.00, 200),
('ELK-004', 'Huawei P60 Pro 256GB',                   1, 28999.00, 19000.00,  80),
('ELK-005', 'ASUS ROG Phone 7 Ultimate',              1, 39999.00, 27000.00,  60),
('ELK-006', 'Lenovo IdeaPad 3 15 i5 16GB',            1, 19999.00, 13500.00, 100),
('ELK-007', 'HP Pavilion 15 i7 16GB',                 1, 26999.00, 18000.00,  75),
('ELK-008', 'Dell Inspiron 15 3000 i5',               1, 17999.00, 12000.00,  90),
('ELK-009', 'Apple MacBook Air M2 8GB',               1, 54999.00, 37000.00,  50),
('ELK-010', 'Logitech MX Master 3S Mouse',            1,  2299.00,  1400.00, 300),
('ELK-011', 'Razer DeathAdder V3 Pro Mouse',          1,  1899.00,  1100.00, 250),
('ELK-012', 'HP LaserJet Pro M404n Yazıcı',           1,  4999.00,  3200.00,  80),
('ELK-013', 'Canon PIXMA G3420 Yazıcı',               1,  3999.00,  2600.00, 100),
('ELK-014', 'Sony WH-1000XM5 Kablosuz Kulaklık',      1,  8999.00,  5800.00, 120),
('ELK-015', 'JBL Charge 5 Bluetooth Hoparlör',        1,  3499.00,  2200.00, 180),
('ELK-016', 'Anker PowerCore 26800 Powerbank',        1,   899.00,   550.00, 400),
('ELK-017', 'Samsung 55" Crystal UHD 4K TV',          1, 18999.00, 12500.00,  60),
('ELK-018', 'Xiaomi Smart TV A2 43"',                 1,  9999.00,  6500.00,  80),
('ELK-019', 'LG OLED evo C3 48"',                    1, 39999.00, 27000.00,  30),
('ELK-020', 'Philips Hue White & Color Starter Kit',  1,  1999.00,  1200.00, 200),
-- Giyim & Aksesuar (KategoriID=2)
('GYM-001', 'Nike Air Max 90 Erkek',                  2,  3499.00,  2000.00, 200),
('GYM-002', 'Adidas Ultraboost 23',                   2,  4299.00,  2500.00, 150),
('GYM-003', 'Puma RS-X Unisex',                       2,  2599.00,  1500.00, 180),
('GYM-004', 'Levi''s 501 Original Kot Pantolon',      2,  1899.00,  1000.00, 300),
('GYM-005', 'Lee Regular Fit Jean',                   2,  1299.00,   750.00, 250),
('GYM-006', 'Zara Oversize Pamuklu Tişört',           2,   299.00,   150.00, 500),
('GYM-007', 'H&M Relaxed Fit Sweatshirt',             2,   499.00,   260.00, 400),
('GYM-008', 'Mavi Regular Fit Oxford Gömlek',         2,   699.00,   380.00, 350),
('GYM-009', 'Lacoste L1212 Polo Tişört',              2,  2399.00,  1400.00, 200),
('GYM-010', 'Tommy Hilfiger Essential Bomber',        2,  3799.00,  2200.00, 100),
('GYM-011', 'Columbia Silver Ridge Utility Gömlek',   2,  1499.00,   900.00, 150),
('GYM-012', 'The North Face Resolve Yağmurluk',       2,  3299.00,  1900.00, 100),
('GYM-013', 'Casio G-Shock GA-2100 Siyah',           2,  3599.00,  2100.00, 120),
('GYM-014', 'Fossil Townsman Deri Kol Saati',         2,  4299.00,  2600.00,  80),
('GYM-015', 'Ray-Ban Aviator Classic Güneş Gözlüğü', 2,  2999.00,  1800.00, 100),
('GYM-016', 'Fossil Derbi Bifold Cüzdan',             2,   999.00,   580.00, 200),
('GYM-017', 'Samsonite Guardit 2.0 Sırt Çantası',    2,  2499.00,  1500.00, 150),
('GYM-018', 'Kipling City L Sırt Çantası',            2,  1899.00,  1100.00, 120),
('GYM-019', 'Timberland 6" Premium Boot',             2,  3999.00,  2300.00, 100),
('GYM-020', 'Vans Old Skool Unisex',                  2,  1799.00,  1000.00, 200),
-- Ev & Yaşam (KategoriID=3)
('EYS-001', 'Tefal Ultracompact 2in1 Tost Makinesi',  3,   899.00,   500.00, 200),
('EYS-002', 'Philips Airfryer XXL HD9630',             3,  2299.00,  1400.00, 150),
('EYS-003', 'Bosch ErgoMixx MSM6700 El Blenderi',     3,   999.00,   600.00, 180),
('EYS-004', 'Arçelik K-8720 Çift Demlikli Çaydanlık', 3,   799.00,   450.00, 220),
('EYS-005', 'Fakir Kalos Pro Kahve Makinesi',          3,  1299.00,   750.00, 130),
('EYS-006', 'Karaca Classica 7 Parça Tencere Seti',   3,  1999.00,  1200.00, 100),
('EYS-007', 'English Home Saten Çift Nevresim Takımı',3,   699.00,   380.00, 250),
('EYS-008', 'Madame Coco Bambu Havlu Seti 4lü',       3,   499.00,   270.00, 300),
('EYS-009', 'Bellona Visco Memory Yastık',             3,   599.00,   320.00, 200),
('EYS-010', 'Taç Pure Cotton King Battaniye',          3,   799.00,   430.00, 180),
('EYS-011', 'Linens Çift Kişilik Pike Yatak Örtüsü',  3,   449.00,   240.00, 220),
('EYS-012', 'Paşabahçe Nude 6lı Bardak Seti',         3,   299.00,   160.00, 350),
('EYS-013', 'Karaca Tivoli 24 Parça Çay Takımı',      3,   899.00,   500.00, 150),
('EYS-014', 'Homend Tornet 2200W Süpürge',             3,  1499.00,   900.00, 120),
('EYS-015', 'Rowenta DW9100 Pro Buharlı Ütü',          3,   899.00,   520.00, 150),
('EYS-016', 'Remington D5215 Saç Kurutma Makinesi',   3,   799.00,   450.00, 180),
('EYS-017', 'Nurus Origin Pro Ofis Sandalyesi',        3,  4999.00,  3000.00,  50),
('EYS-018', 'Kanvas Dekoratif Tablo Set 3lü',          3,   399.00,   200.00, 300),
('EYS-019', 'Philips HR1921 800W Blender',             3,   699.00,   400.00, 200),
('EYS-020', 'Tefal Daily Cook Granit 3lü Tava Seti',  3,  1099.00,   650.00, 130),
-- Spor & Outdoor (KategoriID=4)
('SPO-001', 'Decathlon Yoga Matı 5mm NBR',             4,   299.00,   150.00, 300),
('SPO-002', 'Wilson Tour Slam Tenis Raketi',           4,  1299.00,   750.00, 100),
('SPO-003', 'Head Ti S6 Badminton Raketi',             4,   799.00,   450.00, 120),
('SPO-004', 'Spalding NBA Varsity Basketbol Topu',     4,   899.00,   520.00, 150),
('SPO-005', 'Mikasa MVA200 Voleybol Topu',             4,  1199.00,   700.00, 100),
('SPO-006', 'Adidas Finale Club Futbol Topu No5',      4,   699.00,   400.00, 200),
('SPO-007', 'Merrell Moab Speed Yürüyüş Botu',        4,  3299.00,  1900.00,  80),
('SPO-008', 'Osprey Talon 22 Sırt Çantası',           4,  3999.00,  2400.00,  60),
('SPO-009', 'Deuter Speed Lite 20 Trekking Çantası',  4,  2799.00,  1700.00,  70),
('SPO-010', 'Garmin Fenix 7S GPS Multisport Saat',    4, 24999.00, 16000.00,  30),
('SPO-011', 'Polar Vantage M2 Spor Saati',             4,  9999.00,  6500.00,  50),
('SPO-012', 'Gorilla Sports Dambıl Seti 20kg',        4,  1999.00,  1200.00,  80),
('SPO-013', 'Adidas Training Fitness Eldiveni',        4,   499.00,   280.00, 200),
('SPO-014', 'Rehband Rx Diz Desteği 7mm',              4,   899.00,   520.00, 150),
('SPO-015', 'CamelBak Chute Mag 750ml',                4,   599.00,   340.00, 200),
('SPO-016', 'Buff CoolNet UV+ Boyunluk',               4,   399.00,   210.00, 250),
('SPO-017', 'Black Diamond Spot 400 Kafa Feneri',      4,   799.00,   460.00, 100),
('SPO-018', 'Forclaz Trek 500 -5°C Uyku Tulumu',      4,  1499.00,   880.00,  80),
('SPO-019', 'Quechua NH500 Yürüyüş Botu',              4,   899.00,   520.00, 150),
('SPO-020', 'Domyos Boxing 900 Boks Eldiveni 12oz',   4,   699.00,   400.00, 120),
-- Kozmetik & Kişisel Bakım (KategoriID=5)
('KZM-001', 'Dove Original Duş Jeli 500ml',            5,    89.00,    45.00, 500),
('KZM-002', 'Pantene Pro-V Şampuan 700ml',             5,   119.00,    60.00, 500),
('KZM-003', 'Head & Shoulders Classic Şampuan 675ml',  5,   109.00,    55.00, 500),
('KZM-004', 'Nivea Men Sensitive Tıraş Jeli 200ml',    5,   129.00,    65.00, 400),
('KZM-005', 'Gillette Fusion ProGlide 8li Yedek',      5,   349.00,   180.00, 300),
('KZM-006', 'L''Oreal Revitalift Classic Günlük Krem', 5,   299.00,   150.00, 250),
('KZM-007', 'Neutrogena Ultra Sheer SPF50+ 50ml',      5,   229.00,   115.00, 300),
('KZM-008', 'MAC Studio Fix Fluid Fondöten N4',        5,   999.00,   550.00, 150),
('KZM-009', 'Maybelline Fit Me Matte Fondöten 120',    5,   299.00,   150.00, 300),
('KZM-010', 'NARS Satin Lip Pencil - Red Square',      5,   699.00,   380.00, 200),
('KZM-011', 'Charlotte Tilbury Brow Lift Kalem',       5,   899.00,   490.00, 150),
('KZM-012', 'Benefit BADgal BANG! Maskara',            5,   799.00,   440.00, 200),
('KZM-013', 'Oral-B Smart 4 4000N Diş Fırçası',       5,  1299.00,   750.00, 120),
('KZM-014', 'Philips Lumea IPL BRI956 Epilasyon',      5,  9999.00,  6000.00,  40),
('KZM-015', 'Remington S9500 Keratin Saç Düzleştirici',5, 1499.00,   880.00, 100),
('KZM-016', 'BaByliss C332E Pro 32mm Maşa',           5,  1199.00,   700.00, 100),
('KZM-017', 'The Ordinary Retinol 0.5% 30ml',          5,   399.00,   200.00, 200),
('KZM-018', 'Vichy Mineral 89 Hyaluronik Serum 50ml',  5,   699.00,   380.00, 150),
('KZM-019', 'Garnier Micellar Temizleme Suyu 400ml',   5,   129.00,    65.00, 400),
('KZM-020', 'Eucerin Hyaluron-Filler Günlük Krem',     5,   499.00,   270.00, 200),
-- Kitap & Kırtasiye (KategoriID=6)
('KRT-001', 'Moleskine Classic Sert Kapak Defter A5',  6,   399.00,   200.00, 300),
('KRT-002', 'Leuchtturm1917 Bullet Journal A5',        6,   499.00,   260.00, 250),
('KRT-003', 'Staedtler Mars 0.3-0.7 Teknik Kalem Seti',6,   299.00,   150.00, 300),
('KRT-004', 'Faber-Castell Kuru Boya 48li Kutu',       6,   349.00,   180.00, 250),
('KRT-005', 'Pentel EnerGel BL77 12li Kalem Seti',     6,   199.00,   100.00, 350),
('KRT-006', 'Parker Jotter Dolma Kalem Siyah',         6,   599.00,   320.00, 150),
('KRT-007', 'Cross Bailey Medalist Tükenmez Kalem',    6,   799.00,   440.00, 120),
('KRT-008', 'Casio FX-991ES PLUS-2 Hesap Makinesi',   6,   699.00,   380.00, 200),
('KRT-009', 'Canon P23-DHV Masaüstü Hesap Makinesi',  6,  1499.00,   900.00,  80),
('KRT-010', 'Arteza Profesyonel Akrilik Boya 24lü',    6,   599.00,   320.00, 150),
('KRT-011', 'Derwent Colorsoft Renkli Kalem 72li',     6,   899.00,   490.00, 100),
('KRT-012', 'Koh-I-Noor Watercolour Sulu Boya 24lü',   6,   699.00,   380.00, 120),
('KRT-013', 'Pebeo Studio Akrilik Boya Seti 12x100ml', 6,   499.00,   270.00, 150),
('KRT-014', 'Leitz 180° Binder Klasör 5li',            6,   399.00,   210.00, 200),
('KRT-015', 'Esselte Multifile Askılı Dosya 25li',     6,   299.00,   150.00, 250),
('KRT-016', 'Scotch Magic Tape 19mm x 33m 12li',       6,   149.00,    75.00, 400),
('KRT-017', 'Post-it Super Sticky 76x76 6lı Paket',    6,   179.00,    90.00, 400),
('KRT-018', 'Sanat Çizim Defteri A3 140g 50 Yaprak',   6,   249.00,   125.00, 200),
('KRT-019', 'Staedtler Neon Fosforlu Kalem 6lı',       6,    99.00,    50.00, 500),
('KRT-020', 'Maped Geometri Takımı 9 Parça Metal',     6,   149.00,    75.00, 300),
-- Gıda & İçecek (KategoriID=7)
('GDA-001', 'Nescafe Gold Kahve 200g',                 7,   299.00,   160.00, 300),
('GDA-002', 'Lavazza Espresso Italiano 1kg',           7,   599.00,   320.00, 200),
('GDA-003', 'Jacobs Krönung Filtre Kahve 500g',        7,   349.00,   190.00, 250),
('GDA-004', 'Tchibo Exclusive Filtre Kahve 250g',      7,   249.00,   130.00, 300),
('GDA-005', 'Lipton Yellow Label Poşet Çay 100lü',     7,   179.00,    90.00, 400),
('GDA-006', 'Ahmad Tea English Breakfast 100lü',       7,   299.00,   160.00, 250),
('GDA-007', 'Red Bull Energy Drink 24x250ml',          7,   999.00,   580.00, 150),
('GDA-008', 'Monster Energy Original 24x500ml',        7,   999.00,   580.00, 150),
('GDA-009', 'Evian Doğal Maden Suyu 1.5lt 12li',      7,   299.00,   160.00, 200),
('GDA-010', 'Perrier Köpüklü Su 330ml 24lü',           7,   399.00,   220.00, 150),
('GDA-011', 'Ülker Bitter Çikolata Hediye Kutusu 400g',7,   299.00,   160.00, 300),
('GDA-012', 'Godiva Karışık Pralin 36lı Gold Kutu',    7,   699.00,   400.00, 150),
('GDA-013', 'Ferrero Rocher Çikolata 30lu Kutu',       7,   499.00,   280.00, 200),
('GDA-014', 'Toblerone Karışık Çikolata 3lü Set',      7,   349.00,   190.00, 250),
('GDA-015', 'Häagen-Dazs Premium Dondurma 4lü Set',   7,   499.00,   280.00, 100),
('GDA-016', 'Pringles Jumbo Original 6lı Set',         7,   399.00,   220.00, 200),
('GDA-017', 'Haribo Happy Cola Gummibärchen 1kg',      7,   299.00,   160.00, 250),
('GDA-018', 'Tariş Sızma Zeytinyağı Natürel 5lt',      7,  1299.00,   750.00, 100),
('GDA-019', 'Kuruyemiş Karma Premium Mix 500g',        7,   349.00,   190.00, 200),
('GDA-020', 'Doğuş Çay Filtreli Premium 250g 6lı',     7,   449.00,   240.00, 150),
-- Oyuncak & Hobi (KategoriID=8)
('OYN-001', 'LEGO Technic Formula E 42156',            8,  2499.00,  1500.00,  80),
('OYN-002', 'LEGO Creator Egzotik Papağan 31136',      8,   599.00,   340.00, 150),
('OYN-003', 'LEGO Icons Botanica Buket 10280',         8,  1799.00,  1050.00, 100),
('OYN-004', 'Playmobil City Life Okul Seti 71328',     8,  1299.00,   750.00,  80),
('OYN-005', 'Barbie Dreamhouse Oyun Seti',             8,  3999.00,  2400.00,  50),
('OYN-006', 'Hot Wheels Track Builder Ultimate Garage',8,  1499.00,   880.00,  70),
('OYN-007', 'Funko Pop Marvel Avengers 4lü Set',       8,   999.00,   580.00, 120),
('OYN-008', 'Funko Pop DC Justice League 4lü Set',     8,   999.00,   580.00, 120),
('OYN-009', 'Ravensburger 1000 Parça İstanbul Puzzle', 8,   499.00,   280.00, 150),
('OYN-010', 'Clementoni High Quality 2000 Parça',      8,   699.00,   400.00, 100),
('OYN-011', 'Monopoly Türkiye Özel Baskı',             8,   699.00,   400.00, 120),
('OYN-012', 'Catan Türkçe Kutu Oyunu',                 8,  1299.00,   750.00,  80),
('OYN-013', 'Ticket to Ride Avrupa',                   8,  1499.00,   880.00,  60),
('OYN-014', 'Dixit Türkçe Kutu Oyunu',                 8,   899.00,   520.00, 100),
('OYN-015', 'UNO Flip Türkçe',                         8,   299.00,   160.00, 200),
('OYN-016', 'Satranç Seti Ahşap Premium Gürgen',       8,   499.00,   280.00, 150),
('OYN-017', 'Rubik''s Cube 3x3 Orijinal Stickerli',   8,   299.00,   160.00, 200),
('OYN-018', 'Drift Oyuncak Pro RC Drift Araba 1/14',   8,   899.00,   520.00, 100),
('OYN-019', 'Nintendo Switch Oyun Koleksiyonu 3lü',    8,  2499.00,  1500.00,  60),
('OYN-020', 'Revell Maket Uçak DIY Set Premium',       8,   599.00,   340.00, 100);
GO

-- =============================================
-- 5. SATIŞ TEMSİLCİLERİ (20 temsilci)
-- =============================================
INSERT INTO SatisTemsilcileri (Ad, Soyad, BolgeID, YillikHedef, IseGirisTarihi) VALUES
('Mehmet',  'Yılmaz',  1, 6000000.00, '2019-03-15'),
('Ayşe',    'Kaya',    1, 6000000.00, '2020-07-01'),
('Mustafa', 'Demir',   1, 6000000.00, '2018-11-20'),
('Zeynep',  'Şahin',   1, 5500000.00, '2021-02-10'),
('Tolga',   'Polat',   1, 5500000.00, '2017-05-10'),
('Ali',     'Çelik',   2, 4000000.00, '2019-06-15'),
('Fatma',   'Yıldız',  2, 4000000.00, '2020-04-01'),
('İbrahim', 'Öztürk',  2, 3500000.00, '2021-09-01'),
('Merve',   'Aydın',   3, 4500000.00, '2019-01-15'),
('Hasan',   'Arslan',  3, 4500000.00, '2020-03-10'),
('Elif',    'Doğan',   3, 4000000.00, '2022-01-10'),
('Ceren',   'Çakır',   3, 4000000.00, '2018-09-20'),
('Ömer',    'Kılıç',   4, 3500000.00, '2019-08-01'),
('Esra',    'Aslan',   4, 3500000.00, '2021-05-15'),
('Burak',   'Çetin',   5, 3000000.00, '2020-09-01'),
('Selin',   'Koç',     5, 3000000.00, '2022-03-01'),
('Emre',    'Kurt',    6, 2500000.00, '2021-01-10'),
('Büşra',   'Şimşek',  6, 2500000.00, '2022-06-01'),
('Murat',   'Aksoy',   7, 2500000.00, '2020-11-15'),
('Gamze',   'Güneş',   7, 2500000.00, '2021-07-01');
GO

-- =============================================
-- 6. MÜŞTERİLER (500 müşteri — programatik)
-- =============================================
DECLARE @ErkekIsimleri TABLE (ID INT IDENTITY(1,1), Isim NVARCHAR(50));
INSERT INTO @ErkekIsimleri VALUES
('Mehmet'),('Mustafa'),('Ahmet'),('Ali'),('Hüseyin'),
('İbrahim'),('Hasan'),('İsmail'),('Ömer'),('Murat'),
('Emre'),('Burak'),('Serkan'),('Fatih'),('Okan'),
('Volkan'),('Kemal'),('Selim'),('Tarık'),('Orhan'),
('Çağrı'),('Uğur'),('Barış'),('Erkan'),('Tolga');

DECLARE @KadinIsimleri TABLE (ID INT IDENTITY(1,1), Isim NVARCHAR(50));
INSERT INTO @KadinIsimleri VALUES
('Ayşe'),('Fatma'),('Zeynep'),('Elif'),('Emine'),
('Hatice'),('Merve'),('Esra'),('Büşra'),('Selin'),
('Gamze'),('Ceren'),('Derya'),('Gül'),('Sevgi'),
('Pınar'),('Tuğba'),('Özge'),('Deniz'),('Yıldız'),
('Ece'),('İpek'),('Beren'),('Cansu'),('Dilan');

DECLARE @Soyadlar TABLE (ID INT IDENTITY(1,1), Soyad NVARCHAR(50));
INSERT INTO @Soyadlar VALUES
('Yılmaz'),('Kaya'),('Demir'),('Şahin'),('Çelik'),
('Yıldız'),('Yıldırım'),('Öztürk'),('Aydın'),('Özdemir'),
('Arslan'),('Doğan'),('Kılıç'),('Aslan'),('Çetin'),
('Koç'),('Kurt'),('Aksoy'),('Şimşek'),('Polat'),
('Güneş'),('Kaplan'),('Çakır'),('Erdoğan'),('Karahan');

WITH Sayilar AS (
    SELECT TOP 500 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
)
INSERT INTO Musteriler (MusteriKodu, MusteriAdi, SehirID, Segment, KayitTarihi)
SELECT
    'MUS-' + RIGHT('00000' + CAST(N AS VARCHAR(6)), 5),
    CASE WHEN N % 2 = 0
        THEN (SELECT Isim FROM @ErkekIsimleri WHERE ID = (N % 25) + 1)
        ELSE (SELECT Isim FROM @KadinIsimleri WHERE ID = (N % 25) + 1)
    END + ' ' + (SELECT Soyad FROM @Soyadlar WHERE ID = ((N + 7) % 25) + 1),
    (N % 27) + 1,
    CASE (N % 6)
        WHEN 0 THEN 'Kurumsal'
        WHEN 1 THEN 'Kurumsal'
        WHEN 2 THEN 'KOBİ'
        WHEN 3 THEN 'KOBİ'
        ELSE 'Bireysel'
    END,
    DATEADD(DAY, -((N * 547 + 213) % 1825), '2024-12-31')
FROM Sayilar;
GO

-- =============================================
-- 7. SİPARİŞLER (15.000 sipariş — programatik)
-- Tarih aralığı: Ocak 2023 – Aralık 2024 (730 gün)
-- =============================================
WITH Sayilar AS (
    SELECT TOP 15000 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS N
    FROM sys.all_objects a CROSS JOIN sys.all_objects b
),
SiparisRandom AS (
    SELECT
        N,
        ABS(CHECKSUM(NEWID())) % 730  AS GunOncesi,
        ABS(CHECKSUM(NEWID())) % 500  AS MusteriIdx,
        ABS(CHECKSUM(NEWID())) % 20   AS TemsilciIdx,
        ABS(CHECKSUM(NEWID())) % 100  AS DurumSayi,
        ABS(CHECKSUM(NEWID())) % 13   AS TeslimatEkGun
    FROM Sayilar
)
INSERT INTO Siparisler (SiparisNo, MusteriID, TemsilciID, SiparisTarihi, TeslimatTarihi, Durum)
SELECT
    'SIP-' + RIGHT('000000' + CAST(N AS VARCHAR(6)), 6),
    MusteriIdx + 1,
    TemsilciIdx + 1,
    DATEADD(DAY, -GunOncesi, '2024-12-31'),
    CASE
        WHEN DurumSayi < 75 THEN DATEADD(DAY, -GunOncesi + TeslimatEkGun + 1, '2024-12-31')
        WHEN DurumSayi < 90 THEN DATEADD(DAY, -GunOncesi + TeslimatEkGun + 1, '2024-12-31')
        ELSE NULL
    END,
    CASE
        WHEN DurumSayi < 75 THEN 'Tamamlandı'
        WHEN DurumSayi < 85 THEN 'Kargoda'
        WHEN DurumSayi < 93 THEN 'Beklemede'
        ELSE 'İptal'
    END
FROM SiparisRandom;
GO

-- =============================================
-- 8. SİPARİŞ DETAY (~45.000 satır — programatik)
-- Her sipariş için 2-4 ürün kalemi
-- Temp tablo: NEWID() CTE'de iki kez değerlendirilirse
-- farklı UrunID üretilebileceğinden önce materialize ediyoruz.
-- =============================================

-- Rastgele ham veriyi materialize et
SELECT
    sl.SiparisID,
    kn.KalemNo,
    ABS(CHECKSUM(NEWID())) % 160 + 1  AS UrunID,
    ABS(CHECKSUM(NEWID())) % 9  + 1   AS Miktar,
    ABS(CHECKSUM(NEWID())) % 100      AS IskontoSayi
INTO #DetayRaw
FROM (SELECT SiparisID, 2 + (SiparisID % 3) AS HedefKalemSayisi FROM Siparisler) sl
CROSS JOIN (VALUES(1),(2),(3),(4)) kn(KalemNo)
WHERE kn.KalemNo <= sl.HedefKalemSayisi;

-- Aynı sipariş içinde tekrarlayan UrunID'yi temizle, ardından ekle
INSERT INTO SiparisDetay (SiparisID, UrunID, Miktar, BirimFiyat, IskontoOrani)
SELECT
    d.SiparisID,
    d.UrunID,
    d.Miktar,
    u.BirimFiyat,
    CASE
        WHEN d.IskontoSayi < 55 THEN 0.00
        WHEN d.IskontoSayi < 75 THEN 5.00
        WHEN d.IskontoSayi < 88 THEN 10.00
        WHEN d.IskontoSayi < 96 THEN 15.00
        ELSE 20.00
    END
FROM (
    SELECT *,
        ROW_NUMBER() OVER (PARTITION BY SiparisID, UrunID ORDER BY KalemNo) AS RN
    FROM #DetayRaw
) d
INNER JOIN Urunler u ON u.UrunID = d.UrunID
WHERE d.RN = 1;

DROP TABLE #DetayRaw;
GO

-- =============================================
-- DOĞRULAMA
-- =============================================
SELECT 'Bölge'           AS Tablo, COUNT(*) AS SatirSayisi FROM Bolgeler         UNION ALL
SELECT 'Şehir'           AS Tablo, COUNT(*) AS SatirSayisi FROM Sehirler          UNION ALL
SELECT 'Kategori'        AS Tablo, COUNT(*) AS SatirSayisi FROM Kategoriler       UNION ALL
SELECT 'Ürün'            AS Tablo, COUNT(*) AS SatirSayisi FROM Urunler           UNION ALL
SELECT 'Müşteri'         AS Tablo, COUNT(*) AS SatirSayisi FROM Musteriler        UNION ALL
SELECT 'Satış Temsilcisi'AS Tablo, COUNT(*) AS SatirSayisi FROM SatisTemsilcileri UNION ALL
SELECT 'Sipariş'         AS Tablo, COUNT(*) AS SatirSayisi FROM Siparisler        UNION ALL
SELECT 'Sipariş Detay'   AS Tablo, COUNT(*) AS SatirSayisi FROM SiparisDetay;
GO
