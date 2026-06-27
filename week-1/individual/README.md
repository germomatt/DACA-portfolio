# Nädal 1: SQL Basics -- UrbanStyle'i andmete uurimine
## Mida ma tegin
- Uurisin sales ja kliendiandmed tabelit SQL päringutega
- Leidsin 
Müügikirjeid kokku: 15 234

Suurim tehing: 2170.40 €

Väikseim tehing: -1405.32 €

Puuduv kliendi ID: 1487

Järeldus: Müügiandmeid on analüüsiks olemas, kuid ennem on vajalik puhastada (duplikaadid, NULL jne)
- Osalesin meeskonna andmemaastiku koostamisel

Seejärel uurisin Customers Data tabelit, kus sain tulemusi 

--Andmebaasis on 3150 klienti
--Kokku oli linnades 53 erinevat vastet, kuid enamus linnu oli üht või teistviisi välja kirjutatud 5-6 erineval kujul
--Üllatav minu jaoks oligi, et puuduvates andmetes oli 380 emaili puudu, mis tundub tavapärane info minu jaoks kliendi 
--andmebaasides, kui ei usu et nimel kõigil olemas oli, seda tahaks edasi uurida ning samuti tuleb leida linnade valikul 
--ainult sellisel viisid, et võtad dubleeritud linnad välja ja liidad ühte.

## Failid
- `week1_sales_exploration.sql` -- minu sales SQL päringud
- `week1_customers_exploration.sql` -- minu customers SQL päringud
- `week1_results_screenshot.png` -- sales 1-7 tulemuste pildid
- week1_customers_results_screenshot.pdf -- customers päringute screenshotid
## Meeskonna töö
- [Olin iseseisvalt üksi nö 2 liikmeline meeskond]
