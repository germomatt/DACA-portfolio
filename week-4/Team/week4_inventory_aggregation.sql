--===============================================================================================
--====================================================
--ALAÜLESANDE KAART C: Inventuuri statistika (Inventory Statistics)
--Tiimi liige - GERMO MATT
--WEEK 4

--ÜLESANNE Analüüsida tootekategooriaid, laoseisu ja müüdud vs laos suhteid. Kasutan GROUP BY, HAVING ja window functions, et leida probleemsed kategooriad.

--Tootekategooriate koondandmed. Koostan ülevaade kategooriate kaupa:
SELECT      p.category,      
COUNT(DISTINCT p.product_id) AS tooteid,      
ROUND(AVG(p.retail_price), 2) AS keskmine_hind,      
MIN(p.retail_price) AS min_hind,      MAX(p.retail_price) AS max_hind    
FROM products p    
GROUP BY p.category    
ORDER BY tooteid DESC; 

--Tulemus
//| category      | tooteid | keskmine_hind | min_hind | max_hind |
//| ------------- | ------- | ------------- | -------- | -------- |
//| meeste_riided | 82      | 189.91        | 48.85    | 374.54   |
//| jalanõusid    | 73      | 214.10        | 58.49    | 434.08   |
//| laste_riided  | 70      | 85.30         | 22.70    | 168.82   |
//| naiste_riided | 70      | 192.58        | 32.93    | 351.33   |
//| aksessuaarid  | 67      | 125.71        | 13.53    | 231.13   |

--====================================================================================
--Müüdud vs laos — kirjutan ise, ühendades products + sales:
SELECT 
    p.category,
    SUM(s.quantity) AS müüdud_kogus,
    ROUND(AVG(s.quantity), 2) AS keskmine_müüdud_kogus_toote_kohta
FROM products p
JOIN sales s ON p.product_id = s.product_id
GROUP BY p.category
HAVING SUM(s.quantity) > 100 -- Vali siia ise sobiv piirarv
ORDER BY müüdud_kogus DESC;

--Tulemus--
| category      | müüdud_kogus | keskmine_müüdud_kogus_toote_kohta |
| ------------- | ------------ | --------------------------------- |
| meeste_riided | 4121         | 1.82                              |
| jalanõusid    | 3737         | 1.84                              |
| laste_riided  | 3686         | 1.82                              |
| naiste_riided | 3604         | 1.78                              |
| aksessuaarid  | 3231         | 1.82                              |

--====================================================================================
--1. Toodete järjestus kategooria sees — kasuta window function'i:
SELECT      p.product_name,      p.category,      p.retail_price,      ROW_NUMBER() OVER (        PARTITION BY p.category        
ORDER BY p.retail_price DESC      ) AS koht_kategoorias    
FROM products p;  

