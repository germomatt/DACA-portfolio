--===============================================================================================
--====================================================
--ALAÜLESANDE KAART A: Müügiandmete Puhastamine
--Tiimi liige - GERMO MATT
--WEEK 2 ROLL Müügiandmete puhastaja (Sales Data Cleaner)


--ÜLESANNE Leia duplikaadid, NULL väärtused ja vigased kuupäevad sales tabelis. 
--Loo test koopia, puhasta ja dokumenteeri kõik muudatused.
--Puhastamisraport (duplikaadid leitud, NULL-id leitud, formaadivead, soovitused) + SQL skript

CREATE TABLE sales_test AS SELECT * FROM sales;
-- Taga unikaalne rea-tunnus dedup'i jaoks (lisab `id` AINULT siis, kui see puudub).
-- NB: `CREATE TABLE ... AS SELECT` ei pärandata alati `id`-d — see rida teeb Sammu 3 töökindlaks.
ALTER TABLE sales_test ADD COLUMN IF NOT EXISTS id SERIAL;
-- Kontrolli ridade arvu
SELECT COUNT(*) AS ridade_arv FROM sales_test;

--Tulemus on 15234 rida

--====================================================
--Leian duplikaadid - Millised arved korduvad 
SELECT invoice_id, COUNT(*) AS koopiate_arv
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1
ORDER BY koopiate_arv DESC;

--Tulemus on 4013 duplikaatset rida

--====================================================
--Leian duplikaat ridade arvu
SELECT COUNT(*) AS duplikaat_read
FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);

--Tulemus on 5116 rida on duplikaadid

--====================================================
--Leian NULL väärtused
SELECT
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS null_customer_id,
    COUNT(*) FILTER (WHERE sale_date IS NULL) AS null_sale_date,
    COUNT(*) FILTER (WHERE total_price IS NULL) AS null_total_price
FROM sales_test;

--Tulemus : 1487 NULL customer_id
--Tulemus : 0 NULL sale_date
--Tulemus : 0 NULL total_price

--====================================================
--Kontrollin kuupäevade formaati
SELECT COUNT(*) AS tuleviku_kuupaevad
FROM sales_test
WHERE sale_date > CURRENT_DATE;

--Tulemus 0 tuleviku kuupäeva

--===============================================================================================
-- Samm 6. Koosta puhastamisraport:
--
-- | Kategooria         | Leitud probleeme | Kirjeldus                                           |
-- |--------------------|------------------|-----------------------------------------------------|
-- | Duplikaadid        | 4013             | Korduvad invoice_id väärtused (duplikaattellimused) |
-- | NULL customer_id   | 1487             | Puuduv kliendi viide                                |
-- | NULL sale_date     | 0                | Puuduv kuupäev                                      |
-- | NULL total_price   | 0                | Puuduv summa                                        |
-- | Tuleviku kuupäevad | 0                | Kuupäev > tänane                                    |
-- |--------------------|------------------|-----------------------------------------------------|
-- | KOKKU probleeme    | 5500             |                                                     |
--
--
-- Lisa soovitus: mida peaks Toomas esimesena parandama?
-- Toomas peaks esimesena parandama DUPLIKAADID (4013 probleemi).
-- 
-- Põhjendus: 
-- 1. Duplikaadid moonutavad ettevõtte kõige olulisemat näitajat – käivet. 4013 topeltarvet 
--    tähendab, et finantsraportid näitavad ebarealistlikult suurt tulu.
-- 2. Töömahu vähenemine: Suur tõenäosus on, et osa neist 1487-st puuduvast kliendiviitest 
--    (NULL customer_id) asuvad just nendes samades duplikaat-ridades. Kui Toomas eemaldab 
--    esmalt topeltrread, võib "NULL customer_id" probleemide arv automaatselt kahaneda, 
--    säästes aega ja vaeva.
-- Pärast duplikaatide eemaldamist tuleb kohe lahendada allesjäänud NULL customer_id read, 
-- et taastada andmebaasi seoste terviklikkus.

--VIHJE
SELECT COUNT(*) FROM sales_test
WHERE invoice_id IS NULL;

--Kas see päring leiab kõik duplikaadid?
--AI vastused : Lühike vastus: Ei.
--Põhjendus: Päring WHERE veeru_nimi IS NULL otsib ainult tühje ehk puuduvaid väärtusi. D
--Duplikaat tähendab aga seda, et mingi väärtus (näiteks arve number ehk invoice_id) 
--eksisteerib tabelis mitu korda. Need on kaks täiesti erinevat andmekvaliteedi probleemi.

--Kas on parem viis?
--Lühike vastus: Jah.
--Duplikaatide leidmiseks SQL-is kasutatakse grupeerimist (GROUP BY) ja tingimust, mis otsib 
--kirjeid, mida esineb rohkem kui üks kord (HAVING COUNT(*) > 1).

--====duplikaatide koguarvu leidmine===--
SELECT 
  COUNT(*) - COUNT(DISTINCT invoice_id) AS duplikaatide_arv
FROM sales_test;

--====konkreetsete korduvate arvete nimekiri===--
SELECT 
  invoice_id, 
  COUNT(*) AS esinemiste_arv
FROM sales_test
GROUP BY invoice_id
HAVING COUNT(*) > 1;

--===============================================================================================
--EDASIJÕUDNUTE TASE (30%) — Vabatahtlik:


-- Kustuta duplikaadid (jäta alles ainult esimene rida iga invoice_id kohta)
DELETE FROM sales_test
WHERE id NOT IN (
    SELECT MIN(id)
    FROM sales_test
    GROUP BY invoice_id
);
-- Kontroll: ridade arv peaks nüüd olema unikaalsete invoice_id arv (~10 118) // KONTROLL KLAPIB
SELECT COUNT(*) AS parast FROM sales_test;
-- Dokumenteeri NULL customer_id (need on külalisostud — kehtiv äriloogika!)
-- NB: NULL tähendab siin "tundmatu klient / külalisost", MITTE andmeviga.
-- Vaata, kui palju neid on:                                                  //KÜLALISOSTE ON 988
SELECT COUNT(*) AS külalisostud FROM sales_test WHERE customer_id IS NULL;
-- Analüüsis kasuta COALESCE, et anda neile ajutine silt:
-- SELECT COALESCE(customer_id, -1) AS customer_id_puhas FROM sales_test;
-- Paranda tuleviku kuupäevad
UPDATE sales_test
SET sale_date = CURRENT_DATE
WHERE sale_date > CURRENT_DATE;
-- Kontrolli tulemust
SELECT COUNT(*) AS ridu_parast FROM sales_test;                             //--ridu pärast on 10118