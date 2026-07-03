-- =========================================================================
-- 🚀 ISESEISEV TÖÖ
-- =========================================================================
-- Projekt:    [SQL JOINs]
-- Autor:      [GERMO MATT]
-- Kuupäev:    03.07.2026
-- =========================================================================
-- Kustutan duplikaadid sales tabelist (sama loogika mis W2 sales_test peal)
DELETE FROM sales
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales
    GROUP BY sale_id
);

-- Parandan tuleviku kuupäevad
UPDATE sales
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;

-- Ühtlustan klientide linnanimed (muidu GROUP BY city näitab 50+ varianti 12 asemel)
UPDATE customers
SET city = INITCAP(TRIM(city))
WHERE city IS NOT NULL;

-- Kontrolli tulemusi
SELECT COUNT(*) AS sales_ridu FROM sales;           -- Tulemus: 10 118
SELECT COUNT(DISTINCT city) AS linnu FROM customers; -- Tulemus: 12

-- =========================================================================
-- INNER JOINiga ühendan kaks tabelit ja näitab ainult neid ridu kus veerg sobib mõlemas tabelis
Samm 2: INNER JOIN süntaks
INNER JOIN ühendab kaks tabelit ja näitab AINULT neid ridu, kus ühendav veerg (key) sobib mõlemas tabelis.
SELECT
    veerg1,
    veerg2
FROM tabel_a
INNER JOIN tabel_b ON tabel_a.ühine_veerg = tabel_b.ühine_veerg;

--UrbanStyle näide — kliendi nimi koos tema müükidega:
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 10;

-- ILMA aliaseta (pikk ja raskesti loetav):
SELECT customers.first_name, sales.total_price
FROM sales
INNER JOIN customers ON sales.customer_id = customers.customer_id;
-- ALIASEGA (lühike ja selge):
SELECT c.first_name, s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;

-- =========================================================================
--Harjutus 1A
-- INNER JOIN: kliendid koos nende müükidega
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.sale_date,
    s.total_price
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
ORDER BY s.total_price DESC
LIMIT 20;

--Tulemus kuvab 20 rida, 
--kus suurima tellimusega klient on Madis Valgast hinnaga 2170.40€
--TOP 20s kordub enim Tallinn 10 korda
--Eemaldan käsu LIMIT ning tulemus on 9130 rida

-- =========================================================================
--Harjutus 1B
SELECT
    p.product_name AS toode,
    p.category AS kategooria,
    s.quantity AS kogus,
    s.unit_price AS ühikuhind
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY s.quantity DESC
LIMIT 15;

-- =============================TULEMUSED=============================
--Tulemused Limit 15 korral tuleb 15 vastes kus kõiki tooteid on müüdud 5 korda
--Leian palju neid tooteid on "nö populaarsed"
SELECT 
    COUNT(*) AS "kogus_5_esinemiste_arv"
FROM sales s
INNER JOIN products p ON s.product_id = p.product_id
WHERE s.quantity = 5;
--Tulemused Kõige enim müüdud toodet 5 tükki korduva 339 toote korral
--Kalleim toode ja enim müüdu tootel puudub seos
--Antud vaatepidi järgi pole midagi võimalik järeldada
-- =============================TULEMUSED=============================

--Millised kliendid tellisid viimase kuu jooksul ?
SELECT DISTINCT 
    c.first_name AS klient, 
    c.registration_date AS tellimuse_kuupaev
FROM customers c
INNER JOIN sales s ON c.customer_id = s.customer_id
WHERE c.registration_date >= CURRENT_DATE - INTERVAL '100 month';

--mis read üldse olemas on (pealkirjad)
SELECT * FROM customers LIMIT 1;

--LEFT JOIN

--UrbanStyle näide — kõik kliendid, ka need kes pole ostnud:
SELECT
    c.first_name,
    c.last_name,
    c.city,
    s.sale_id,
    s.total_price
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
ORDER BY s.total_price DESC NULLS LAST;

-- Kliendid, kes pole KUNAGI ostnud
SELECT
    c.first_name,
    c.last_name,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL;
--Tulemus 599 rida

-- =========================================================================
--Harjutus 2A

-- Kadunud kliendid: LEFT JOIN + WHERE IS NULL
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS nimi,
    c.email,
    c.city,
    c.registration_date
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
ORDER BY c.registration_date DESC;

-- =============================TULEMUSED=============================
-- Leidsin 599 kadunud klienti
--Taaskord ei loetle käsitsi kokku
SELECT 
    c.city AS linn,
    COUNT(*) AS kadunud_klientide_arv
FROM customers c
LEFT JOIN sales s ON c.customer_id = s.customer_id
WHERE s.sale_id IS NULL
GROUP BY c.city
ORDER BY kadunud_klientide_arv DESC;
--Nagu arvata oli on vastus TALLINN ( 231 korda ), järgneb Tartu 133x, Pärnu 70 jne
--Kõige vanem kadunud registeerunud klient on 02.01.2020
-- =============================TULEMUSED=============================

-- Võrdluseks: INNER JOIN (ainult aktiivsed kliendid)
SELECT COUNT(DISTINCT c.customer_id) AS aktiivseid_kliente
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id;
-- Tulemus 2551 aktiivset klienti
-- 2551 + 599 teeb kokku 3150 klienti - klapib

-- =========================================================================
--Harjutus 2B - Otsime tooteid ilma müügita

SELECT
    p.product_name AS toode,
    p.category AS kategooria,
    p.retail_price AS hind
FROM products p
LEFT JOIN sales s ON p.product_id = s.product_id
WHERE s.sale_id IS NULL
ORDER BY p.category, p.retail_price DESC;

-- =============================TULEMUSED=============================
--Leidsin, et müümata tooteid on 12
--Enim müümata toote kategooria on aksessuaarid
--Stiilne puidust müts pole vist eriline müügihitt :D aga mõne toote puhul ei oska hinnangut anda nt kerge siidine nahkkinnas
-- =============================TULEMUSED=============================

--Kadunud klientide analüüs sai varasemalt juba tehtud plokis kus küsiti kõige enim kadunud klienti
--Selleks kasutasin COUNT valemit ja leidsin linnade kaupa vajaliku koguse.

-- =========================================================================
--Harjutus 3A - Ühendame 3 tabelit
-- 3 tabeli JOIN: kes ostis mida?
SELECT
    c.first_name || ' ' || c.last_name AS klient,
    c.city AS linn,
    s.sale_date AS müügi_kuupäev,
    p.product_name AS toode,
    p.category AS kategooria,
    s.quantity AS kogus,
    s.unit_price AS ühikuhind,
    s.total_price AS rea_summa
FROM sales s
INNER JOIN customers c ON s.customer_id = c.customer_id
INNER JOIN products p ON s.product_id = p.product_id
ORDER BY rea_summa DESC
LIMIT 20;

-- =============================TULEMUSED=============================
--Kõige suurema rea summaga toode on Õhuline sünteetiline sporditossud - klient on linnast Valga
--TOP20 tooted on enim kategoorias : jalanõusid
-- =============================TULEMUSED=============================
