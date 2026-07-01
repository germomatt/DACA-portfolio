========================================================================
                  SAMM 6: PUHASTAMISRAPORT
========================================================================

[ ÜLEVAADE PROBLEEMIDEST ]

------------------------------------------------------------------------
KATEGOORIA                 | ARV | KIRJELDUS
------------------------------------------------------------------------
Duplikaatsed nimed         | 12  | Sama tootenimi mitu korda
NULL nimi/hind             | 0   | Puuduvad kriitilised väljad
Loogilised vead            | 0   | Negatiivne või äärmuslik jaehind
Ebajärjekindlad kategooriad| 0   | Erinevad nimekujud
NULL omahind/kategooria    | 0   | Puuduv klassifitseerimine
------------------------------------------------------------------------
KOKKU PROBLEEME            | 12  | 
------------------------------------------------------------------------

--Tuvastasin 5 ernevat kategooriat tuleb
--aksessuaarid 67
--jalanõusid 73
--laste riided 70
--meeste riided 82
--naiste riided 70

--Antud andmestiku põhjal on ainukeseks ja seega ka kõige kriitilisemaks 
--probleemiks DUPLIKAATSED NIMED (12 leitud probleemi). 

--Tekib Müügiandmete ebakõla
   --Kui täpselt samal tootel on andmebaasis mitu erinevat rida (ja ID-d), 
   --jaotub selle toote müügiajalugu mitme kirje vahel laiali. See rikub 
   --ära populaarseimate toodete (Bestsellers) raportid, sest süsteem 
   --näeb neid kui eraldi vähem müüdud tooteid.

--Ebatäpne kasumlikkuse analüüs:
   --Kui duplikaatidel on kogemata erinevad oma- või jaehinnad, on 
   --võimatu usaldusväärselt arvutada tootekategooriate kasumimarginaale.