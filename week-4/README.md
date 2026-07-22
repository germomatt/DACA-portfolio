📊 Nädal 4: SQL — Window Functions & Inventuuri Statistika
Tiimi liige: GERMO MATT

Alaülesande kaart: C (Inventuuri statistika)

🎯 Käesoleva nädala eesmärk
Selle nädala peamine fookus oli ettevõtte tootekategooriate, laoseisu ja müügistatistika süvaanalüüs. Eesmärk oli kasutada edasijõudnute SQL-tehnikaid (GROUP BY, HAVING ja Window Functions), et selgitada välja kõige tulusamad kategooriad, murekohad hinnastamises ning järjestada iga kategooria parimad tooted.

🔍 Mida ma tegin & Peamised leiud
1. Tootekategooriate koondandmete analüüs
Kaardistasin kõik tootekategooriad: toodete arv, keskmine, minimaalne ja maksimaalne hind.

Leid: Kõige enam tooteid on meeste riiete kategoorias (82), kõrgeima keskmise hinnaga on aga jalanõud (214.10 €).

2. Müüdud koguste ja laoseisu võrdlus
Uurisin toodete müüki kategooriate lõikes, filtreerides välja ainult need, kus kogumüük ületab määratud piiri (HAVING SUM(quantity) > 100).

Leid: Meeste riided (4121 tk) ja jalanõud (3737 tk) on absoluutsed müügiliidrid nii mahult kui ka rahaliselt.

3. TOP 3 toodete järjestamine kategooriate kaupa (Window Functions)
Kasutasin DENSE_RANK() funktsiooni, et tuvastada iga kategooria 3 enim müüdud toodet.

Leid A (Maht vs Käive): Jalanõude "Moodne seemisnahkne oxfordid" müüs kõige rohkem tükke (83), kuid käibelt tegi parima tulemuse "Õhuline sünteetiline kõrge kontsaga kingad" (23 045.88 €) tänu kõrgemale hinnale.

Leid B (Hinnaklasside mõju): Laste ja naiste riiete TOP tooted müüvad stabiilselt suuri mahte (72-81 tk), kuid madalama jaehinna tõttu jääb nende kogukäive madalaks.

Leid C (Tihe konkurents): Andmetest joonistus välja väga tihe konkurents ja mitmed viigid (eriti meeste riiete ja aksessuaaride seas), mis näitab, et kindel "hitt-toode" puudub ja kliendid jagunevad võrdselt.

💡 Strateegilised soovitused
Optimeeri hinnastamist: Tõsta populaarsete, kuid odavate mahttoodete hinda või müü neid pakettidena (bundle) koos kõrgema marginaaliga aksessuaaridega.

Suuna turundusfookust: Skaleeri edu ja suuna suurem reklaamieelarve jalanõude ning meeste riiete kategooriatele, et võimendada juba praegu kõige enam tulu toovaid "staartooteid".

🧼 Teostatud töö (SQL Insights)
Analüüsi käigus rakendatud tehnilised SQL lahendused:

Agregeerimisfunktsioonid (COUNT, AVG, MIN, MAX, SUM) ja andmete grupeerimine (GROUP BY).

Grupeeritud andmete filtreerimine (HAVING).

Window Functions:

ROW_NUMBER() toodete lihtsaks järjestamiseks hinna alusel.

DENSE_RANK() edetabelite koostamiseks müügikoguste põhjal, et vältida toodete väljajäämist viikide korral.

CTE (Common Table Expressions): Kasutasin WITH klauslit, et muuta TOP 3 päring loetavamaks ja loogilisemaks.

📂 Projekti failid
©️ Roll C: Inventuur ja tooted (Inventuuri statistika)
🛠️ SQL skript | 📄 Raport | 🖼️ Tulemused: 1, 2, 3

👥 Meeskonnatöö: 🔗 [Lisa link siia]
