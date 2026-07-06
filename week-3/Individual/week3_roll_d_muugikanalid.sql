--===============================================================================================
--============================================================================================
--========================================================================================
--ALAÜLESANDE KAART D: Müügikanalid - (INNER JOIN + mitme tabeli JOIN)
--Tiimi liige - GERMO MATT
--WEEK 2 LISAROLL

--Uurin müügikanaleid `sales` tabelis:
-- Vaatan, millised müügikanalid on olemas    
SELECT DISTINCT channel 
FROM sales 
ORDER BY channel;    
--Tulemus - Eksisteerib hetkel ainult 2 kanalit - online ja pood

--========================================================================================
--Kanalite põhiülevaade: Vaatan milline kanal toob enim müüke?    
SELECT        s.channel AS müügikanal,        
COUNT(DISTINCT s.customer_id) AS kliente,        
COUNT(s.sale_id) AS oste,        
SUM(s.total_price) AS kogumüük    
FROM sales s    
GROUP BY s.channel    
ORDER BY kogumüük DESC; 

--Tulemus Müügikanal  kliente // oste  //  kogumüük
--          pood      2278    // 6656  //  1 902 430
--        online      1706    // 3462  //  1 006 747

--========================================================================================
-- Ühendan `sales` ja `customers` — klientide profiil kanali kaupa: 
-- Millistest linnadest kliendid milliseid kanaleid kasutavad?    
SELECT        s.channel AS müügikanal,        c.city AS linn,        
COUNT(DISTINCT c.customer_id) AS kliente,        
SUM(s.total_price) AS kogumüük    
FROM sales s    
INNER JOIN customers c ON s.customer_id = c.customer_id    
GROUP BY s.channel, c.city    
ORDER BY müügikanal, kogumüük DESC;  

--Tulemus 24 rida TOP1 online Tallinn 667 klienti müük 335 719
| müügikanal | linn       | kliente | kogumüük  |
| ---------- | ---------- | ------- | --------- |
| online     | Tallinn    | 667     | 335719.11 |
| online     | Tartu      | 345     | 179175.44 |
| online     | Pärnu      | 188     | 135423.94 |
| online     | Narva      | 94      | 42551.86  |
| online     | Viljandi   | 67      | 41489.32  |
| online     | Rakvere    | 55      | 30783.20  |
| online     | Haapsalu   | 58      | 29901.08  |
| online     | Jõhvi      | 56      | 28637.57  |
| online     | Kuressaare | 52      | 25462.83  |
| online     | Valga      | 44      | 23796.96  |
| online     | Võru       | 48      | 20942.35  |
| online     | Paide      | 32      | 14856.47  |
| pood       | Tallinn    | 910     | 670533.77 |
| pood       | Tartu      | 461     | 344111.20 |
| pood       | Pärnu      | 258     | 238581.92 |
| pood       | Narva      | 121     | 79674.28  |
| pood       | Rakvere    | 78      | 62595.83  |
| pood       | Viljandi   | 81      | 60825.62  |
| pood       | Kuressaare | 71      | 51046.78  |
| pood       | Jõhvi      | 62      | 48963.58  |
| pood       | Haapsalu   | 66      | 43591.75  |
| pood       | Võru       | 57      | 40040.72  |
| pood       | Paide      | 50      | 38292.40  |
| pood       | Valga      | 63      | 35733.80  |


--========================================================================================
--Ühendan 3 tabelit: `sales` + `customers` + `products`: 3 tabeli JOIN: millised tooted müüvad millises kanalis?    
SELECT        s.channel AS müügikanal,        p.category AS tootekategooria,        
COUNT(DISTINCT c.customer_id) AS kliente,        
COUNT(s.sale_id) AS oste,        
SUM(s.total_price) AS kogumüük,        
ROUND(AVG(s.total_price), 2) AS keskmine_ost    
FROM sales s    
INNER JOIN customers c ON s.customer_id = c.customer_id    
INNER JOIN products p ON s.product_id = p.product_id    
GROUP BY s.channel, p.category    
ORDER BY müügikanal, kogumüük DESC;   

--Tulemus - 10 rida
| müügikanal | tootekategooria | kliente | oste | kogumüük  | keskmine_ost |
| ---------- | --------------- | ------- | ---- | --------- | ------------ |
| online     | jalanõusid      | 524     | 632  | 248820.61 | 393.70       |
| online     | meeste_riided   | 548     | 686  | 233375.66 | 340.20       |
| online     | naiste_riided   | 534     | 647  | 215503.09 | 333.08       |
| online     | aksessuaarid    | 445     | 536  | 116710.11 | 217.74       |
| online     | laste_riided    | 506     | 627  | 94330.66  | 150.45       |
| pood       | meeste_riided   | 996     | 1362 | 447173.58 | 328.32       |
| pood       | jalanõusid      | 872     | 1184 | 440060.24 | 371.67       |
| pood       | naiste_riided   | 892     | 1193 | 408066.19 | 342.05       |
| pood       | aksessuaarid    | 801     | 1073 | 238250.10 | 222.04       |
| pood       | laste_riided    | 883     | 1190 | 180441.54 | 151.63       |

--========================================================================================
--Leian kõige efektiivsem kanal (müük per klient):
SELECT        s.channel AS müügikanal,        
COUNT(DISTINCT s.customer_id) AS kliente,        
SUM(s.total_price) AS kogumüük,        
ROUND(SUM(s.total_price) / COUNT(DISTINCT s.customer_id), 2) AS müük_per_klient    
FROM sales s    
GROUP BY s.channel    
ORDER BY müük_per_klient DESC;

--Tulemus  müügikanal // kliente // kogumüük  // müük per klient
--         pood       // 2278    // 1 902 430 // 835.13
--         online     // 1706    // 1 006 747 // 590.12

--========================================================================================
--Lisan kaupluste võrdlus: leia iga kaupluse müügikanalite jaotus:
SELECT       s.store_location AS kauplus,       s.channel AS müügikanal,       
COUNT(s.sale_id) AS oste,       
SUM(s.total_price) AS kogumüük,       
ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS keskmine_ost   
FROM sales s   
GROUP BY s.store_location, s.channel   
ORDER BY kauplus, kogumüük DESC;

--                          TULEMUS 
-- kauplus // müügikanal // oste // kogumüük  // kesmine ost
-- Pärnu   // pood       // 1058 //   288 744 // 272.91
-- Tallinn // pood       // 3801 // 1 092 083 // 287.31
-- Tartu   // pood       // 1797 //   521 603 // 290.26
-- NULL    // online     // 3462 // 1 006 747 // 290.80