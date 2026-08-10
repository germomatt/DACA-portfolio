# 📊 Nädal 7 : RMF analüüs

> **👤 Tiimi liige:** GERMO MATT  
> **📋 Alaülesande kaart:** ROLL A -  Data loading

---

### 🎯 Käesoleva nädala eesmärk
Laadida, kontrollida ja ühendada UrbanStyle'i müügi- ning kliendiandmed (sales.csv ja customers.csv) ühtseks andmestikuks, et luua usaldusväärne vundament edasiseks RFM kliendisegmenteerimiseks.

---

### 🔍 Mida ma tegin & Peamised leiud
Lugesin sisse puhtad andmestikud, kus müügitabelis oli 15 234 rida ja klienditabelis 3 150 rida, ning ühendasin need edukalt `customer_id` baasil vasakpoolse liitmisega (Left Join), saades tulemuseks 19 veeruga täisväärtusliku andmestiku, mis sisaldab muuhulgas segmenteerimiseks kriitilisi `sale_date`, `total_price` ja `email` veerge.

---

### 💡 Strateegilised soovitused
Kuna andmete analüüs näitas hiljem, et VIP Champions ja Loyal Customers (kokku ~72% käibest) on ettevõtte tähtsaimad kliendid[cite: 1], soovitan luua andmebaasi automatiseeritud "Win-back" lipukese süsteemi, mis märgistab 'At Risk' (541 klienti) segmendi kasutajad juba andmete laadimise ja uuendamise faasis, võimaldades turundusmeeskonnal neile koheselt 15–20% soodustusega reageerida[cite: 1].

---

### 🧼 Teostatud töö
Laadisin algandmed, kontrollisin tabelite suurusi ja andmetüüpe (shape, dtypes), teostasin tabelite ühendamise (`pd.merge`) ja valideerisin kohustuslike veergude olemasolu, salvestades lõpptulemuse Roll B jaoks uude CSV faili.

---

### 🛠️ AI kasutamine
Kasutasin tehisintellekti abi, et lahendada algset probleemi 1 KB suuruste testfailidega ning kirjutada juhendile 100% vastav koodiplokk, mis prindib automaatselt välja andmetüübid ja veergude olemasolu roheliste linnukestega.

---

### 📂 Projekti failid ©️ Roll A

| Faili tüüp | Faili nimi kaustas | Kirjeldus |
| :--- | :--- | :--- |
| 🐍 **Python/Jupyter** | `Grupitoo_roll_A.ipynb` | Koodifail, mis sisaldab andmete laadimist, kontrolli ja liitmist (Sammud 1-6). |
| 📊 **CSV andmed** | `df_merged.csv` | Lõplik liidetud andmestik (15234 rida, 19 veergu), mis edastati Roll B-le. |
| 📊 **CSV andmed (varu)**| `df_merged_roll_A_loplik.csv` | Süsteemi poolt varasemalt loodud lõplik varukoopia. |

---

### 👥 Meeskonnatöö link - https://github.com/kolgalys-max/urbanstyle-team-3/tree/main/week-7