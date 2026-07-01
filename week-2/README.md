# Nädal 1: SQL Cleaning -- UrbanStyle'i andmete uurimine

## Mida ma tegin
1. Uurisin **`sales`** (ja loodud testkoopiat **`sales_test`**) tabelit SQL päringutega.
2. Leidsin kokku **5500 andmekvaliteedi probleemi**. Peamine leid oli **4013 duplikaatarvet** (`invoice_id`), mis moonutasid otseselt finantsnäitajaid, ning **1487 puuduvat kliendiviidet** (NULL `customer_id`), mis edasisel analüüsil osutusid külalisostudeks.
3. Osalesin meeskonna andmemaastiku koostamisel ja puhastasin andmestiku: eemaldasin duplikaadid (jättes igast arvest alles vaid esimese rea `MIN(id)` abil), mille tulemusel jäi esialgsest 15 234 reast alles **10 118 korrektset unikaalset rida**.

## Peamised õpid
4. **Õppisin õigeid SQL-i tehnikaid ja puhastusprotsessi loogikat:**
   * Duplikaatide otsimiseks ei piisa `WHERE veerg IS NULL` tingimusest (see leiab vaid tühje lahtreid), vaid kasutada tuleb `GROUP BY` ja `HAVING COUNT(*) > 1` loogikat.
   * Andmepuhastust on kõige mõistlikum alustada duplikaatide eemaldamisest, sest see säästab vaeva ja vähendab automaatselt teiste probleemide (nt NULL väärtuste) koguarvu.
   * Iga NULL väärtus ei ole ilmtingimata andmeviga. Näiteks puuduv `customer_id` esindas meie äriloogikas täiesti kehtivaid külalisoste (neid jäi pärast duplikaatide eemaldamist alles 988).

## Failid
- `week1_sales_cleaning.sql` -- minu SQL päringud
- `week1_sales_report.md`    -- minu puhastusraporti kokkuvõte

## Meeskonna töö
- [Link lisandub hiljem]