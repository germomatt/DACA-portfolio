# 📊 Nädal 3: SQL — UrbanStyle

## 🎯 Käesoleva nädala eesmärk
Selle nädala peamine fookus oli ettevõtte **UrbanStyle** andmebaasi analüüsimine, kasutades keerukamaid SQL-päringuid (erinevad `JOIN` tüübid, `CASE WHEN` loogika ja `DATE_TRUNC` funktsioonid). Eesmärk oli tuvastada müügilehtri kitsaskohad, kaardistada ostukäitumiseta "kadunud" kliendid, optimeerida laoseise ning analüüsida füüsiliste poodide ja online-kanali efektiivsust. Lisaks põhiülesandele (Roll B) teostasin õppimise eesmärgil ka lisarollid C ja D, et saada ärianalüüsist täielik tervikpilt.

---

## 🔍 Mida ma tegin & Peamised leiud

* **Kliendibaasi analüüs (Roll B):** Tuvastasin andmebaasist **599 "kadunud" klienti**, kes on küll registreerunud, kuid pole teinud ühtegi ostu. Geograafiliselt elab üle poole neist Tallinnas (231) ja Tartus (138). Tuvastasin ka kriitilise mustri: uute passiivsete kasutajate arv plahvatas ajavahemikus november 2024 kuni veebruar 2025, tuues lühikese ajaga sisse ligi 200 ostuta kasutajat.
* **Tooted ja inventuur (Roll C):** Analüüs näitas, et andmebaasis on **12 toodet, mida pole kunagi müüdud**. Ettevõtte peamisteks käibemootoriteks osutusid jalanõude (774 035 €) ja meeste riiete (749 799 €) kategooriad, kusjuures absoluutne müügihitt on *"Õhuline sünteetiline sporditossud"* (käive 27 347 €).
* **Müügikanalite võrdlus (Roll D):** Füüsilised kauplused on hetkel online-kanalist oluliselt edukamad, tuues sisse **1,9 miljonit eurot** (e-pood tõi 1,0 mln €). Pood on ka kliendikohta efektiivsem kanal, genereerides **835 € kliendi kohta** võrreldes e-poe 590 €-ga. Suurima kogukäibe teeb Tallinna esinduskauplus (1,09 mln €).

---

## 🧼 Teostatud töö

* **Sidumine ja filtreerimine (`LEFT JOIN` + `NULL`):** Kasutasin `LEFT JOIN` päringuid `customers` ja `products` tabelite sidumiseks `sales` tabeliga ning filtreerisin `WHERE s.sale_id IS NULL` abil välja passiivsed kliendid ja seisvad tooted.
* **Andmete grupeerimine ja ajaline analüüs:** Rakendasin `DATE_TRUNC('month', registration_date)` funktsiooni, et grupeerida passiivsete klientide registreerumisajad kuude lõikes ja tuvastada sesoonseid turundusanomaaliaid.
* **Mitme tabeli ristühendamine:** Mudeldasin 3 tabeli vahelise ühenduse (`sales` + `customers` + `products`), et näha detailset jaotust, millised tootekategooriad millistes linnades ja müügikanalites kõige paremini tulu teenivad.
* **Laoseisude kategoriseerimine:** Koostasin tingimusliku `CASE WHEN` loogika abil inventuuri aruande, mis võrdleb reaalset laoseisu (`quantity_available`) ja kriitilist piiri (`reorder_point`), märgistades tooted automaatselt staatusega `'TELLI JUURDE'` või `'OK'`.

---

## 💡 Peamised õppetunnid (SQL Insights)

* **Andmete taga on äriline reaalsus:** `LEFT JOIN` ja `IS NULL` kombinatsioon ei ole lihtsalt kood, vaid võimas tööriist seisva kapitali (müümata tooted laos) ja ebaefektiivse turunduse (kampaaniaturistid, kes ei konverteeru ostjateks) tuvastamiseks.
* **Omnichannel kanalite eripärad:** Kanalite analüüs näitas, et kuigi e-pood genereerib suurepärast mahtu, on füüsilise poe ristmüük ja kliendiväärtus (Customer Lifetime Value) oluliselt kõrgem, mis viitab vajadusele optimeerida e-poe ostukorvi suurendamise strateegiaid (nt tasuta tarne piirmäärad).

---

## 📂 Projekti failid
Kõik minu kirjutatud skriptid ja detailsemad raportid leiad siit:

* 🛠️ [week3_urbanstyle_analysis.sql](week3_urbanstyle_analysis.sql) — Minu sales, kliendibaasi ja müügikanalite SQL päringud (Rollid B, C, D)
* 📄 [week3_executive_report.md](week3_executive_report.md) — Minu detailne raporti kokkuvõte ja ärirekomenatsioonid juhtkonnale
* 👥 Meeskonnatöö 🔗 [Nädal 2 README](link-lisandub-hiljem) — Eelmise nädala meeskondlik kokkuvõte

---

### 📈 Boonus: Ärianalüüsi KPI kokkuvõte (SQL tulemitest)

| Kategooria | Indikaator / Leid | Äriline tegevusplaan (Recommendation) |
| :--- | :--- | :--- |
| **Kliendid** | 599 ostuta kasutajat (Talvine plahvatuslik kasv) | Suunatud e-maili kampaaniad esmaostu soodustusega Tallinna ja Tartu regioonile. |
| **Laoseis** | 12 täiesti müümata toodet / Laos tühjus hittidel | Seisva kapitali allahindlus; Top-toodete (nt sporditossud) kohene juurdetellimine. |