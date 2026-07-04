--===============================================================================================
--====================================================
--ALAÜLESANDE KAART B: Kliendid ilma ostudeta (LEFT JOIN + NULL)
--Tiimi liige - GERMO MATT
--WEEK 2 ROLL Kadunud klientide tuvastamine

--ÜLESANNE LEFT JOIN: millised kliendid pole kunagi midagi ostnud? Koosta Anna jaoks "kadunud klientide" nimekiri koos soovitustega.

--Leiame kõigepealt kliendid, kellel pole ühtegi ostu:
--LEFT JOIN: kõik kliendid, ka need kellel pole oste    
SELECT        c.first_name,        c.last_name,        c.email,        c.city,        c.registration_date,        s.sale_id    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL;    -- Kui sale_id on NULL, siis klient pole kunagi ostnud!   599 vastet

--===========================================================================================================================
--Leian mitu "kadunud" klienti on:
SELECT COUNT(*) AS kadunud_kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL;    `
--Tulemus - nagu eelmine loend juba tuvastan, siis neid on 599 tk

--===========================================================================================================================
--Analüüsime kadunud kliente linnade kaupa
SELECT        c.city,        COUNT(*) AS kadunud_kliente    
FROM customers c    LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL    
GROUP BY c.city    
ORDER BY kadunud_kliente DESC;   

     --TULEMUS 
--LINN      --ARV
--Tallinn     231
--Tartu       138
--Pärnu       70
--Narva       32
--Valga       25
--Kuressaare  18
--Viljandi    18
--Haapsalu    17
--Rakvere     17
--Võru        15
--Jõhvi       12
--Paide       11

--===========================================================================================================================
--Uurin registreerimise kuupäeva: Millal kadunud kliendid registreerusid?    
SELECT        c.first_name || ' ' || c.last_name AS klient,        c.registration_date,        c.city,        c.loyalty_tier    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
WHERE s.sale_id IS NULL    
ORDER BY c.registration_date DESC;

--Läbivalt kogu perioodi jooksul päringus 599 vastet detailselt välja toodud - screenshot tehtud

--===========================================================================================================================
--Võrdle kadunud vs aktiivsete klientide arvu:
SELECT        CASE            
WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            
ELSE 'Aktiivne (on ostnud)'        
END AS staatus,        COUNT(DISTINCT c.customer_id) AS kliente    
FROM customers c    
LEFT JOIN sales s ON c.customer_id = s.customer_id    
GROUP BY        CASE            WHEN s.sale_id IS NULL THEN 'Kadunud (pole ostnud)'            ELSE 'Aktiivne (on ostnud)'        
END; 

--Tulemus
--Aktiivseid kliente on 2551
--Kadunud kliente on 599

--lisaanalüüs: grupeerin kadunud kliendid registreerimiskuu kaupa ja otsi mustreid:
SELECT       DATE_TRUNC('month', c.registration_date) AS registreerimis_kuu,       COUNT(*) AS kadunud_kliente   
FROM customers c   
LEFT JOIN sales s ON c.customer_id = s.customer_id   
WHERE s.sale_id IS NULL   
GROUP BY DATE_TRUNC('month', c.registration_date)   
ORDER BY registreerimis_kuu;


--===========================================================================================================================
--===================================== KADUNUD KLIENTIDE RAPORT ============================================================

-- TULEMUSED:
-- Meie kliendibaasi analüüs näitab, et 599 registreerunud klienti pole seni sooritanud 
-- veel ühtegi ostu. Need passiivsed kasutajad on registreerunud läbivalt kogu vaadeldava 
-- perioodi jooksul, mis viitab püsivale vajadusele tõhustada uute klientide esmast ostule suunamist. 
-- Geograafiliselt on probleem kõige kriitilisem Tallinnas (231 klienti) ja Tartus (138 klienti), 
-- kus asub enam kui pool kõigist kadunud klientidest.


-- SOOVITUS TAGASIVÕITMISEKS: 
-- Nende konverteerimiseks ostjateks soovitan käivitada sihitud e-maili kampaania (keskendudes 
-- eelkõige Tallinna ja Tartu regioonile), pakkudes neile spetsiaalset piiratud kehtivusajaga 
-- tervitus- või esmaostusoodustust.
--===========================================================================================================================

-- KOKKUVÕTE: REGISTREERUMISMUSTRID JA ÄRILISED JÄRELDUSED (URBANSTYLE)
--=================================================================================================
--LISAANALÜÜS
-- 1. TUVASTATUD MUSTRID ANDMETES:
-- Aastatel 2020–2023 oli uute "kadunud" klientide arv madal ja stabiilne. 
-- Novembrist 2024 kuni veebruarini 2025 toimus aga plahvatuslik kasv, 
-- 2024 NOV - 2025 VEEBR tuues nelja kuuga sisse ligi 200 klienti, kes pole teinud ühtegi ostu.

-- 2. ÄRILISED JÄRELDUSED (TURUNDUSKAMPAANIAD):
-- Talvine hüpe viitab agressiivsetele pühadekampaaniatele, mis ahvatlesid 
-- lehele "kampaaniaturiste" (nt tasuta hüvede ja looside abil), mitte reaalsete 
-- ostusoovidega kliente. Ettevõtte klientide hankimine (Lead Gen) on edukas, 
-- kuid müügilehter pärast registreerumist (konversioon esmaostuks) on ebaefektiivne
