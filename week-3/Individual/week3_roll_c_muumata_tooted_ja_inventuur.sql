--===============================================================================================
--============================================================================================
--========================================================================================
--ALAÜLESANDE KAART C: Tooted + Inventuur
--Tiimi liige - GERMO MATT
--WEEK 2 LISAROLL

--Leiame tooted, mis pole kunagi müüdud:
--LEFT JOIN: kõik tooted, ka need mis pole müüdud    
SELECT        p.product_name,        p.category,        p.subcategory,        p.retail_price,        s.sale_id    
FROM products p    
LEFT JOIN sales s ON p.product_id = s.product_id    
WHERE s.sale_id IS NULL;    -- Kui sale_id on NULL, siis toodet pole kunagi müüdud!  

--Tulemus - 12 vastet
--========================================================================================
--Loendame lihtsalt kokku

SELECT COUNT(*) AS müümata_tooteid    
FROM products p    
LEFT JOIN sales s ON p.product_id = s.product_id    
WHERE s.sale_id IS NULL; 

--Tulemus sama 12

--========================================================================================
--Leia enim müüdud tooted:
SELECT        p.product_name,        p.category,        p.subcategory,        
COUNT(s.sale_id) AS müüdud_kordi,        SUM(s.total_price) AS kogumüük    
FROM products p    
INNER JOIN sales s ON p.product_id = s.product_id    
GROUP BY p.product_id, p.product_name, p.category, p.subcategory    
ORDER BY kogumüük DESC    
LIMIT 10;  

--TUlemus
| product_name                               | category      | subcategory | müüdud_kordi | kogumüük |
| ------------------------------------------ | ------------- | ----------- | ------------ | -------- |
| Õhuline sünteetiline sporditossud          | jalanõusid    | tossud      | 35           | 27347.04 |
| Trendikas goretex oxfordid                 | jalanõusid    | kingad      | 32           | 23376.15 |
| Praktiline viskoosne jakk                  | naiste_riided | jakid       | 35           | 22188.80 |
| Praktiline džersii seelik                  | naiste_riided | seelikud    | 37           | 22039.98 |
| Boheemlaslik puuvillane tuulejope          | naiste_riided | jakid       | 30           | 21309.96 |
| Õhuline sünteetiline kõrge kontsaga kingad | jalanõusid    | kontsad     | 38           | 21295.56 |
| Praktiline kangast kõrge kontsaga kingad   | jalanõusid    | kontsad     | 37           | 21118.68 |
| Luksuslik villane pahkluu saapad           | jalanõusid    | botased     | 28           | 19704.87 |
| Praktiline merino villane parka            | meeste_riided | jakid       | 30           | 19620.45 |
| Õhuline linane jakk                        | naiste_riided | jakid       | 41           | 19393.29 |


--========================================================================================
--Analüüsi kategooriate kaupa:
SELECT        p.category,        
COUNT(DISTINCT p.product_id) AS tooteid,        
COUNT(s.sale_id) AS müüke,        
SUM(s.total_price) AS kogumüük    
FROM products p    
LEFT JOIN sales s ON p.product_id = s.product_id    
GROUP BY p.category    
ORDER BY kogumüük DESC; 

--Tulemused
| category      | tooteid | müüke | kogumüük  |
| ------------- | ------- | ----- | --------- |
| jalanõusid    | 73      | 2031  | 774034.75 |
| meeste_riided | 82      | 2266  | 749798.72 |
| naiste_riided | 70      | 2022  | 686464.24 |
| aksessuaarid  | 67      | 1772  | 393035.82 |
| laste_riided  | 70      | 2027  | 305844.45 |


--========================================================================================
--Ühenda inventuuriga — millised tooted on laos?
SELECT        p.product_name,        p.category,        i.location,        i.quantity_available,        i.reorder_point,        
CASE            WHEN i.quantity_available <= i.reorder_point THEN 'TELLI JUURDE'            ELSE 'OK'        END AS staatus    
FROM products p    
LEFT JOIN inventory i ON p.product_id = i.product_id    
ORDER BY i.quantity_available ASC;   

--Tulemus 1412 rida tooteid - täpne list screenhotis