--Tulemus--
| product_name                                   | category      | retail_price | koht_kategoorias |
| ---------------------------------------------- | ------------- | ------------ | ---------------- |
| Luksuslik metallist labakindad                 | aksessuaarid  | 231.13       | 1                |
| Moodne keraamiline nahkvöö                     | aksessuaarid  | 225.28       | 2                |
| Kerge siidine nahkkindad                       | aksessuaarid  | 219.83       | 3                |
| Kerge siidine nahkkindad                       | aksessuaarid  | 219.83       | 4                |
| Stiilne kangast nokamüts                       | aksessuaarid  | 219.38       | 5                |
| Stiilne villane seljakott                      | aksessuaarid  | 215.58       | 6                |
| Praktiline kangast reisikott                   | aksessuaarid  | 208.72       | 7                |
| Stiilne puust müts                             | aksessuaarid  | 205.89       | 8                |
| Stiilne puust müts                             | aksessuaarid  | 205.89       | 9                |
| Praktiline villane kott                        | aksessuaarid  | 204.87       | 10               |
| Boheemlaslik villane barett                    | aksessuaarid  | 203.39       | 11               |
| Õhuline villane sõrmus                         | aksessuaarid  | 199.80       | 12               |
| Kerge metallist labakindad                     | aksessuaarid  | 194.57       | 13               |
| Vintage kangast vöö                            | aksessuaarid  | 191.48       | 14               |
| Klassikaline nahkne sõrmus                     | aksessuaarid  | 188.91       | 15               |
| Stiilne villane sõrmkindad                     | aksessuaarid  | 184.15       | 16               |
| Trendikas kangast kindad                       | aksessuaarid  | 184.02       | 17               |
| Moodne siidine sall                            | aksessuaarid  | 183.40       | 18               |
| Boheemlaslik siidine sõrmkindad                | aksessuaarid  | 183.31       | 19               |
| Boheemlaslik kangast kangasvöö                 | aksessuaarid  | 181.68       | 20               |
| Praktiline kangast elastne vöö                 | aksessuaarid  | 176.65       | 21               |
| Elegantne siidine müts                         | aksessuaarid  | 173.62       | 22               |
| Praktiline keraamiline kaabu                   | aksessuaarid  | 169.95       | 23               |
| Õhuline nahkne elastne vöö                     | aksessuaarid  | 156.13       | 24               |
| Elegantne keraamiline rahakott                 | aksessuaarid  | 155.84       | 25               |
| Elegantne keraamiline rahakott                 | aksessuaarid  | 155.84       | 26               |
| Moodne kangast sõrmus                          | aksessuaarid  | 155.45       | 27               |
| Minimalistlik puust kootud müts                | aksessuaarid  | 153.11       | 28               |
| Luksuslik keraamiline elastne vöö              | aksessuaarid  | 149.55       | 29               |
| Luksuslik keraamiline elastne vöö              | aksessuaarid  | 149.55       | 30               |
| Praktiline nahkne sõrmus                       | aksessuaarid  | 149.47       | 31               |
| Moodne keraamiline sall                        | aksessuaarid  | 147.16       | 32               |
| Moodne keraamiline sall                        | aksessuaarid  | 147.16       | 33               |
| Trendikas nahkne sõrmus                        | aksessuaarid  | 145.72       | 34               |
| Klassikaline nahkne nahkkindad                 | aksessuaarid  | 144.36       | 35               |
| Elegantne keraamiline labakindad               | aksessuaarid  | 134.94       | 36               |
| Moodne metallist rätik                         | aksessuaarid  | 122.07       | 37               |
| Luksuslik keraamiline seljakott                | aksessuaarid  | 121.98       | 38               |
| Trendikas kangast nokamüts                     | aksessuaarid  | 117.05       | 39               |
| Trendikas villane nahkkindad                   | aksessuaarid  | 113.86       | 40               |
| Klassikaline puust nahkvöö                     | aksessuaarid  | 111.74       | 41               |
| Elegantne villane kaabu                        | aksessuaarid  | 109.42       | 42               |
| Minimalistlik siidine labakindad               | aksessuaarid  | 107.26       | 43               |
| Vintage metallist seljakott                    | aksessuaarid  | 106.71       | 44               |
| Klassikaline kangast nahkkindad                | aksessuaarid  | 95.39        | 45               |
| Elegantne kangast kindad                       | aksessuaarid  | 93.13        | 46               |
| Õhuline siidine kaelakee                       | aksessuaarid  | 74.81        | 47               |
| Minimalistlik keraamiline sall                 | aksessuaarid  | 66.88        | 48               |
| Elegantne puust kootud müts                    | aksessuaarid  | 65.60        | 49               |
| Boheemlaslik kangast reisikott                 | aksessuaarid  | 62.56        | 50               |
| Kerge puust barett                             | aksessuaarid  | 57.08        | 51               |
| Elegantne klaasist barett                      | aksessuaarid  | 51.10        | 52               |
| Praktiline puust sall                          | aksessuaarid  | 50.85        | 53               |
| Praktiline klaasist sõrmkindad                 | aksessuaarid  | 47.88        | 54               |
| Boheemlaslik klaasist kaelakee                 | aksessuaarid  | 47.07        | 55               |
| Stiilne siidine labakindad                     | aksessuaarid  | 45.21        | 56               |
| Mugav klaasist kõrvarõngad                     | aksessuaarid  | 29.48        | 57               |
| Kerge nahkne õlakott                           | aksessuaarid  | 29.42        | 58               |
| Trendikas keraamiline sõrmkindad               | aksessuaarid  | 28.56        | 59               |
| Vintage keraamiline barett                     | aksessuaarid  | 26.79        | 60               |
| Moodne nahkne müts                             | aksessuaarid  | 23.45        | 61               |
| Elegantne metallist sall                       | aksessuaarid  | 22.04        | 62               |
| Luksuslik nahkne käekott                       | aksessuaarid  | 17.97        | 63               |
| Moodne villane kaelasall                       | aksessuaarid  | 16.62        | 64               |
| Soe siidine kaelakee                           | aksessuaarid  | 16.37        | 65               |
| Praktiline siidine rätik                       | aksessuaarid  | 15.09        | 66               |
| Vintage villane kangasvöö                      | aksessuaarid  | 13.53        | 67               |
| Õhuline sünteetiline sporditossud              | jalanõusid    | 434.08       | 1                |
| Klassikaline seemisnahkne jooksutossud         | jalanõusid    | 402.62       | 2                |
| Õhuline villane jooksutossud                   | jalanõusid    | 376.33       | 3                |
| Soe sünteetiline loaferid                      | jalanõusid    | 375.34       | 4                |
| Luksuslik villane pahkluu saapad               | jalanõusid    | 371.79       | 5                |
| Trendikas goretex oxfordid                     | jalanõusid    | 371.05       | 6                |
| Stiilne goretex kingad                         | jalanõusid    | 368.97       | 7                |
| Moodne villane nahk sandaalid                  | jalanõusid    | 368.67       | 8                |
| Moodne villane nahk sandaalid                  | jalanõusid    | 368.67       | 9                |
| Sportlik kangast tossud                        | jalanõusid    | 358.41       | 10               |
| Õhuline goretex tennised                       | jalanõusid    | 350.19       | 11               |
| Boheemlaslik villane tennised                  | jalanõusid    | 339.21       | 12               |
| Õhuline nahkne sporditossud                    | jalanõusid    | 329.99       | 13               |
| Boheemlaslik kangast rannasandaalid            | jalanõusid    | 324.38       | 14               |
| Praktiline kangast kõrge kontsaga kingad       | jalanõusid    | 319.98       | 15               |
| Sportlik seemisnahkne nahk sandaalid           | jalanõusid    | 307.27       | 16               |
| Õhuline sünteetiline rannasandaalid            | jalanõusid    | 302.86       | 17               |
| Sportlik villane tossud                        | jalanõusid    | 292.61       | 18               |
| Õhuline sünteetiline kõrge kontsaga kingad     | jalanõusid    | 291.72       | 19               |
| Sportlik kangast tennised                      | jalanõusid    | 282.29       | 20               |
| Minimalistlik nahkne platvormi kontsad         | jalanõusid    | 280.13       | 21               |
| Klassikaline kangast tennised                  | jalanõusid    | 276.97       | 22               |
| Õhuline goretex kingad                         | jalanõusid    | 274.87       | 23               |
| Soe seemisnahkne nahk sandaalid                | jalanõusid    | 273.32       | 24               |
| Boheemlaslik goretex kingad                    | jalanõusid    | 273.06       | 25               |
| Vintage villane rannasandaalid                 | jalanõusid    | 271.35       | 26               |
| Soe nahkne platvormi kontsad                   | jalanõusid    | 270.69       | 27               |
| Klassikaline kangast platvormi kontsad         | jalanõusid    | 253.80       | 28               |
| Soe sünteetiline sandaalid                     | jalanõusid    | 252.10       | 29               |
| Õhuline villane platvorm sandaalid             | jalanõusid    | 251.52       | 30               |
| Õhuline seemisnahkne rannasandaalid            | jalanõusid    | 241.13       | 31               |
| Boheemlaslik nahkne talvesaapad                | jalanõusid    | 234.91       | 32               |
| Klassikaline villane madalad kontsad           | jalanõusid    | 232.61       | 33               |
| Trendikas nahkne oxfordid                      | jalanõusid    | 228.81       | 34               |
| Moodne seemisnahkne oxfordid                   | jalanõusid    | 221.42       | 35               |
| Mugav goretex platvormi kontsad                | jalanõusid    | 221.19       | 36               |
| Boheemlaslik nahkne kõrge kontsaga kingad      | jalanõusid    | 218.54       | 37               |
| Kerge villane talvesaapad                      | jalanõusid    | 210.36       | 38               |
| Minimalistlik villane nahk sandaalid           | jalanõusid    | 207.23       | 39               |
| Soe seemisnahkne jooksutossud                  | jalanõusid    | 206.34       | 40               |
| Boheemlaslik seemisnahkne oxfordid             | jalanõusid    | 198.42       | 41               |
| Praktiline nahkne nahk sandaalid               | jalanõusid    | 190.81       | 42               |
| Trendikas sünteetiline platvorm sandaalid      | jalanõusid    | 187.16       | 43               |
| Vintage nahkne tossud                          | jalanõusid    | 179.95       | 44               |
| Vintage nahkne tossud                          | jalanõusid    | 179.95       | 45               |
| Minimalistlik sünteetiline saapad              | jalanõusid    | 163.64       | 46               |
| Trendikas goretex chelsea botased              | jalanõusid    | 158.94       | 47               |
| Praktiline seemisnahkne tennised               | jalanõusid    | 157.49       | 48               |
| Praktiline seemisnahkne saapad                 | jalanõusid    | 153.62       | 49               |
| Mugav kangast sandaalid                        | jalanõusid    | 147.58       | 50               |
| Soe villane kingad                             | jalanõusid    | 145.50       | 51               |
| Stiilne nahkne derbyd                          | jalanõusid    | 141.05       | 52               |
| Luksuslik goretex derbyd                       | jalanõusid    | 132.30       | 53               |
| Sportlik nahkne madalad kontsad                | jalanõusid    | 128.66       | 54               |
| Stiilne kangast jooksutossud                   | jalanõusid    | 121.51       | 55               |
| Mugav kangast tennised                         | jalanõusid    | 120.17       | 56               |
| Moodne kangast derbyd                          | jalanõusid    | 116.87       | 57               |
| Sportlik goretex nahk sandaalid                | jalanõusid    | 96.11        | 58               |
| Minimalistlik nahkne derbyd                    | jalanõusid    | 84.54        | 59               |
| Minimalistlik seemisnahkne chelsea botased     | jalanõusid    | 84.41        | 60               |
| Luksuslik sünteetiline nahk sandaalid          | jalanõusid    | 83.97        | 61               |
| Õhuline kangast nahk sandaalid                 | jalanõusid    | 81.48        | 62               |
| Luksuslik villane saapad                       | jalanõusid    | 74.70        | 63               |
| Elegantne villane platvorm sandaalid           | jalanõusid    | 74.41        | 64               |
| Elegantne kangast platvorm sandaalid           | jalanõusid    | 73.18        | 65               |
| Trendikas sünteetiline mokassiinid             | jalanõusid    | 69.39        | 66               |
| Luksuslik sünteetiline loaferid                | jalanõusid    | 67.75        | 67               |
| Luksuslik goretex tennised                     | jalanõusid    | 65.52        | 68               |
| Vintage seemisnahkne jooksutossud              | jalanõusid    | 65.00        | 69               |
| Stiilne villane kontsakingad                   | jalanõusid    | 63.95        | 70               |
| Luksuslik goretex rannasandaalid               | jalanõusid    | 63.62        | 71               |
| Soe kangast nahk sandaalid                     | jalanõusid    | 62.55        | 72               |
| Luksuslik nahkne madalad kontsad               | jalanõusid    | 58.49        | 73               |
| Vintage fliisist koolikomplekt                 | laste_riided  | 168.82       | 1                |
| Trendikas trikoo chino püksid                  | laste_riided  | 167.23       | 2                |
| Sportlik softshell sukkpüksid                  | laste_riided  | 152.85       | 3                |
| Mugav softshell slim-fit püksid                | laste_riided  | 151.45       | 4                |
| Minimalistlik fliisist slim-fit püksid         | laste_riided  | 147.92       | 5                |
| Moodne orgaaniline skaterkleit                 | laste_riided  | 141.62       | 6                |
| Minimalistlik villane bleiser                  | laste_riided  | 140.64       | 7                |
| Õhuline orgaaniline alussärk                   | laste_riided  | 138.13       | 8                |
| Luksuslik orgaaniline pühapäevakleit           | laste_riided  | 136.30       | 9                |
| Vintage orgaaniline body                       | laste_riided  | 130.73       | 10               |
| Mugav puuvillane suvekleit                     | laste_riided  | 130.02       | 11               |
| Mugav fliisist alussärk                        | laste_riided  | 128.37       | 12               |
| Moodne fliisist teksapüksid                    | laste_riided  | 125.36       | 13               |
| Praktiline puuvillane teksapüksid              | laste_riided  | 123.64       | 14               |
| Stiilne fliisist komplekt                      | laste_riided  | 114.80       | 15               |
| Minimalistlik softshell cargo püksid           | laste_riided  | 112.68       | 16               |
| Elegantne villane sukkpüksid                   | laste_riided  | 110.70       | 17               |
| Vintage orgaaniline komplekt                   | laste_riided  | 107.36       | 18               |
| Stiilne orgaaniline pidžaama                   | laste_riided  | 106.82       | 19               |
| Stiilne orgaaniline pidžaama                   | laste_riided  | 106.82       | 20               |
| Luksuslik fliisist komplekt                    | laste_riided  | 106.21       | 21               |
| Elegantne orgaaniline dressikomplekt           | laste_riided  | 105.29       | 22               |
| Soe trikoo pühapäevakleit                      | laste_riided  | 105.23       | 23               |
| Soe puuvillane pühapäevakleit                  | laste_riided  | 104.85       | 24               |
| Trendikas trikoo skaterkleit                   | laste_riided  | 104.27       | 25               |
| Boheemlaslik orgaaniline bleiser               | laste_riided  | 101.26       | 26               |
| Soe softshell sukkpüksid                       | laste_riided  | 100.57       | 27               |
| Elegantne puuvillane body                      | laste_riided  | 100.40       | 28               |
| Vintage softshell alussärk                     | laste_riided  | 99.57        | 29               |
| Stiilne puuvillane mantelpaltoo                | laste_riided  | 98.68        | 30               |
| Sportlik softshell teksapüksid                 | laste_riided  | 95.87        | 31               |
| Minimalistlik trikoo pidžaama                  | laste_riided  | 94.65        | 32               |
| Trendikas villane tuulejope                    | laste_riided  | 94.25        | 33               |
| Minimalistlik trikoo tuulejope                 | laste_riided  | 88.08        | 34               |
| Elegantne orgaaniline tuulejope                | laste_riided  | 87.06        | 35               |
| Moodne trikoo koolikomplekt                    | laste_riided  | 86.46        | 36               |
| Sportlik puuvillane chino püksid               | laste_riided  | 86.14        | 37               |
| Mugav softshell teksapüksid                    | laste_riided  | 84.95        | 38               |
| Luksuslik villane bleiser                      | laste_riided  | 80.39        | 39               |
| Mugav villane body                             | laste_riided  | 77.78        | 40               |
| Trendikas puuvillane body                      | laste_riided  | 73.90        | 41               |
| Praktiline trikoo püksid                       | laste_riided  | 72.60        | 42               |
| Sportlik fliisist slim-fit püksid              | laste_riided  | 72.58        | 43               |
| Vintage villane püksid                         | laste_riided  | 72.14        | 44               |
| Luksuslik orgaaniline dressikomplekt           | laste_riided  | 66.21        | 45               |
| Boheemlaslik softshell komplekt                | laste_riided  | 63.87        | 46               |
| Trendikas villane dressikomplekt               | laste_riided  | 62.82        | 47               |
| Mugav puuvillane pühapäevakleit                | laste_riided  | 60.80        | 48               |
| Minimalistlik villane pühapäevakleit           | laste_riided  | 55.04        | 49               |
| Kerge puuvillane chino püksid                  | laste_riided  | 54.95        | 50               |
| Luksuslik trikoo slim-fit püksid               | laste_riided  | 54.81        | 51               |
| Moodne villane pühapäevakleit                  | laste_riided  | 53.99        | 52               |
| Soe orgaaniline sokid                          | laste_riided  | 53.19        | 53               |
| Elegantne orgaaniline kleit                    | laste_riided  | 52.04        | 54               |
| Soe puuvillane chino püksid                    | laste_riided  | 51.58        | 55               |
| Minimalistlik softshell chino püksid           | laste_riided  | 51.50        | 56               |
| Soe fliisist pidžaama                          | laste_riided  | 48.58        | 57               |
| Õhuline softshell dressikomplekt               | laste_riided  | 47.38        | 58               |
| Minimalistlik softshell alussärk               | laste_riided  | 41.79        | 59               |
| Praktiline puuvillane sukkpüksid               | laste_riided  | 38.70        | 60               |
| Moodne puuvillane komplekt                     | laste_riided  | 35.68        | 61               |
| Sportlik villane püksid                        | laste_riided  | 34.04        | 62               |
| Trendikas trikoo jakk                          | laste_riided  | 31.65        | 63               |
| Trendikas fliisist tuulejope                   | laste_riided  | 30.05        | 64               |
| Luksuslik softshell komplekt                   | laste_riided  | 26.62        | 65               |
| Moodne orgaaniline bleiser                     | laste_riided  | 24.67        | 66               |
| Praktiline trikoo sukkpüksid                   | laste_riided  | 24.54        | 67               |
| Praktiline trikoo sukkpüksid                   | laste_riided  | 24.54        | 68               |
| Vintage softshell cargo püksid                 | laste_riided  | 23.68        | 69               |
| Minimalistlik puuvillane pidžaama              | laste_riided  | 22.70        | 70               |
| Vintage tweed kampsun                          | meeste_riided | 374.54       | 1                |
| Õhuline tweed püksid                           | meeste_riided | 356.57       | 2                |
| Sportlik džersii ülikond                       | meeste_riided | 351.62       | 3                |
| Luksuslik teksane polo särk                    | meeste_riided | 347.84       | 4                |
| Luksuslik teksane polo särk                    | meeste_riided | 347.84       | 5                |
| Mugav flanellne linane kostüüm                 | meeste_riided | 347.16       | 6                |
| Mugav tweed ülikond                            | meeste_riided | 338.43       | 7                |
| Praktiline merino villane parka                | meeste_riided | 332.55       | 8                |
| Õhuline polüester cargo püksid                 | meeste_riided | 327.07       | 9                |
| Trendikas džersii slim-fit püksid              | meeste_riided | 316.04       | 10               |
| Mugav merino villane tuulejope                 | meeste_riided | 312.41       | 11               |
| Luksuslik flanellne smokingüklikond            | meeste_riided | 296.58       | 12               |
| Moodne merino villane triiksärk                | meeste_riided | 281.19       | 13               |
| Praktiline polüester ülikond                   | meeste_riided | 279.43       | 14               |
| Kerge flanellne kardigan                       | meeste_riided | 278.59       | 15               |
| Mugav linane linane kostüüm                    | meeste_riided | 274.78       | 16               |
| Luksuslik polüester V-kaelusega kampsun        | meeste_riided | 274.50       | 17               |
| Moodne tweed smokingüklikond                   | meeste_riided | 270.99       | 18               |
| Soe flanellne chino püksid                     | meeste_riided | 269.85       | 19               |
| Luksuslik tweed triiksärk                      | meeste_riided | 259.69       | 20               |
| Kerge linane teksapüksid                       | meeste_riided | 259.23       | 21               |
| Mugav merino villane cargo püksid              | meeste_riided | 258.91       | 22               |
| Luksuslik puuvillane linane särk               | meeste_riided | 253.26       | 23               |
| Vintage linane bleiser                         | meeste_riided | 247.81       | 24               |
| Minimalistlik džersii polo särk                | meeste_riided | 246.97       | 25               |
| Soe polüester smokingüklikond                  | meeste_riided | 243.93       | 26               |
| Sportlik polüester püksid                      | meeste_riided | 242.43       | 27               |
| Soe teksane chino püksid                       | meeste_riided | 234.79       | 28               |
| Vintage polüester slim-fit püksid              | meeste_riided | 230.06       | 29               |
| Boheemlaslik tweed smokingüklikond             | meeste_riided | 229.01       | 30               |
| Elegantne flanellne cargo püksid               | meeste_riided | 218.42       | 31               |
| Soe linane mantelpaltoo                        | meeste_riided | 210.87       | 32               |
| Klassikaline flanellne cargo püksid            | meeste_riided | 208.11       | 33               |
| Õhuline flanellne smokingüklikond              | meeste_riided | 205.00       | 34               |
| Moodne džersii slim-fit ülikond                | meeste_riided | 203.67       | 35               |
| Boheemlaslik polüester slim-fit särk           | meeste_riided | 201.86       | 36               |
| Mugav tweed kardigan                           | meeste_riided | 198.29       | 37               |
| Sportlik džersii püksid                        | meeste_riided | 196.91       | 38               |
| Õhuline puuvillane kampsun                     | meeste_riided | 184.07       | 39               |
| Soe polüester cargo püksid                     | meeste_riided | 175.25       | 40               |
| Soe teksane bleiser                            | meeste_riided | 171.33       | 41               |
| Boheemlaslik merino villane poolsäärne kampsun | meeste_riided | 163.53       | 42               |
| Praktiline polüester casual särk               | meeste_riided | 160.91       | 43               |
| Stiilne džersii püksid                         | meeste_riided | 160.71       | 44               |
| Boheemlaslik merino villane cargo püksid       | meeste_riided | 160.21       | 45               |
| Õhuline flanellne V-kaelusega kampsun          | meeste_riided | 159.25       | 46               |
| Klassikaline linane parka                      | meeste_riided | 154.71       | 47               |
| Mugav polüester püksid                         | meeste_riided | 152.13       | 48               |
| Vintage merino villane tuulejope               | meeste_riided | 151.08       | 49               |
| Mugav flanellne parka                          | meeste_riided | 144.20       | 50               |
| Mugav puuvillane kardigan                      | meeste_riided | 143.42       | 51               |
| Sportlik linane bleiser                        | meeste_riided | 142.57       | 52               |
| Soe polüester slim-fit püksid                  | meeste_riided | 138.90       | 53               |
| Praktiline puuvillane ülikond                  | meeste_riided | 137.33       | 54               |
| Vintage tweed smokingüklikond                  | meeste_riided | 134.58       | 55               |
| Kerge puuvillane slim-fit särk                 | meeste_riided | 127.38       | 56               |
| Sportlik merino villane ülikond                | meeste_riided | 126.42       | 57               |
| Elegantne teksane cargo püksid                 | meeste_riided | 125.52       | 58               |
| Elegantne tweed bleiser                        | meeste_riided | 124.35       | 59               |
| Luksuslik džersii chino püksid                 | meeste_riided | 123.82       | 60               |
| Elegantne tweed smokingüklikond                | meeste_riided | 120.59       | 61               |
| Stiilne linane tuulejope                       | meeste_riided | 116.20       | 62               |
| Sportlik polüester slim-fit ülikond            | meeste_riided | 114.94       | 63               |
| Kerge teksane slim-fit ülikond                 | meeste_riided | 110.53       | 64               |
| Vintage teksane chino püksid                   | meeste_riided | 107.67       | 65               |
| Moodne flanellne triiksärk                     | meeste_riided | 106.69       | 66               |
| Kerge linane kampsun                           | meeste_riided | 105.09       | 67               |
| Boheemlaslik polüester casual särk             | meeste_riided | 100.93       | 68               |
| Moodne polüester slim-fit särk                 | meeste_riided | 100.78       | 69               |
| Sportlik puuvillane smokingüklikond            | meeste_riided | 96.50        | 70               |
| Elegantne linane linane särk                   | meeste_riided | 93.70        | 71               |
| Klassikaline tweed kardigan                    | meeste_riided | 91.22        | 72               |
| Klassikaline linane mantelpaltoo               | meeste_riided | 89.39        | 73               |
| Õhuline linane bleiser                         | meeste_riided | 83.10        | 74               |
| Elegantne tweed püksid                         | meeste_riided | 82.15        | 75               |
| Luksuslik džersii ülikond                      | meeste_riided | 81.85        | 76               |
| Soe teksane smokingüklikond                    | meeste_riided | 79.59        | 77               |
| Klassikaline flanellne smokingüklikond         | meeste_riided | 77.60        | 78               |
| Praktiline flanellne linane särk               | meeste_riided | 70.01        | 79               |
| Klassikaline džersii bleiser                   | meeste_riided | 53.01        | 80               |
| Trendikas flanellne mantelpaltoo               | meeste_riided | 53.01        | 81               |
| Luksuslik tweed linane särk                    | meeste_riided | 48.85        | 82               |
| Boheemlaslik linane pullover                   | naiste_riided | 351.33       | 1                |
| Praktiline džersii seelik                      | naiste_riided | 319.42       | 2                |
| Boheemlaslik puuvillane tuulejope              | naiste_riided | 308.84       | 3                |
| Õhuline linane jakk                            | naiste_riided | 307.83       | 4                |
| Trendikas viskoosne topik                      | naiste_riided | 304.14       | 5                |
| Kerge džersii pluus                            | naiste_riided | 301.97       | 6                |
| Klassikaline puuvillane skaterkleit            | naiste_riided | 296.40       | 7                |
| Trendikas džersii pullover                     | naiste_riided | 291.36       | 8                |
| Vintage džersii tuunika                        | naiste_riided | 290.55       | 9                |
| Sportlik džersii parka                         | naiste_riided | 282.95       | 10               |
| Soe siidine särk-pluus                         | naiste_riided | 280.02       | 11               |
| Trendikas puuvillane skaterkleit               | naiste_riided | 274.37       | 12               |
| Praktiline viskoosne õhtukleit                 | naiste_riided | 272.05       | 13               |
| Sportlik linane jakk                           | naiste_riided | 265.20       | 14               |
| Soe satiinne pluus                             | naiste_riided | 263.13       | 15               |
| Moodne kashmiir pullover                       | naiste_riided | 257.39       | 16               |
| Mugav kashmiir pusa                            | naiste_riided | 252.33       | 17               |
| Luksuslik merino villane kapuutsiga pusa       | naiste_riided | 250.17       | 18               |
| Luksuslik merino villane chino püksid          | naiste_riided | 247.52       | 19               |
| Boheemlaslik merino villane kapuutsiga pusa    | naiste_riided | 245.59       | 20               |
| Klassikaline viskoosne õhtukleit               | naiste_riided | 237.71       | 21               |
| Õhuline viskoosne jakk                         | naiste_riided | 234.99       | 22               |
| Elegantne džersii cargo püksid                 | naiste_riided | 229.55       | 23               |
| Klassikaline kashmiir pusa                     | naiste_riided | 225.81       | 24               |
| Klassikaline kashmiir pusa                     | naiste_riided | 225.81       | 25               |
| Boheemlaslik satiinne seelik                   | naiste_riided | 224.19       | 26               |
| Trendikas viskoosne tuulejope                  | naiste_riided | 222.10       | 27               |
| Sportlik puuvillane slim-fit püksid            | naiste_riided | 221.89       | 28               |
| Elegantne linane bleiser                       | naiste_riided | 219.19       | 29               |
| Boheemlaslik džersii teksapüksid               | naiste_riided | 218.99       | 30               |
| Praktiline viskoosne jakk                      | naiste_riided | 213.35       | 31               |
| Moodne viskoosne plisseeseelik                 | naiste_riided | 211.35       | 32               |
| Soe puuvillane teksapüksid                     | naiste_riided | 210.76       | 33               |
| Stiilne kashmiir jakk                          | naiste_riided | 209.05       | 34               |
| Soe merino villane topik                       | naiste_riided | 208.83       | 35               |
| Kerge satiinne jakk                            | naiste_riided | 206.52       | 36               |
| Moodne kashmiir plisseeseelik                  | naiste_riided | 202.57       | 37               |
| Mugav kashmiir skaterkleit                     | naiste_riided | 200.77       | 38               |
| Soe džersii cargo püksid                       | naiste_riided | 194.46       | 39               |
| Minimalistlik kashmiir bleiser                 | naiste_riided | 185.46       | 40               |
| Minimalistlik kashmiir bleiser                 | naiste_riided | 185.46       | 41               |
| Elegantne siidine teksapüksid                  | naiste_riided | 182.77       | 42               |
| Mugav džersii pusa                             | naiste_riided | 180.14       | 43               |
| Luksuslik puuvillane jakk                      | naiste_riided | 179.35       | 44               |
| Mugav merino villane dressipluus               | naiste_riided | 168.34       | 45               |
| Praktiline merino villane pusa                 | naiste_riided | 166.27       | 46               |
| Vintage siidine skaterkleit                    | naiste_riided | 166.27       | 47               |
| Klassikaline siidine tuulejope                 | naiste_riided | 162.86       | 48               |
| Elegantne kashmiir tuulejope                   | naiste_riided | 158.51       | 49               |
| Mugav viskoosne plisseeseelik                  | naiste_riided | 150.11       | 50               |
| Trendikas džersii miniseelik                   | naiste_riided | 139.74       | 51               |
| Minimalistlik linane tuunika                   | naiste_riided | 135.99       | 52               |
| Minimalistlik džersii pullover                 | naiste_riided | 130.36       | 53               |
| Kerge viskoosne suvekleit                      | naiste_riided | 125.98       | 54               |
| Moodne satiinne bleiser                        | naiste_riided | 122.45       | 55               |
| Vintage viskoosne püksid                       | naiste_riided | 111.26       | 56               |
| Moodne viskoosne teksapüksid                   | naiste_riided | 110.02       | 57               |
| Soe džersii suvekleit                          | naiste_riided | 109.62       | 58               |
| Luksuslik satiinne teksapüksid                 | naiste_riided | 108.09       | 59               |
| Õhuline viskoosne miniseelik                   | naiste_riided | 95.50        | 60               |
| Vintage viskoosne kapuutsiga pusa              | naiste_riided | 86.80        | 61               |
| Moodne kashmiir seelik                         | naiste_riided | 83.23        | 62               |
| Minimalistlik viskoosne skaterkleit            | naiste_riided | 78.09        | 63               |
| Luksuslik linane bleiser                       | naiste_riided | 76.70        | 64               |
| Minimalistlik džersii chino püksid             | naiste_riided | 72.73        | 65               |
| Soe viskoosne skaterkleit                      | naiste_riided | 60.37        | 66               |
| Sportlik siidine cargo püksid                  | naiste_riided | 50.77        | 67               |
| Stiilne merino villane parka                   | naiste_riided | 42.64        | 68               |
| Minimalistlik puuvillane tuunika               | naiste_riided | 41.63        | 69               |
| Klassikaline satiinne mantelpaltoo             | naiste_riided | 32.93        | 70               |

