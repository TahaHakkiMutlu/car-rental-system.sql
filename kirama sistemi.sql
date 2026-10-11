CREATE DATABASE araç_kiralama_sistemi;

-- 1. En yüksek günlük ücrete göre sıralı araç kiralamaları
SELECT a.Marka, a.Model, a.GunlukUcret, k.BaslangicTarihi
FROM Kiralamalar k
JOIN Araclar a ON k.Arac_id = a.Arac_id
ORDER BY a.GunlukUcret DESC;

-- 2. Her müşterinin kaç kez kiralama yaptığı
SELECT m.Ad, m.Soyad, COUNT(k.Kiralama_id) AS KiralamaSayisi
FROM Musteriler m
JOIN Kiralamalar k ON m.Musteri_id = k.Musteri_id
GROUP BY m.Musteri_id;

-- 3. Hatalı sorgu: Hizmetler tablosu kendisiyle iki kez JOIN edilmiş (çift "h" kullanımı hatalı)
-- DÜZELTİLMİŞ HALİ AŞAĞIDA

-- 3. Düzeltilmiş: Hizmetlerin kaç kez alındığı
SELECT h.HizmetAdi, COUNT(*) AS KacKereAlinmis
FROM KiralananHizmetler kh
JOIN Hizmetler h ON kh.Hizmet_id = h.Hizmet_id
GROUP BY h.Hizmet_id;

-- 4. Tüm araçlar tablosunu listeleme (tam tablo adıyla)
SELECT * FROM arac_kiralama_sistemi.araclar;


-- - -- - - - -

-- 1. Şu anda kirada olan araçların müşteri ve araç bilgileri
SELECT m.Ad, m.Soyad, a.Marka, a.Model, k.BaslangicTarihi, k.BitisTarihi
FROM Kiralamalar k
JOIN Musteriler m ON k.Musteri_id = m.Musteri_id
JOIN Araclar a ON k.Arac_id = a.Arac_id
WHERE a.Durum = 'Kirada';

-- 2. En yüksek günlük ücrete göre araç kiralama bilgileri
SELECT a.Marka, a.Model, a.GunlukUcret, k.BaslangicTarihi
FROM Kiralamalar k
JOIN Araclar a ON k.Arac_id = a.Arac_id
ORDER BY a.GunlukUcret DESC;

-- 3. 2021 ve sonrası model yılına sahip, durumu uygun olan araçlar
SELECT * FROM Araclar
WHERE Yil >= 2021 AND Durum = 'Uygun';

-- 4. Müşteriler listesini soyada göre artan şekilde sırala
SELECT * FROM Musteriler
ORDER BY Soyad ASC;

-- 5. Her müşterinin toplam kiralama sayısı
SELECT m.Ad, m.Soyad, COUNT(k.Kiralama_id) AS KiralamaSayisi
FROM Musteriler m
JOIN Kiralamalar k ON m.Musteri_id = k.Musteri_id
GROUP BY m.Musteri_id;

-- 6. Her hizmetin kaç kez alındığı (doğru JOIN ile)
SELECT h.HizmetAdi, COUNT(*) AS KacKereAlinmis
FROM Kiralamalar_Hizmetler kh
JOIN Hizmetler h ON kh.Hizmet_id = h.Hizmet_id
GROUP BY h.Hizmet_id;

-- 7. Hatalı bir sorgu (aynı tabloya iki kez yanlış alias verilmiş)
-- Bu satır göz ardı edilebilir ya da silinmeli

-- 8. Belirli bir aracın durumunu 'Kirada' olarak güncelle
UPDATE Araclar
SET Durum = 'Kirada'
WHERE Arac_id = 3;

-- 9. 2019'dan önceki araçların günlük ücretini 100 artır
UPDATE Araclar
SET GunlukUcret = GunlukUcret + 100
WHERE Yil < 2019;

-- 10. SQL güvenli güncellemeyi devre dışı bırak (MySQL için)
SET SQL_SAFE_UPDATES = 0;

-- 11. (Yine) 2019'dan önceki araçların ücretini artır
UPDATE Araclar
SET GunlukUcret = GunlukUcret + 100
WHERE Yil < 2019;

