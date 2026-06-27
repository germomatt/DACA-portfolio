--===========================================================================
--===========================================================================

--ÜLESANNE B - Kliendiandmed
--Uurime klientide kogu arvu
SELECT COUNT(*) AS klientide_arv
FROM customers;
-- Vastus 3150 klienti

--===========================================================================
--Millised andmed on veergudes?
SELECT *
FROM customers
LIMIT 10;
--Vastus customer_id,first_name, last_name, email, phone, city, registration_date, loyalty_tier, birth_year

--===========================================================================
--Millistest linnadest kliendid tulevad ?
SELECT DISTINCT city
FROM customers;
Vastus - 54 vastet kuid linnad on dubleeritud Kord suure algus tähega, kord väikese, kord terve linn trükitähtedega, kord tühik ees jne jne

--===========================================================================
--Otsin Tallinna kliendid, sorteerin nime järgi
SELECT *
FROM customers
WHERE city='Tallinn'
ORDER BY last_name ASC
LIMIT 15;

Vastus - vastest tehtud screenshot

--===========================================================================
--Millal esimesed ja viimased kliendid registeerusid ?
SELECT MIN(registration_date) AS vanim, MAX(registration_date) AS Uusim
FROM customers;
-- Vastus VANIM - 2020-01-02 ja UUSIM 2025-02-27

--===========================================================================
--Mitu klienti, kus on eesnimi puudu?
SELECT COUNT(*) - COUNT(first_name) AS Puuduvad_eesnimed
FROM customers;
--Vastus on 0

--===========================================================================
--Mitu klienti, kus e-mail on puudu ?
SELECT COUNT(*) - COUNT(email) AS Puuduvad_emailid
FROM customers;
--Vastus on 380 

--Mitu klienti on ? Millised linnad? Mis oli üllatav ? Puuduvad andmed?
--===========================================================================
--===========================================================================
--=======================KOKKUVÕTE===========================================

--Andmebaasis on 3150 klienti
--Kokku oli linnades 53 erinevat vastet, kuid enamus linnu oli üht või teistviisi välja kirjutatud 5-6 erineval kujul
--Üllatav minu jaoks oligi, et puuduvates andmetes oli 380 emaili puudu, mis tundub tavapärane info minu jaoks kliendi 
--andmebaasides, kui ei usu et nimel kõigil olemas oli, seda tahaks edasi uurida ning samuti tuleb leida linnade valikul 
--ainult sellisel viisid, et võtad dubleeritud linnad välja ja liidad ühte.