--====================================================================================
--Edasijõudnute (30%): Samm 3 — window function toodete järjestamiseks. 
--Lisa lisaküsimus: millised tooted on TOP 3 igas kategoorias ja kuidas nende müük on jaotunud?

-- Edasijõudnute (30%) lisaülesanne: TOP 3 toodet igas kategoorias müügi järgi
WITH RankedSales AS (
    SELECT 
        p.category,
        p.product_name,
        p.retail_price,
        SUM(s.quantity) AS myydud_tk,
        ROUND(SUM(s.quantity * p.retail_price), 2) AS myygi_kaive,
        -- Kasutame DENSE_RANK(), et viigi korral ei jääks mõni toode välja
        DENSE_RANK() OVER (
            PARTITION BY p.category 
            ORDER BY SUM(s.quantity) DESC
        ) AS myygi_koht_kategoorias
    FROM products p
    JOIN sales s ON p.product_id = s.product_id
    GROUP BY 
        p.category,
        p.product_name,
        p.retail_price
)
-- Valime CTE-st ainult need, mis on TOP 3 hulgas
SELECT 
    category,
    product_name,
    retail_price,
    myydud_tk,
    myygi_kaive,
    myygi_koht_kategoorias
FROM RankedSales
WHERE myygi_koht_kategoorias <= 3
ORDER BY 
    category ASC, 
    myygi_koht_kategoorias ASC;