-- 12. 2015'ten eski araçları sil
DELETE FROM Araclar
WHERE Yil < 2015;

-- 13. E-posta bilgisi olmayan müşterileri sil
DELETE FROM Musteriler
WHERE Email IS NULL OR Email = '';

-- 14. En az 4 kez kiralanmış araçların marka, model ve kiralama sayısı
SELECT a.Marka, a.Model, COUNT(k.Kiralama_id) AS KiralamaSayisi
FROM Araclar a
JOIN Kiralamalar k ON a.Arac_id = k.Arac_id
GROUP BY a.Arac_id
HAVING COUNT(k.Kiralama_id) > 3;

--- - -- - - -

-- ----------------------------------
-- VERİTABANI OLUŞTURMA VE KULLANMA
-- ----------------------------------

CREATE DATABASE arac_kiralama_sistemi;
USE arac_kiralama_sistemi;

-- ----------------------
-- TABLOLARI OLUŞTURMA
-- ----------------------

CREATE TABLE Araclar (
    Arac_id INT AUTO_INCREMENT PRIMARY KEY,
    Marka VARCHAR(50),
    Model VARCHAR(50),
    Yil INT,
    GunlukUcret DECIMAL(10,2),
    Durum VARCHAR(20)
);

CREATE TABLE Musteriler (
    Musteri_id INT AUTO_INCREMENT PRIMARY KEY,
    Ad VARCHAR(50),
    Soyad VARCHAR(50),
    Telefon VARCHAR(15),
    Email VARCHAR(50)
);

CREATE TABLE Hizmetler (
    Hizmet_id INT AUTO_INCREMENT PRIMARY KEY,
    HizmetAdi VARCHAR(50),
    Ucret DECIMAL(10,2)
);

CREATE TABLE Kiralamalar (
    Kiralama_id INT AUTO_INCREMENT PRIMARY KEY,
    Musteri_id INT,
    Arac_id INT,
    BaslangicTarihi DATE,
    BitisTarihi DATE,
    FOREIGN KEY (Musteri_id) REFERENCES Musteriler(Musteri_id),
    FOREIGN KEY (Arac_id) REFERENCES Araclar(Arac_id)
);

-- ----------------------------------
-- VERİ EKLEME (Araçlar, Müşteriler, Kiralamalar, Hizmetler)
-- ----------------------------------

INSERT INTO Araclar (Marka, Model, Yil, GunlukUcret, Durum) VALUES
('Renault', 'Clio', 2020, 500, 'Uygun'),
('Fiat', 'Egea', 2021, 550, 'Kirada'),
('Volkswagen', 'Golf', 2019, 600, 'Uygun'),
('Ford', 'Focus', 2018, 580, 'Bakımda'),
('Toyota', 'Corolla', 2022, 620, 'Uygun'),
('Opel', 'Corsa', 2017, 470, 'Kirada'),
('Hyundai', 'i20', 2021, 510, 'Uygun'),
('Honda', 'Civic', 2019, 650, 'Uygun'),
('Peugeot', '308', 2020, 560, 'Kirada'),
('Citroen', 'C3', 2018, 490, 'Bakımda'),
('Nissan', 'Qashqai', 2021, 700, 'Uygun'),
('Kia', 'Rio', 2020, 520, 'Uygun'),
('Mazda', '3', 2019, 680, 'Kirada'),
('Skoda', 'Octavia', 2022, 640, 'Uygun'),
('Seat', 'Leon', 2017, 550, 'Bakımda'),
('BMW', '3 Series', 2021, 900, 'Uygun'),
('Mercedes', 'A180', 2020, 950, 'Kirada'),
('Audi', 'A3', 2019, 920, 'Uygun'),
('Volvo', 'S60', 2021, 970, 'Bakımda'),
('Suzuki', 'Swift', 2018, 480, 'Uygun');

