Nädal 2 - SQL Puhastamine 

Meeskond: 

Roll A: Müügiandmete puhastamine                - Germo 

Roll B: Kliendiandmete puhastamine              - Liis 

Roll C: Tooteandmete puhastamine                - Liis     

Roll D: Ristvalideerimine ja kvaliteedikontroll - Dmitri   

Roll E: Valideerimine & QA + ärisüntees         - Robi     

---------

Roll A: Müügiandmete puhastamine – Germo 

Soovitus: mida peaks Toomas esimesena parandama? 
Toomas peaks esimesena parandama DUPLIKAADID (4013 probleemi). 

Põhjendus:  

1. Duplikaadid moonutavad ettevõtte kõige olulisemat näitajat – käivet. 4013 topeltarvet tähendab, et finantsraportid näitavad ebarealistlikult suurt tulu. 

2. Töömahu vähenemine: Suur tõenäosus on, et osa neist 1487-st puuduvast kliendiviitest  
(NULL customer_id) asuvad just nendes samades duplikaat-ridades. Kui Toomas eemaldab esmalt topeltrread, võib "NULL customer_id" probleemide arv automaatselt kahaneda, säästes aega ja vaeva. Pärast duplikaatide eemaldamist tuleb kohe lahendada allesjäänud NULL customer_id read, et taastada andmebaasi seoste terviklikkus.


Roll B: Kliendiandmete puhastamine – Liis 

Tulemused 

Algne ridade arv: 3150 
Puuduv eesnimi: 0 
Puuduv perenimi: 0 
Puuduv e-post: 380 
Puuduv linn: 0 

Linnade kirjapildid ühtlustati. 
Pärast puhastamist jäi andmestikku 12 erinevat linna. 

Kokkuvõte: 
Customers tabel oli üldiselt heas kvaliteedis. Peamised tähelepanekud olid ebaühtlased linnade kirjapildid ja 380 puuduva e-posti aadressiga kirjet. Linnade kirjapildid ühtlustati ning andmed on valmis edasiseks analüüsiks. 



Roll C: Tooteandmete puhastamine - Liis    

Tulemused: 
Algne ridade arv: 362 
Pärast duplikaatide eemaldamist: 350 
Eemaldatud duplikaate: 12 
Puuduvad väärtused: 0 
Negatiivseid hindu: 0 
Üle 1000 € hinnaga tooteid: 0 

Kokkuvõte: 
Products tabel puhastati edukalt. Duplikaadid eemaldati ning puuduvad väärtused ja vigased hinnad puudusid. Pärast puhastamist sisaldab tabel 350 kvaliteetset kirjet, mis on valmis edasiseks analüüsiks. 


Roll D: Ristvalideerimine ja kvaliteedikontroll - Dmitri   

-Miks võivad hinnad erineda? (allahindlused, hulgiost, andmeviga?) Enamasti müüakse odavamalt → viitab allahindlustele. Mõnel tootel müüakse kallimalt → see on tõenäoliselt andmeviga. Suurimad erinevused on naiste riietel ja jalanõudel. 
-Miks võivad hinnad erineda? (allahindlused, hulgiost, andmeviga?) Enamasti müüakse odavamalt → viitab allahindlustele. Mõnel tootel müüakse kallimalt → see on tõenäoliselt andmeviga. Suurimad erinevused on naiste riietel ja jalanõudel. 

Soovitus Toomasele: Kõige kriitilisem probleem 
Võttes arvesse auditi tulemusi, on Toomase jaoks kõige kriitilisem probleem vaimklientide suur hulk (592).See viitab kas ebaefektiivsele kliendihaldusele või vigasele registreerimisprotsessile, kus suur hulk potentsiaalseid kliente ei jõua tehinguni.Teisejärgulise, kuid kohest sekkumist vajava probleemina tuleb käsitleda hinnahälbeid (20 juhtu), eriti neid, kus müügihind on tootehinnast kõrgem, kuna see viitab selgetele andmevigadele, mis moonutavad müügistatistikat. 


Roll E: Valideerimine & QA + ärisüntees - Robi  

Soovitame Toomasel keskenduda süsteemide integratsioonile, et vältida edasisi duplikaate, ning Kristi Tammel esitada investoritele ainult puhastatud, unikaalsetel arvetel põhinevat käibeanalüüsi
[x] Soovitus põhineb tegelikel andmetel, mitte oletustel Kõik järeldused põhinevad PostgreSQL andmebaasist (Supabase) pärit reaalsetel kirjetel ja Toomas Kase poolt tuvastatud andmeprobleemidel
Analüüs ei sisalda spekulatsioone, vaid tugineb audit logile ja valideeritud SQL-päringute tulemustele
Toomas Kask võib nüüd olla kindel, et andmed on "kirurgiliselt" puhastatud ja valmis juhatuse koosolekuks
