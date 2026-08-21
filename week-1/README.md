# Nädal 1: SQL Basics -- UrbanStyle'i andmete uurimine
## Mida ma tegin
- Uurisin sales ja kliendiandmed tabelit SQL päringutega
- Leidsin 
--Tabelis on 15234 rida
--Tabeli on 12 rida id, sale id, invoice id, sale date, customer id, product id,
--quantity, unit price,  total price, channel, store location ja payment method.
--Üllatav on viga kogus ühes tabelis, miinusega hinnad, kliendi andmed puudulikud jne.
--Palju andmeid on siiski puudu, dubleeritud või lihtsalt vigased

Järeldus: Müügiandmeid on analüüsiks olemas, kuid ennem on vajalik puhastada (duplikaadid, NULL jne)

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

- Soovitused Toomas Kasele
Pärast UrbanStyle andmestiku analüüsi soovitan enne põhjalikuma ärianalüüsi tegemist parandada andmete kvaliteeti.
Näiteks Kontrollida sales tabeli võimalikke duplikaate, võrreldes kõigi müügiridade arvu unikaalsete invoice_id väärtuste arvuga. Duplikaadid põhjustavad palju vale infot.

Kokkuvõte
Nädala 1 jooksul õppisin kasutama SQL päringuid UrbanStyle andmestiku uurimiseks ning analüüsis müügi- ja kliendiandmeid. Analüüsi käigus tuvastasin mitmeid andmekvaliteedi probleeme, sealhulgas võimalikud duplikaadid, negatiivsed müügisummad, puuduvad kliendi ID-d ja e-posti aadressid. Enne põhjalikuma ärianalüüsi tegemist on soovitatav need probleemid lahendada, et tagada usaldusväärsed analüüsitulemused ja paremad ärilised otsused.

Puuduvad andmed
Hetkel ei ole teada kas negatiivsed müügid tähistavad tagastusi või andmevigu ning miks osadel müügikirjetel puudub kliendi ID. Samuti tuleb täiendada products tabeli analüüsi SQL päringute tegelike tulemustega.