INSERT INTO Musteriler (Ad, Soyad, Telefon, Email) VALUES
('Ahmet', 'Yılmaz', '05551112233', 'ahmet@gmail.com'),
('Ayşe', 'Kaya', '05552223344', 'ayse@gmail.com'),
('Mehmet', 'Demir', '05553334455', 'mehmet@gmail.com'),
('Fatma', 'Çelik', '05554445566', 'fatma@gmail.com'),
('Ali', 'Şahin', '05555556677', 'ali@gmail.com'),
('Zeynep', 'Arslan', '05556667788', 'zeynep@gmail.com'),
('Mustafa', 'Doğan', '05557778899', 'mustafa@gmail.com'),
('Elif', 'Koç', '05558889900', 'elif@gmail.com'),
('Emre', 'Aydın', '05559990011', 'emre@gmail.com'),
('Hülya', 'Öztürk', '05560001122', 'hulya@gmail.com'),
('Burak', 'Kurt', '05561112233', 'burak@gmail.com'),
('Buse', 'Polat', '05562223344', 'buse@gmail.com'),
('Yusuf', 'Aksoy', '05563334455', 'yusuf@gmail.com'),
('Hatice', 'Karaca', '05564445566', 'hatice@gmail.com'),
('Murat', 'Yıldırım', '05565556677', 'murat@gmail.com'),
('Gözde', 'Taş', '05566667788', 'gozde@gmail.com'),
('Kemal', 'Eren', '05567778899', 'kemal@gmail.com'),
('Merve', 'Bal', '05568889900', 'merve@gmail.com'),
('Onur', 'Akar', '05569990011', 'onur@gmail.com'),
('Seda', 'Keskin', '05570001122', 'seda@gmail.com');

INSERT INTO Kiralamalar (Musteri_id, Arac_id, BaslangicTarihi, BitisTarihi) VALUES
(1,1,'2025-05-01','2025-05-05'),
(2,2,'2025-05-02','2025-05-06'),
(3,3,'2025-05-03','2025-05-07'),
(4,4,'2025-05-04','2025-05-08'),
(5,5,'2025-05-05','2025-05-09'),
(6,6,'2025-05-06','2025-05-10'),
(7,7,'2025-05-07','2025-05-11'),
(8,8,'2025-05-08','2025-05-12'),
(9,9,'2025-05-09','2025-05-13'),
(10,10,'2025-05-10','2025-05-14'),
(11,11,'2025-05-11','2025-05-15'),
(12,12,'2025-05-12','2025-05-16'),
(13,13,'2025-05-13','2025-05-17'),
(14,14,'2025-05-14','2025-05-18'),
(15,15,'2025-05-15','2025-05-19'),
(16,16,'2025-05-16','2025-05-20'),
(17,17,'2025-05-17','2025-05-21'),
(18,18,'2025-05-18','2025-05-22'),
(19,19,'2025-05-19','2025-05-23'),
(20,20,'2025-05-20','2025-05-24');

INSERT INTO Hizmetler (HizmetAdi, Ucret) VALUES
('Kasko Sigortası', 150),
('Ek Sürücü', 100),
('Bebek Koltuğu', 50),
('GPS', 75),
('Kar Zinciri', 40),
('Havalimanı Teslim', 200),
('Full Yakıt', 300),
('Hızlı Geçiş Etiketi', 90),
('Yol Yardım', 120),
('Lastik Değişimi', 80),
('Araç Temizleme', 60),
('Şehir Dışı Kullanım', 250),
('Mini Onarım', 130),
('Vale Hizmeti', 110),
('Check-in Hizmeti', 95),
('Vale Park', 85),
('Ek Bagaj', 70),
('Premium Sigorta', 350),
('Araç Yıkama', 45),
('Kış Lastiği', 160);

-- ----------------------------
-- ÖRNEK SORGULAR
-- ----------------------------

-- Tüm araçları listele
SELECT * FROM Araclar;

-- Müşteri listesini getir
SELECT * FROM Musteriler;

-- Tüm kiralama kayıtlarını göster
SELECT * FROM Kiralamalar;

-- Kirada olan araçları müşteri ve tarih bilgisi ile getir
SELECT m.Ad, m.Soyad, a.Marka, a.Model, k.BaslangicTarihi, k.BitisTarihi
FROM Kiralamalar k
JOIN Musteriler m ON k.Musteri_id = m.Musteri_id
JOIN Araclar a ON k.Arac_id = a.Arac_id
WHERE a.Durum = 'Kirada';


-- - - -- - - 

