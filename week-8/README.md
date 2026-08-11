# 📊 Nädal 8 : Modulaarne andmetöötluse pipeline

> **👤 Tiimi liige:** GERMO MATT  
> **📋 Alaülesande kaart:** ROLL B — Data Transformation & Aggregation (+ Roll C verifitseerimine)

---

### 🎯 Minu roll ja alaülesande kirjeldus
Minu peamiseks ülesandeks oli luua modulaarne andmetöötluse kiht failis `transform.py`, mis võtab vastu Roll A toorandmed ning valmistab need ette visualiseerimiseks (Roll C) ja automatiseeritud torustikuks (Roll D).

Töö katab nii baasfunktsionaalsuse kui ka edasijõudnute nõuded (andmevalideerimine ja logimine):
1. **`clean_data(df)`** — eemaldab duplikaadid, teisendab kuupäevad `datetime` tüüpi, valideerib väärtuste vahemikke (eemaldab negatiivsed tehingusummad ja vigased kuupäevad).
2. **`calculate_weekly_aggregates(df)`** — valideerib veergude olemasolu ja koondab müügid nädalate kaupa (käive, tellimuste arv, keskmine ostusumma).
3. **`calculate_kpis(df)`** — arvutab ja tagastab peamised tulemusmõõdikud (`dict`: käive, unikaalsed kliendid, keskmine ost).
4. **`merge_datasets(df_sales, df_customers)`** — valideerib võtme olemasolu ja ühendab müügi- ning klienditabelid `customer_id` alusel.
5. **Logimise süsteem (`logging`)** — igale sammule on lisatud reaalajas logisõnumid (`INFO`, `WARNING`, `ERROR`), mis dokumenteerivad vigade püüdmise ja andmerea muutused.

---

### 🔍 Roll C integratsiooni testimine ja eksport
Veendumaks, et Roll B funktsioonid integreeruvad sujuvalt järgmiste etappidega, viisin läbi ka Roll C verifitseerimise failis `visualize_export.py`:
* Lõin interaktiivse nädalase tululiikumise joondiagrammi (`create_weekly_chart`) Plotly abil.
* Lõin KPI-de kokkuvõttekaardid (`create_kpi_summary`).
* Seadistasin automaatse tulemuste ekspordi (`export_results`), mis salvestab kuupäevatempliga CSV ja interaktiivsed HTML-graafikud kausta `output/`.

---

### 🤝 Meeskonna tulemuste kokkuvõte
Meeskonna eesmärk oli ehitada täisautomaatne ja modulaarne andmetöötluse ahel:
* **Roll A** tõmbab andmed andmebaasist (`data_fetcher.py`).
* **Roll B** puhastab, valideerib ja arvutab koondnäitajad (`transform.py`).
* **Roll C** koostab koondandmetest graafikud ja ekspordib (`visualize_export.py`).
* **Roll D** ühendab kõik moodulid ühtseks automaatseks torustikuks (`pipeline.py`).

---

### 🛠️ Kuidas AI aitas sel nädalal?
AI aitas struktureerida puhta modulaarse koodi koos standardse `logging` mooduli ja andmevalideerimise reeglitega failis `transform.py` ning kiirendas Plotly interaktiivsete indikaatorkaartide ja eksportimisfunktsioonide loomist failis `visualize_export.py`.

---

### 📂 Projekti failid

| Faili tüüp | Faili nimi kaustas | Kirjeldus |
| :--- | :--- | :--- |
| 🐍 **Python moodul** | `transform.py` | Modulaarne transformatsioonikiht (Roll B peamine väljund). |
| 📓 **Jupyter Notebook** | `week8RollB.ipynb` | Verifitseerimise märkmik funktsioonide testimiseks. |
| 🐍 **Python moodul** | `visualize_export.py` | Roll C visualiseerimise ja ekspordi moodul. |
| 📁 **Kaust** | `output/` | Automaatselt genereeritud CSV ja interaktiivsed HTML graafikud. |

---

### 👥 Meeskonnatöö link
* **GitHub repositoorium:** https://github.com/kolgalys-max/urbanstyle-team-3/tree/main/week-8