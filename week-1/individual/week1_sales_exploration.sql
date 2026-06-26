--==============================
--Mitu rida selles tabelis on ? - 15234
SELECT COUNT(*) AS ridade_arv
FROM sales;

--==============================
--Millised veerud ja andmed tabelis on ? - Tabeli on 12 rida id, sale id, invoice id, sale date, customer id, product id,
--quantity, unit price,  total price, channel, store location ja payment method.
SELECT * FROM sales
LIMIT 10;

--==============================
--Tallinna kaupluse müügid ?
SELECT *
FROM sales
WHERE store_location ='Tallinn'
ORDER BY sale_date desc
LIMIT 15;

--==============================
--10 suurimat tehingut
SELECT *
FROM sales
ORDER BY total_price desc
LIMIT 10;

--==============================
--10 Väiksemat tehingut - Andmebaasis on suured vead kuna vähemalt 10 väiksemat tehingut on miinuses.
SELECT *
FROM sales
ORDER BY total_price ASC
LIMIT 10;

--==============================
--Otsime NULL väärtusi MItu rida, kus kliendi info on puudu ?
SELECT COUNT(*) - COUNT(customer_id) AS puuduv_klient
FROM sales;

--==============================
--Mitu rida on tabelis? Tabelis on 15234 rida
--Millised veerud on olemas? Tabeli on 12 rida id, sale id, invoice id, sale date, customer id, product id,
--quantity, unit price,  total price, channel, store location ja payment method.
--Mis oli üllatav? Üllatav on viga kogus ühes tabelis, miinusega hinnad, kliendi andmed puudulikud jne.
--Mis on puudu? Palju andmeid

--===========================================================================
--LISAÜLESANNE
--Leian unikaalsed müügitabelid
SELECT DISTINCT channel
FROM sales;

-- Vastus : online ja pood

--===========================================================================
--Tehingute arv iga kauplse kohta
SELECT store_location, COUNT(*) AS tehingud
FROM sales
GROUP BY store_location
ORDER BY tehingud DESC;

--Vastus  :  4 poe asukohta (1 neist tundmatu)
--Asukoht : tehingud
--Tallinn : 5704
--NULL    : 5204
--Tartu   : 2708
--Pärnu   : 1618

--===========================================================================
--Leian tehingud, kus summa on üle 100 € ja kauplus Tallinnas
SELECT * 
FROM sales
WHERE total_price > 100 AND store_location ='Tallinn'
ORDER BY total_price DESC;

--Vastus : 4555 vastet tuleb