--Tulemus--
| category      | product_name                               | retail_price | myydud_tk | myygi_kaive | myygi_koht_kategoorias |
| ------------- | ------------------------------------------ | ------------ | --------- | ----------- | ---------------------- |
| aksessuaarid  | Stiilne puust müts                         | 205.89       | 78        | 16059.42    | 1                      |
| aksessuaarid  | Praktiline nahkne sõrmus                   | 149.47       | 75        | 11210.25    | 2                      |
| aksessuaarid  | Boheemlaslik kangast kangasvöö             | 181.68       | 70        | 12717.60    | 3                      |
| aksessuaarid  | Moodne keraamiline sall                    | 147.16       | 70        | 10301.20    | 3                      |
| jalanõusid    | Moodne seemisnahkne oxfordid               | 221.42       | 83        | 18377.86    | 1                      |
| jalanõusid    | Õhuline sünteetiline kõrge kontsaga kingad | 291.72       | 79        | 23045.88    | 2                      |
| jalanõusid    | Minimalistlik seemisnahkne chelsea botased | 84.41        | 71        | 5993.11     | 3                      |
| laste_riided  | Minimalistlik villane pühapäevakleit       | 55.04        | 81        | 4458.24     | 1                      |
| laste_riided  | Luksuslik softshell komplekt               | 26.62        | 80        | 2129.60     | 2                      |
| laste_riided  | Vintage villane püksid                     | 72.14        | 73        | 5266.22     | 3                      |
| meeste_riided | Luksuslik puuvillane linane särk           | 253.26       | 73        | 18487.98    | 1                      |
| meeste_riided | Elegantne flanellne cargo püksid           | 218.42       | 73        | 15944.66    | 1                      |
| meeste_riided | Praktiline puuvillane ülikond              | 137.33       | 72        | 9887.76     | 2                      |
| meeste_riided | Minimalistlik džersii polo särk            | 246.97       | 70        | 17287.90    | 3                      |
| meeste_riided | Mugav merino villane cargo püksid          | 258.91       | 70        | 18123.70    | 3                      |
| naiste_riided | Sportlik siidine cargo püksid              | 50.77        | 77        | 3909.29     | 1                      |
| naiste_riided | Soe džersii cargo püksid                   | 194.46       | 74        | 14390.04    | 2                      |
| naiste_riided | Minimalistlik džersii chino püksid         | 72.73        | 72        | 5236.56     | 3                      |

