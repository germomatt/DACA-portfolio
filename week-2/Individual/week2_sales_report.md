========================================================================

&#x20;                 SAMM 6: ANDMETE PUHASTAMISRAPORT

========================================================================



\[ ÜLEVAADE PROBLEEMIDEST ]



\------------------------------------------------------------------------

KATEGOORIA              | ARV   | KIRJELDUS

\------------------------------------------------------------------------

Duplikaadid             | 4013  | Korduvad invoice\_id (topelttellimused) // mis asuvad 5116 duplikaatreal.

NULL customer\_id        | 1487  | Puuduv kliendi viide

NULL sale\_date          | 0     | Puuduv kuupäev

NULL total\_price        | 0     | Puuduv summa

Tuleviku kuupäevad      | 0     | Kuupäev on suurem kui tänane

\------------------------------------------------------------------------

KOKKU PROBLEEME         | 5500  | 

\------------------------------------------------------------------------





\[ EKSPERDI SOOVITUS TOOMASELE ]



!!! ESMANE PRIORITEET: DUPLIKAADID (4013 probleemi) !!!



Miks alustada just siit?



1\. Äritulemuste moonutamine:

&#x20;  Korduvad arved rikuvad ettevõtte kõige tähtsamat mõõdikut - käivet. 

&#x20;  4013 lisandunud topeltarvet loovad finantsraportites illusiooni 

&#x20;  ebarealistlikult suurest tulust.



2\. Efektiivsuse võit (doominoefekt):

&#x20;  On väga suur tõenäosus, et osa nendest 1487-st puuduvast kliendist

&#x20;  (NULL customer\_id) asub just samades dubleeritud ridades. 

&#x20;  Duplikaatide eemaldamisel võib teise probleemi maht iseenesest 

&#x20;  kahaneda, säästes nii aega kui vaeva.



\-> JÄRGMINE SAMM: 

&#x20;  Pärast duplikaatide eemaldamist tuleks kohe ette võtta allesjäänud 

&#x20;  "NULL customer\_id" read. See on kriitiline andmebaasi seoste ja 

&#x20;  andmeterviklikkuse taastamiseks.



========================================================================

