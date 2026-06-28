SELECT 1;

--===========================================================================
--===========================================================================

--ISESEISEV TÖÖ
SELECT sale_id,
COUNT(*) AS koopiate_arv
FROM sales
GROUP BY sale_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--==================================
--igale järjekorra number
SELECT sale_id, customer_id,total_price,sale_date,
ROW_NUMBER () OVER (PARTITION BY sale_id ORDER BY sale_date) AS rn
FROM sales;

--==================================
--1A shu duplikaatite leidmine
SELECT sale_id, COUNT(*) AS koopiate_arv
FROM sales
GROUP BY sale_id
HAVING COUNT (*) > 1
ORDER BY koopiate_arv desc
LIMIT 10;

--==================================
-- Duplikaatide mõju müüginumbritele
SELECT
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate,
    SUM(total_price) AS summa_duplikaatidega,
    (SELECT SUM(total_price) FROM (
        SELECT DISTINCT ON (sale_id) total_price
        FROM sales
        ORDER BY sale_id, sale_date
    ) unikaalsed) AS summa_ilma_duplikaatideta
FROM sales;

--summa duplikaatideg 4374231.27 ja summa ilma 2896951.38

--==================================
-- duplikaat emailid
SELECT * FROM (
    SELECT
        customer_id,
        first_name,
        last_name,
        email,
        ROW_NUMBER() OVER (PARTITION BY email ORDER BY customer_id) AS rn
    FROM customers
    WHERE email IS NOT NULL
) numbered
WHERE rn > 1
ORDER BY email;

--==================================
-- Leia kliendid, kellel ON e-mail olemas
SELECT customer_id, first_name, email
FROM customers
WHERE email IS NOT NULL;
--vastus 2770

-- Leia tellimused, kus klient on teadmata
SELECT sale_id, customer_id, total_price
FROM sales
WHERE customer_id IS NULL;
--vastus 1487

-- Asenda puuduv kliendi nimi vaikeväärtusega
SELECT
    customer_id,
    COALESCE(first_name, 'Tundmatu') AS eesnimi,
    COALESCE(email, 'puudub@urbanstyle.ee') AS email
FROM customers;

-- Mitu asendusväärtust (valib esimese mitte-NULL väärtuse)
SELECT COALESCE(NULL, NULL, 'Kolmas valik');
-- Tulemus: 'Kolmas valik'

-- NULLIF(a, b): kui a = b, tagastab NULL; muidu tagastab a
SELECT NULLIF(100, 100);  -- Tulemus: NULL
SELECT NULLIF(100, 200);  -- Tulemus: 100

-- Muuda 0-hinnaga tooted NULL-iks (hind pole tegelikult 0, vaid puudub)
SELECT
    product_id,
    product_name,
    NULLIF(retail_price, 0) AS puhas_hind
FROM products;

SELECT 100 + NULL;     -- Tulemus: NULL
SELECT NULL * 5;       -- Tulemus: NULL
SELECT SUM(total_price) FROM sales;  -- SUM ignoreerib NULL-e!

--==================================
-- NULL-ide ülevaade customers tabelis
SELECT
    COUNT(*) AS kliente_kokku,
    COUNT(first_name) AS eesnimi_olemas,
    COUNT(*) - COUNT(first_name) AS eesnimi_puudub,
    COUNT(email) AS email_olemas,
    COUNT(*) - COUNT(email) AS email_puudub,
    COUNT(phone) AS telefon_olemas,
    COUNT(*) - COUNT(phone) AS telefon_puudub
FROM customers;

--vastused kliente kokku 3150, eesnimi puudub 0 kliendil
--email on olemas 2770 kliendil ja 380 puudub

-- Kliendid, kellel puudub nimi VÕI e-mail
SELECT customer_id, first_name, last_name, email, city
FROM customers
WHERE first_name IS NULL
  OR last_name IS NULL
  OR email IS NULL
ORDER BY customer_id
LIMIT 15;

--Vastus puudulike andmega kliendid ei ole samast linnast - seega siit mingit järeldust teha ei saa veel

