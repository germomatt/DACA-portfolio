# 📊 Nädal 2: SQL Andmepuhastus — UrbanStyle

Käesoleva nädala eesmärk oli UrbanStyle'i müügi- ja tootmisandmete analüüs ning andmekvaliteedi tagamine SQL päringute abil. Töö teostamiseks lõin andmebaasi testkoopiad `sales_test` ja `products_test`.

---

## 🔍 Mida ma tegin & Peamised leiud

Analüüsi käigus tuvastasin andmetest kokku **5500 kvaliteediprobleemi**. 

| Kategooria | Probleemide arv | Kirjeldus / Mõju ärile |
| :--- | :---: | :--- |
| **Duplikaadid** | 4013 | Korduvad `invoice_id` väärtused (asuvad 5116 duplikaatreal). Moonutavad otseselt finantsraporteid ja käivet. |
| **NULL `customer_id`** | 1487 | Puuduvad kliendiviited. Detailsem analüüs näitas, et tegu on legitiimsete külalisostudega. |
| **Toote duplikaadid** | 12 | Kattuvad tootenimed `products` tabelis, mis vajavad ühtlustamist. |

### 🧼 Teostatud andmepuhastus:
* **Eemaldasin duplikaadid:** Kasutasin `GROUP BY` ja `MIN(id)` loogikat, jättes igast arvest alles vaid esimese unikaalse rea.
* **Tulemus:** Esialgsest 15 234 reast jäi järele **10 118 korrektset ja unikaalset rida**.
* Õppe eesmärgil analüüsisin lisaks enda rollile ka tiimiliikme hallatavat `products` tabelit.

---

## 💡 Peamised õppetunnid (SQL Insights)

> [!TIP]
> **Kuldreegel:** Andmepuhastust alusta alati duplikaatidest. Nende eemaldamine vähendab sageli automaatselt ka teiste vigade (nt NULL-väärtuste) hulka.

* **Duplikaatide tuvastamine:** Õppisin, et duplikaatide leidmiseks ei piisa `IS NULL` kontrollist. Kasutama peab `GROUP BY` ja `HAVING COUNT(*) > 1` süntaksit:
  ```sql
  SELECT invoice_id, COUNT(*) 
  FROM sales_test 
  GROUP BY invoice_id 
  HAVING COUNT(*) > 1;
Äriloogika mõistmine: Iga NULL ei ole andmeviga. Puuduv customer_id tähistas meie süsteemis külalisoste (pärast duplikaatide puhastamist jäi neid süsteemi alles täpselt 988).

📂 Projekti failid
Kõik minu kirjutatud skriptid ja detailsemad raportid leiad siit:

🛠️ `week2_sales_cleaning.sql` -- minu sales SQL päringud

🛠️ `week2_products_cleaning.sql` -- minu products SQL päringud

📄 `week2_sales_report.md`    -- minu puhastusraporti kokkuvõte

📄 `week2_products_report.md`    -- minu puhastusraporti kokkuvõte


👥 Meeskonnatöö
🔗 (https://github.com/kolgalys-max/urbanstyle-team-3/blob/main/week-2/README.md) - Nädal 2 README
