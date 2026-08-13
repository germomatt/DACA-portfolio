# Roll B: Andmete transformatsioon ja agregeerimine

## Ülevaade
Minu ülesandeks tiimitöös oli **Roll B** – andmete puhastamise, transformatsiooni ja agregeerimise mooduli loomine. Töö tulemusena valmis modulaarne Pythoni skript `transform.py` ning seda verifitseeriv ja tulemusi esitlev Jupyter Notebook `week8RollB.ipynb`.

---

## 1. Modulaarne kood: `transform.py`

Failis `transform.py` on välja töötatud neli eraldiseisvat ja taaskasutatavat funktsiooni, mis tagavad andmete puhtuse ning valmistavad need ette visualiseerimiseks (Roll C) ja automatiseeritud andmetorustikuks (Roll D):

* **`clean_data(df)`**
  * Eemaldab andmestikust duplikaadid (`drop_duplicates()`).
  * Teisendab kuupäevaveeru (`sale_date`) `datetime` formaati ajapõhisteks teheteks ja agregeerimiseks.
  * Käsitleb puuduvad väärtused (eemaldab read, kus kriitilised väljad nagu tehingusumma puuduvad).
* **`calculate_weekly_aggregates(df)`**
  * Grupeerib müügitehingud nädalate kaupa (`resample('W')` kuupäeva alusel).
  * Arvutab iga nädala kohta koondmõõdikud: kogukäibe (`revenue`), tellimuste arvu (`order_count`) ja keskmise ostukorvi väärtuse (`avg_order_value`).
* **`calculate_kpis(df)`**
  * Arvutab kogu perioodi peamised tulemusmõõdikud ja tagastab need `dict` andmetüübina.
  * Tagastatavad KPI-d: kogutulu (`total_revenue`), unikaalsete klientide arv (`unique_customers`) ja keskmine ostusumma (`avg_order_value`.
* **`merge_datasets(df_sales, df_customers)`**
  * Teostab kahe andmestiku liitmise (`inner join`) ühise võtme `customer_id` alusel, sidudes igale müügireale kliendi nime ja linna.

> **Arhitektuuriline lahendus:** Faili lõppu on lisatud `if __name__ == "__main__":` plokk, mis võimaldab moodulit lokaalselt testida näidisandmetega, tagades samal ajal, et funktsioonide importimisel teistesse skriptidesse testkoodi ei käivitata[cite: 1].

---

## 2. Verifitseerimine: `week8RollB.ipynb`

Funktsioonide töökindluse tõestamiseks ja tulemuste visuaalseks kontrolliks loodi märkmik `week8RollB.ipynb`:
* Funktsioonid imporditi otse moodulist `transform.py`.
* Testiti funktsioonide käitumist näidisandmetega (sh duplikaatide eemaldamist ja andmetüüpide teisendust).
* Kontrolliti nädalakoondite ja KPI arvutuste matemaatilist täpsust.
* Kuvati visuaalselt liidestatud kliendi- ja müügiandmete lõpptabel.

---

## Tulemus ja üleandmine
Moodul `transform.py` on valmis, testitud ja vastab nõuetele, olles valmis integreerimiseks **Roll C** (visualiseerimine) ja **Roll D** (pipeline'i orkestreerimine) etappidesse.