--==================================
-- COALESCE puuduvatele andmetele
SELECT
    customer_id,
    COALESCE(first_name, 'Tundmatu') AS eesnimi,
    COALESCE(last_name, '') AS perenimi,
    COALESCE(email, 'puudub') AS email,
    COALESCE(phone, 'puudub') AS telefon,
    city
FROM customers
WHERE first_name IS NULL
  OR last_name IS NULL
  OR email IS NULL
  OR phone IS NULL
ORDER BY customer_id;
-- 380 väärtust muutub
--COALESCE asendab NULL väärtused loetava tekstiga — päringu TULEMUS on puhtam
--Algandmed tabelis EI MUUTU — COALESCE muudab ainult väljundit
--WHERE filtreerib ainult need kliendid, kellel on vähemalt üks puuduv väli

-- Võrdlus: SUM kõigist vs SUM mitte-NULL väärtustest
SELECT
    COUNT(*) AS ridu,
    COUNT(total_price) AS summa_olemas,
    COUNT(*) - COUNT(total_price) AS summa_puudub,
    SUM(total_price) AS kogusumma,
    AVG(total_price) AS keskmine
FROM sales;

--==================================
--==================================
-- Andmeformaadid ja tüübikonversioonid

-- CAST süntaks (standardne SQL)
SELECT CAST('125.50' AS NUMERIC);  -- Tekst -> number
SELECT CAST('2024-01-15' AS DATE); -- Tekst -> kuupäev
-- :: süntaks (PostgreSQL-i kiirviis)
SELECT '125.50'::NUMERIC;          -- Sama tulemus
SELECT '2024-01-15'::DATE;        -- Sama tulemus
Kui formaat ei sobi, annab CAST veateate:
SELECT CAST('pole number' AS NUMERIC);  -- VIGA!

-- Kuupäev erinevates formaatides
SELECT
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_formaat,
    TO_CHAR(sale_date, 'YYYY-MM-DD') AS iso_formaat,
    TO_CHAR(sale_date, 'DD. Month YYYY') AS pikk_formaat
FROM sales
LIMIT 5;

-- Tekst -> kuupäev (pead ütlema, millises formaadis tekst on)
SELECT TO_DATE('15/03/2024', 'DD/MM/YYYY');  -- Tulemus: 2024-03-15
SELECT TO_DATE('2024-01-15', 'YYYY-MM-DD');  -- Tulemus: 2024-01-15
Samm 4: Tekstifunktsioonid — TRIM(), UPPER(), LOWER()
TRIM() eemaldab tühikud teksti algusest ja lõpust:
SELECT TRIM('  Tallinn  ');  -- Tulemus: 'Tallinn'
SELECT TRIM('  ');           -- Tulemus: '' (tühi string)
UPPER() ja LOWER() muudavad teksti suur- või väiketähtedeks:
SELECT UPPER('tallinn');   -- Tulemus: 'TALLINN'
SELECT LOWER('TALLINN');   -- Tulemus: 'tallinn'


-- Leia kõik unikaalsed linnade kirjaviisid
SELECT DISTINCT city
FROM customers
ORDER BY city;
-- Ühtlusta: eemalda tühikud, muuda algustäht suureks
SELECT DISTINCT
    city AS originaal,
    TRIM(city) AS trimitud,
    UPPER(TRIM(city)) AS suurtahtedega,
    INITCAP(TRIM(city)) AS esitaht_suur
FROM customers
WHERE city IS NOT NULL
ORDER BY city;

--HARJUTUS 3A
-- Kuupäevade formateerimine UrbanStyle'i andmetes
SELECT
    sale_id,
    sale_date,
    TO_CHAR(sale_date, 'DD.MM.YYYY') AS eesti_kuupaev,
    TO_CHAR(sale_date, 'Day') AS nadalapäev,
    TO_CHAR(sale_date, 'YYYY-"Q"Q') AS kvartal,
    EXTRACT(DOW FROM sale_date) AS paev_nr
FROM sales
ORDER BY sale_date DESC
LIMIT 10;

