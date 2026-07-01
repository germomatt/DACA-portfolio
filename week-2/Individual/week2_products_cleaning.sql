--===============================================================================================
--==================================================== LISATÖÖ 
--ALAÜLESANDE KAART C :
--Tiimi liige - GERMO MATT
--WEEK 2 ROLL Tooteandmete puhastaja (Product Data Cleaner)

--ÜLESANNE	Leia duplikaadid, NULL väärtused ja ebajärjekindlused products tabelis. 
--Loo test koopia ja dokumenteeri probleemid.
--Puhastamisraport (duplikaadid leitud, NULL-id leitud, formaadivead, soovitused) + SQL skript

CREATE TABLE products_test AS SELECT * FROM products;
SELECT COUNT(*) AS ridade_arv FROM products_test;

--Tulemus 362 rida

--==================================================== 
--Leian korduvaid tootenimesid
SELECT product_name, COUNT(*) AS koopiate_arv
FROM products_test
GROUP BY product_name
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--Tulemus 12 duplikaatset tootenime

--==================================================== 
--Leian NULL väärtused
SELECT
    COUNT(*) FILTER (WHERE product_name IS NULL OR product_name = '') AS null_nimi,
    COUNT(*) FILTER (WHERE category IS NULL OR category = '') AS null_kategooria,
    COUNT(*) FILTER (WHERE retail_price IS NULL) AS null_jaehind,
    COUNT(*) FILTER (WHERE cost_price IS NULL) AS null_omahind
FROM products_test;

--TULEMUS 0 kõigis

--==================================================== 
--Leian ebaloogilisi hindasid

-- Kas on negatiivseid hindu?
SELECT COUNT(*) AS negatiivne_hind
FROM products_test
WHERE retail_price < 0;
-- Kas on äärmuslikke hindu (> 1000€)?
SELECT product_name, retail_price
FROM products_test
WHERE retail_price > 1000
ORDER BY retail_price DESC;

--Tulemus 0 negatiivset hinda ja 0 äärmuslikku hinda

--==================================================== 
--Kategooriate järjekindlus

SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category
ORDER BY category;

--Tulemus 5 ernevat kategooriat tuleb
--aksessuaarid 67
--jalanõusid 73
--laste riided 70
--meeste riided 82
--naiste riided 70

SELECT category, COUNT(*)
FROM products_test
GROUP BY category;
 
--==================================================== 
--Viin läbi puhastamise

-- Ühtlusta kategooriate nimed
UPDATE products_test
SET category = INITCAP(TRIM(category))
WHERE category != INITCAP(TRIM(category));
-- Kontrolli tulemust
SELECT category, COUNT(*) AS arv
FROM products_test
GROUP BY category ORDER BY category; 

--==================================================== 
--kategooriate standardiseerimine
UPDATE products_test
SET category = CASE
    WHEN LOWER(TRIM(category)) IN ('shoes', 'jalanõud', 'footwear') THEN 'Shoes'
    WHEN LOWER(TRIM(category)) IN ('shirts', 'särgid', 'tops') THEN 'Shirts'
    WHEN LOWER(TRIM(category)) IN ('pants', 'püksid', 'trousers') THEN 'Pants'
    ELSE INITCAP(TRIM(category))
END;

-- Leian tooted, mille omahind on suurem või võrdne jaehinnaga (müük kahjumiga)
SELECT 
    product_name, 
    cost_price, 
    retail_price
FROM products_test
WHERE cost_price >= retail_price;

--Tulemus 10 vastet

-- Leian tooted, mille nimel või kategoorial on tühikud alguses või lõpus
SELECT 
    product_name, 
    category
FROM products_test
WHERE product_name LIKE ' %' 
   OR product_name LIKE '% '
   OR category LIKE ' %' 
   OR category LIKE '% ';

   --Tulemus - vasted puuduvad

-- Leian korduvad toote ID-d (tulemus peaks olema ideaalis 0)
SELECT 
    product_id, 
    COUNT(*) AS id_koopiate_arv
FROM products_test
GROUP BY product_id
HAVING COUNT(*) > 1;

--tulemus 0

-- Leian tooted, kus toote ID puudub täielikult
SELECT COUNT(*) AS puuduv_id
FROM products_test
WHERE product_id IS NULL;

--Tulemus puudub