--
================================================================================
KOKKUVÕTE: TOP 3 TOODET KATEGOORIATE KAUPA JA MÜÜGI JAOTUS
================================================================================

--------------------------------------------------------------------------------
1. TOP 3 TOODET KATEGOORIATE KAUPA
--------------------------------------------------------------------------------

Aksessuaarid:
  * 1. koht: Stiilne puust müts 
    - Müüdud: 78 tk | Jaehind: 205.89 € | Käive: 16 059.42 €
  * 2. koht: Praktiline nahkne sõrmus 
    - Müüdud: 75 tk | Jaehind: 149.47 € | Käive: 11 210.25 €
  * 3. koht (VIIK): Boheemlaslik kangast kangasvöö 
    - Müüdud: 70 tk | Jaehind: 181.68 € | Käive: 12 717.60 €
  * 3. koht (VIIK): Moodne keraamiline sall 
    - Müüdud: 70 tk | Jaehind: 147.16 € | Käive: 10 301.20 €

Jalanõud:
  * 1. koht: Moodne seemisnahkne oxfordid 
    - Müüdud: 83 tk | Jaehind: 221.42 € | Käive: 18 377.86 €
  * 2. koht: Õhuline sünteetiline kõrge kontsaga kingad 
    - Müüdud: 79 tk | Jaehind: 291.72 € | Käive: 23 045.88 €
  * 3. koht: Minimalistlik seemisnahkne chelsea botased 
    - Müüdud: 71 tk | Jaehind: 84.41 €  | Käive: 5 993.11 €