--VASTUSED
--vaikimisi on kuupäevad salvestatud usa aja järgi
--viimane tellimus oli 26.06.2026
--viimane tellimus oli teises kvartalis Q2


-- Linnade ühtlustamise diagnostika
SELECT
    city AS originaal,
    TRIM(city) AS trimitud,
    INITCAP(TRIM(city)) AS puhastatud,
    COUNT(*) AS kliente
FROM customers
GROUP BY city
ORDER BY city;

--Kõige rohkem erineval viisil linnasid kirjutatud leidub 5

--============================================================
-- Linnade puhastatud statistika
SELECT
    INITCAP(TRIM(city)) AS puhas_linn,
    COUNT(*) AS kliente,
    COUNT(DISTINCT city) AS erinevaid_kirjaviise,
    STRING_AGG(DISTINCT city, ', ' ORDER BY city) AS algkirjaviisid
FROM customers
WHERE city IS NOT NULL
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente DESC;

--Kontrollin kas products tabelis on kõik hinnad õiges formaadis
SELECT
    product_id,
    product_name,
    retail_price,
    CASE
        WHEN retail_price IS NULL THEN 'NULL'
        WHEN retail_price = 0 THEN 'NULL (0 = puudub?)'
        WHEN retail_price < 0 THEN 'NEGATIIVNE!'
        ELSE 'OK'
    END AS hinna_staatus
FROM products
WHERE retail_price IS NULL OR retail_price <= 0
ORDER BY retail_price;

-- Duplikaatide ülevaade kõigis tabelites
SELECT 'sales' AS tabel,
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate
FROM sales
UNION ALL
SELECT 'customers',
    COUNT(*),
    COUNT(DISTINCT email),
    COUNT(*) - COUNT(DISTINCT email)
FROM customers
UNION ALL
SELECT 'products',
    COUNT(*),
    COUNT(DISTINCT product_id),
    COUNT(*) - COUNT(DISTINCT product_id)
FROM products;

--VASTUSED - sales tabelis on 5116 duplikaati
--customers tabelis on 510 duplikaati
--products tabelis on 0 duplikaati

SQL
-- NULL väärtuste raport peamistes veergudes
SELECT 'sales' AS tabel,
    COUNT(*) - COUNT(customer_id) AS null_kliendi_id,
    COUNT(*) - COUNT(total_price) AS null_hind,
    COUNT(*) - COUNT(sale_date) AS null_kuupaev
FROM sales
UNION ALL
SELECT 'customers',
    COUNT(*) - COUNT(customer_id), -- Või muu ID veerg
    COUNT(*) - COUNT(email),
    COUNT(*) - COUNT(phone)        -- Eeldades, et sul on telefoni veerg
FROM customers
UNION ALL
SELECT 'products',
    COUNT(*) - COUNT(product_id),
    COUNT(*) - COUNT(product_name),-- Eeldades, et tootel on nimi
    COUNT(*) - COUNT(cost_price)        -- Eeldades, et tootel on oma baashind
FROM products;

--VASTUSED
--sales tabelis on 1487 puuduvat väärtust
--customers tabelis on 380 puuduvat ja products pole

-- Päring 3: Linnade formaatide diagnostika ja puhastamine
-- Linnade puhastatud statistika
SELECT
    INITCAP(TRIM(city)) AS puhas_linn,
    COUNT(*) AS kliente,
    COUNT(DISTINCT city) AS erinevaid_kirjaviise,
    STRING_AGG(DISTINCT city, ', ' ORDER BY city) AS algkirjaviisid
FROM customers
WHERE city IS NOT NULL
GROUP BY INITCAP(TRIM(city))
ORDER BY kliente DESC;

--vastus kokku tuleb erinevaid 54 - unikaalseid on 12 enamusel on 5 erinevat viisi, 1 viisi pole kellegil

--TEADMISTE KONTROLL
--1. D - õige
--2. A - õige
--3. A - vale NULL on 0 rida mitte 50
--4. D - vale
--5. C - vale 
--6. D - õige
--7. C - õige
--8. A - õige
--9. B D -mõlemad õiged