Laste riided:
  * 1. koht: Minimalistlik villane pühapäevakleit 
    - Müüdud: 81 tk | Jaehind: 55.04 €  | Käive: 4 458.24 €
  * 2. koht: Luksuslik softshell komplekt 
    - Müüdud: 80 tk | Jaehind: 26.62 €  | Käive: 2 129.60 €
  * 3. koht: Vintage villane püksid 
    - Müüdud: 73 tk | Jaehind: 72.14 €  | Käive: 5 266.22 €

Meeste riided:
  * 1. koht (VIIK): Luksuslik puuvillane linane särk 
    - Müüdud: 73 tk | Jaehind: 253.26 € | Käive: 18 487.98 €
  * 1. koht (VIIK): Elegantne flanellne cargo püksid 
    - Müüdud: 73 tk | Jaehind: 218.42 € | Käive: 15 944.66 €
  * 2. koht: Praktiline puuvillane ülikond 
    - Müüdud: 72 tk | Jaehind: 137.33 € | Käive: 9 887.76 €
  * 3. koht (VIIK): Minimalistlik džersii polo särk 
    - Müüdud: 70 tk | Jaehind: 246.97 € | Käive: 17 287.90 €
  * 3. koht (VIIK): Mugav merino villane cargo püksid 
    - Müüdud: 70 tk | Jaehind: 258.91 € | Käive: 18 123.70 €

Naiste riided:
  * 1. koht: Sportlik siidine cargo püksid 
    - Müüdud: 77 tk | Jaehind: 50.77 €  | Käive: 3 909.29 €
  * 2. koht: Soe džersii cargo püksid 
    - Müüdud: 74 tk | Jaehind: 194.46 € | Käive: 14 390.04 €
  * 3. koht: Minimalistlik džersii chino püksid 
    - Müüdud: 72 tk | Jaehind: 72.73 €  | Käive: 5 236.56 €