-- =============================================================================
-- UrbanStyle.ltd - Andmebaasi Skeem (Database Schema)
-- DACA (Andmeanalüütiku Karjäärikiirendi) programm
-- Genereeritud: 2026-03-09
-- Versioon: 1.0
-- =============================================================================
--
-- Tabelid (8):
--   1. products      (~350 rida)   - Toodete kataloog
--   2. customers     (~3,000 rida) - Klientide register
--   3. sales         (~10,118 rida)- Müügitehingud
--   4. web_logs      (~50,000 rida)- Veebikülastused
--   5. inventory     (~1,400 rida) - Laoseis
--   6. inventory_movements (~8,000 rida) - Laokanded (BONUS)
--   7. suppliers     (~15 rida)    - Tarnijad (BONUS)
--   8. promotions    (~120 rida)   - Kampaaniad (BONUS)
--
-- Ärireeglid:
--   - UrbanStyle.ltd: Eesti moebränd, asutatud 2020
--   - Asukohad: Tallinn (HQ), Tartu, Pärnu + veebipood
--   - Ajavahemik: 2023-01 kuni 2025-02
--   - Käive: ~3M€ (2024), kasv ~150%
-- =============================================================================

-- ============================================
-- TABELITE KUSTUTAMINE (Drop Existing Tables)
-- ============================================
-- CASCADE tagab, et sõltuvad foreign key viited eemaldatakse
DROP TABLE IF EXISTS promotions CASCADE;
DROP TABLE IF EXISTS inventory_movements CASCADE;
DROP TABLE IF EXISTS inventory CASCADE;
DROP TABLE IF EXISTS web_logs CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS suppliers CASCADE;

-- ============================================
-- TABELITE LOOMINE (Table Creation)
-- ============================================
-- ---------------------------------------------------------
-- 1. TARNIJAD (Suppliers) — BONUS tabel
-- ---------------------------------------------------------
-- Luuakse enne products-tabelit, sest products.supplier
-- viitab tarnija nimele (loogiline seos, mitte FK).
CREATE TABLE suppliers (
    supplier_id    SERIAL PRIMARY KEY,            -- Tarnija ID (automaatne)
    supplier_name  VARCHAR(200) NOT NULL,          -- Tarnija ärinimi
    contact_email  VARCHAR(200),                   -- Kontakt e-post
    country        VARCHAR(5) NOT NULL,            -- Riigikood (EE/LV/LT/FI/IT/TR)
    payment_terms_days INT NOT NULL DEFAULT 30,    -- Maksetähtaeg päevades
    lead_time_days     INT NOT NULL DEFAULT 14,    -- Tarneaeg päevades
    reliability_score  DECIMAL(3,2)                -- Usaldusväärsuse skoor (0.00-1.00)
        CHECK (reliability_score BETWEEN 0 AND 1)
);
COMMENT ON TABLE suppliers IS 'UrbanStyle.ltd tarnijad (~15 tarnijat Eestist, Baltimaadest, Soomest, Itaaliast, Türgist). BONUS tabel — saadaval alates Nädalast 4.';
COMMENT ON COLUMN suppliers.supplier_id IS 'Tarnija unikaalne ID (automaatne)';
COMMENT ON COLUMN suppliers.supplier_name IS 'Tarnija ärinimi';
COMMENT ON COLUMN suppliers.contact_email IS 'Tarnija kontakt e-posti aadress';
COMMENT ON COLUMN suppliers.country IS 'Riigikood (ISO 3166-1 alpha-2): EE, LV, LT, FI, IT, TR';
COMMENT ON COLUMN suppliers.payment_terms_days IS 'Maksetähtaeg päevades (vaikimisi 30)';
COMMENT ON COLUMN suppliers.lead_time_days IS 'Tarneaeg päevades (vaikimisi 14)';
COMMENT ON COLUMN suppliers.reliability_score IS 'Usaldusväärsuse skoor vahemikus 0.00 kuni 1.00';

-- ---------------------------------------------------------
-- 2. TOOTED (Products)
-- ---------------------------------------------------------
CREATE TABLE products (
    product_id    INTEGER PRIMARY KEY,             -- Toote ID (1001-1350)
    product_name  VARCHAR(200) NOT NULL,           -- Toote nimetus
    category      VARCHAR(50) NOT NULL,            -- Kategooria
    subcategory   VARCHAR(50) NOT NULL,            -- Alamkategooria
    supplier      VARCHAR(200),                    -- Tarnija nimi (viitab suppliers.supplier_name)
    cost_price    DECIMAL(10,2) NOT NULL,          -- Omahind (EUR)
    retail_price  DECIMAL(10,2) NOT NULL,          -- Jaehind (EUR)
    eco_certified BOOLEAN,                         -- Ökomärgis (TRUE/FALSE/NULL)
    created_at    DATE NOT NULL                    -- Toote lisamise kuupäev
);
COMMENT ON TABLE products IS 'UrbanStyle.ltd toodete kataloog (~350 toodet). Kategooriad: naiste_riided, meeste_riided, aksessuaarid, jalanõusid, laste_riided.';
COMMENT ON COLUMN products.product_id IS 'Toote unikaalne ID vahemikus 1001-1350';
COMMENT ON COLUMN products.product_name IS 'Toote nimetus (nt "Villane mantel", "Linane kleit")';
COMMENT ON COLUMN products.category IS 'Kategooria: naiste_riided, meeste_riided, aksessuaarid, jalanõusid, laste_riided';
COMMENT ON COLUMN products.subcategory IS 'Alamkategooria (nt kleidid, mantlid, seelikud, püksid)';
COMMENT ON COLUMN products.supplier IS 'Tarnija nimi — loogiline seos tarnijate tabeliga';
COMMENT ON COLUMN products.cost_price IS 'Omahind eurodes (hankehind tarnijalt)';
COMMENT ON COLUMN products.retail_price IS 'Jaehind eurodes (müügihind kliendile)';
COMMENT ON COLUMN products.eco_certified IS 'Kas toode on ökomärgisega (TRUE/FALSE/NULL kui teadmata)';
COMMENT ON COLUMN products.created_at IS 'Toote lisamise kuupäev kataloogi';

-- ---------------------------------------------------------
-- 3. KLIENDID (Customers)
-- ---------------------------------------------------------
CREATE TABLE customers (
    customer_id       INTEGER PRIMARY KEY,          -- Kliendi ID (2001-5000)
    first_name        VARCHAR(50) NOT NULL,         -- Eesnimi
    last_name         VARCHAR(50) NOT NULL,         -- Perekonnanimi
    email             VARCHAR(200),                 -- E-posti aadress (võib olla NULL)
    phone             VARCHAR(20),                  -- Telefoninumber
    city              VARCHAR(50),                  -- Linn
    registration_date DATE NOT NULL,                -- Registreerimise kuupäev
    loyalty_tier      VARCHAR(10),                  -- Lojaalsustase: bronze/silver/gold/NULL
    birth_year        INT                           -- Sünniaasta
        CHECK (birth_year BETWEEN 1940 AND 2010)
);
COMMENT ON TABLE customers IS 'UrbanStyle.ltd klientide register (~3,000 klienti). NB! Osalejate versioonis on ~150 duplikaatklienti ja 12% NULL email.';
COMMENT ON COLUMN customers.customer_id IS 'Kliendi unikaalne ID vahemikus 2001-5000';
COMMENT ON COLUMN customers.first_name IS 'Kliendi eesnimi';
COMMENT ON COLUMN customers.last_name IS 'Kliendi perekonnanimi';
COMMENT ON COLUMN customers.email IS 'E-posti aadress — osalejate versioonis 12% on NULL';
COMMENT ON COLUMN customers.phone IS 'Telefoninumber (Eesti formaat)';
COMMENT ON COLUMN customers.city IS 'Kliendi linn — NB! Osalejate versioonis ebaühtlane kirjaviis';
COMMENT ON COLUMN customers.registration_date IS 'Kliendiks registreerimise kuupäev';
COMMENT ON COLUMN customers.loyalty_tier IS 'Lojaalsustase: bronze, silver, gold, või NULL (40% on NULL)';
COMMENT ON COLUMN customers.birth_year IS 'Kliendi sünniaasta (1940-2010)';

-- ---------------------------------------------------------
-- 4. MÜÜGID (Sales)
-- ---------------------------------------------------------
CREATE TABLE sales (
    id             SERIAL PRIMARY KEY,              -- Rea unikaalne ID (automaatne, Supabase'i jaoks)
    sale_id        INT NOT NULL,                    -- Müügi ID (CSV-st — NB: EI OLE unikaalne!)
    invoice_id     VARCHAR(20) NOT NULL,            -- Arve number
    sale_date      TIMESTAMP NOT NULL,              -- Müügikuupäev ja -aeg
    customer_id    INT                              -- Kliendi ID (NULL = külalisost)
        REFERENCES customers(customer_id),
    product_id     INT NOT NULL                     -- Toote ID
        REFERENCES products(product_id),
    quantity       INT NOT NULL                     -- Kogus
        CHECK (quantity > 0),
    unit_price     DECIMAL(10,2) NOT NULL,          -- Ühikuhind (EUR)
    total_price    DECIMAL(10,2) NOT NULL,          -- Kogusumma (EUR)
    channel        VARCHAR(10) NOT NULL,            -- Müügikanal: 'online' / 'pood'
    store_location VARCHAR(20),                     -- Poe asukoht: Tallinn/Tartu/Pärnu/NULL
    payment_method VARCHAR(20) NOT NULL             -- Makseviis: kaart/sularaha/järelmaks
);
COMMENT ON TABLE sales IS 'UrbanStyle.ltd müügitehingud (~10,118 puhast rida). Ajavahemik: 2023-01 kuni 2025-02. NB! Osalejate raw-versioonis on 15,234 rida (sisaldab 5,116 duplikaati). sale_id EI OLE unikaalne — duplikaatide avastamine on Nädal 2 ülesanne.';
COMMENT ON COLUMN sales.id IS 'Rea unikaalne ID (automaatne, Supabase Table Editor''i jaoks)';
COMMENT ON COLUMN sales.sale_id IS 'Müügi ID CSV-st — NB: EI OLE unikaalne! Sisaldab 5,116 duplikaati osalejate versioonis.';
COMMENT ON COLUMN sales.invoice_id IS 'Arve number (nt INV-2024-001234). Unikaalne puhtas versioonis, kordub osalejate versioonis.';
COMMENT ON COLUMN sales.sale_date IS 'Müügikuupäev ja -aeg. NB! Osalejate versioonis ~3% on tekstiformaadis ("15/03/2024") ja 50 tuleviku kuupäeva.';
COMMENT ON COLUMN sales.customer_id IS 'Kliendi ID — viitab customers tabelile. NULL tähendab külalisostjat (~5%).';
COMMENT ON COLUMN sales.product_id IS 'Toote ID — viitab products tabelile';
COMMENT ON COLUMN sales.quantity IS 'Ostetud ühikute arv (peab olema > 0)';
COMMENT ON COLUMN sales.unit_price IS 'Ühikuhind eurodes. NB! Osalejate versioonis ~3% ei ühti toote jaehinnaga.';
COMMENT ON COLUMN sales.total_price IS 'Kogusumma eurodes. NB! Osalejate versioonis ~2% on negatiivsed (tagastused).';
COMMENT ON COLUMN sales.channel IS 'Müügikanal: ''online'' (veebipood) või ''pood'' (füüsiline kauplus)';
COMMENT ON COLUMN sales.store_location IS 'Poe asukoht: Tallinn, Tartu, Pärnu. NULL online-ostude puhul.';
COMMENT ON COLUMN sales.payment_method IS 'Makseviis: kaart, sularaha, või järelmaks';

-- ---------------------------------------------------------
-- 5. VEEBIKÜLASTUSED (Web Logs)
-- ---------------------------------------------------------
CREATE TABLE web_logs (
    log_id           SERIAL PRIMARY KEY,            -- Logi ID (automaatne)
    session_id       VARCHAR(40) NOT NULL,          -- Sessiooni tunnus
    customer_id      INT                            -- Kliendi ID (NULL = anonüümne)
        REFERENCES customers(customer_id),
    visit_date       TIMESTAMP NOT NULL,            -- Külastuse kuupäev ja aeg
    page_viewed      VARCHAR(100) NOT NULL,         -- Vaadatud leht
    device_type      VARCHAR(10) NOT NULL,          -- Seadme tüüp: desktop/mobile/tablet
    duration_seconds INT NOT NULL DEFAULT 0,        -- Lehe vaatamise kestus sekundites
    source           VARCHAR(50),                   -- Turunduskanal (google/facebook/direct/email)
    country          VARCHAR(5) DEFAULT 'EE'        -- Riigikood (vaikimisi EE)
);
COMMENT ON TABLE web_logs IS 'UrbanStyle.ltd veebipoe külastuslogid (~50,000 rida). Anonüümsed külastajad on customer_id = NULL.';
COMMENT ON COLUMN web_logs.log_id IS 'Logi unikaalne ID (automaatne)';
COMMENT ON COLUMN web_logs.session_id IS 'Sessiooni tunnus — üks külastuskord';
COMMENT ON COLUMN web_logs.customer_id IS 'Kliendi ID — NULL anonüümsete külastajate jaoks';
COMMENT ON COLUMN web_logs.visit_date IS 'Külastuse kuupäev ja kellaaeg';
COMMENT ON COLUMN web_logs.page_viewed IS 'Vaadatud veebilehe URL tee (nt /tooted/kleidid, /ostukorv)';
COMMENT ON COLUMN web_logs.device_type IS 'Seadme tüüp: desktop, mobile, tablet';
COMMENT ON COLUMN web_logs.duration_seconds IS 'Lehe vaatamise kestus sekundites (0 = bounce)';
COMMENT ON COLUMN web_logs.source IS 'Turunduskanal: google, facebook, instagram, direct, email, referral';
COMMENT ON COLUMN web_logs.country IS 'Külastaja riigikood (ISO 3166-1 alpha-2, vaikimisi EE)';

-- ---------------------------------------------------------
-- 6. LAOSEIS (Inventory)
-- ---------------------------------------------------------
CREATE TABLE inventory (
    inventory_id       SERIAL PRIMARY KEY,          -- Laokirje ID (automaatne)
    product_id         INT NOT NULL                 -- Toote ID
        REFERENCES products(product_id),
    location           VARCHAR(20) NOT NULL,        -- Asukoht: tallinn/tartu/pärnu/ladu
    quantity_available INT NOT NULL DEFAULT 0,      -- Saadaolev kogus
    reorder_point      INT NOT NULL DEFAULT 20,     -- Täiendamise piir
    last_updated       TIMESTAMP NOT NULL,          -- Viimase uuenduse aeg
    UNIQUE(product_id, location)                    -- Üks kirje toote + asukoha kohta
);
COMMENT ON TABLE inventory IS 'UrbanStyle.ltd laoseis (~1,400 rida = ~350 toodet x 4 asukohta). NB! Osalejate versioonis võib olla aegunud ja negatiivseid väärtusi.';
COMMENT ON COLUMN inventory.inventory_id IS 'Laokirje unikaalne ID (automaatne)';
COMMENT ON COLUMN inventory.product_id IS 'Toote ID — viitab products tabelile';
COMMENT ON COLUMN inventory.location IS 'Laoasukoht: tallinn, tartu, pärnu, ladu (keskne laokompleks)';
COMMENT ON COLUMN inventory.quantity_available IS 'Saadaolev kogus (peaks olema >= 0, osalejate versioonis võib olla negatiivne)';
COMMENT ON COLUMN inventory.reorder_point IS 'Täiendamise piir — kui jääk langeb alla selle, tuleb tellida (vaikimisi 20)';
COMMENT ON COLUMN inventory.last_updated IS 'Viimase uuenduse kuupäev ja kellaaeg';

-- ---------------------------------------------------------
-- 7. LAOKANDED (Inventory Movements) — BONUS tabel
-- ---------------------------------------------------------
CREATE TABLE inventory_movements (
    movement_id   SERIAL PRIMARY KEY,               -- Laokande ID (automaatne)
    product_id    INT NOT NULL                      -- Toote ID
        REFERENCES products(product_id),
    location      VARCHAR(20) NOT NULL,             -- Asukoht
    movement_type VARCHAR(15) NOT NULL,             -- Kande tüüp: IN/OUT/TRANSFER/ADJUSTMENT
    quantity      INT NOT NULL,                     -- Kogus (positiivne)
    timestamp     TIMESTAMP NOT NULL,               -- Kande aeg
    reference     VARCHAR(50)                       -- Viide (nt arve nr, ülekandenumber)
);
COMMENT ON TABLE inventory_movements IS 'UrbanStyle.ltd laokanded (~8,000 kannet). BONUS tabel — laohalduse auditi jaoks (Nädal 4+).';
COMMENT ON COLUMN inventory_movements.movement_id IS 'Laokande unikaalne ID (automaatne)';
COMMENT ON COLUMN inventory_movements.product_id IS 'Toote ID — viitab products tabelile';
COMMENT ON COLUMN inventory_movements.location IS 'Kande asukoht: tallinn, tartu, pärnu, ladu';
COMMENT ON COLUMN inventory_movements.movement_type IS 'Kande tüüp: IN (sissetulek), OUT (väljaminek), TRANSFER (üleviimine), ADJUSTMENT (korrigeerimine)';
COMMENT ON COLUMN inventory_movements.quantity IS 'Kogus (alati positiivne, suund tuleneb movement_type-st)';
COMMENT ON COLUMN inventory_movements.timestamp IS 'Laokande kuupäev ja kellaaeg';
COMMENT ON COLUMN inventory_movements.reference IS 'Viidete väli: arve number, ülekandenumber, inventuuri akt jne';

-- ---------------------------------------------------------
-- 8. KAMPAANIAD (Promotions) — BONUS tabel
-- ---------------------------------------------------------
CREATE TABLE promotions (
    promo_id         SERIAL PRIMARY KEY,            -- Kampaania ID (automaatne)
    promo_name       VARCHAR(200) NOT NULL,         -- Kampaania nimetus
    product_id       INT                            -- Toote ID (NULL = kogu sortiment)
        REFERENCES products(product_id),
    category         VARCHAR(50),                   -- Sihtkategooria (NULL = kõik)
    discount_percent INT NOT NULL                   -- Allahindluse protsent (1-100)
        CHECK (discount_percent BETWEEN 1 AND 100),
    start_date       DATE NOT NULL,                 -- Alguskuupäev
    end_date         DATE NOT NULL,                 -- Lõppkuupäev
    channel          VARCHAR(10),                   -- Kanal: online/pood/both (NULL = mõlemad)
    CHECK (end_date >= start_date)                  -- Lõpp ei saa olla enne algust
);
COMMENT ON TABLE promotions IS 'UrbanStyle.ltd kampaaniad (~120 kampaaniat). BONUS tabel — kampaaniate ROI analüüsi jaoks (Nädal 4+).';
COMMENT ON COLUMN promotions.promo_id IS 'Kampaania unikaalne ID (automaatne)';
COMMENT ON COLUMN promotions.promo_name IS 'Kampaania nimetus (nt "Suvine allahindlus 2024", "Must Reede")';
COMMENT ON COLUMN promotions.product_id IS 'Konkreetse toote ID — NULL tähendab kogu sortimenti';
COMMENT ON COLUMN promotions.category IS 'Sihtkategooria — NULL tähendab kõiki kategooriaid';
COMMENT ON COLUMN promotions.discount_percent IS 'Allahindluse protsent (1-100)';
COMMENT ON COLUMN promotions.start_date IS 'Kampaania alguskuupäev';
COMMENT ON COLUMN promotions.end_date IS 'Kampaania lõppkuupäev (peab olema >= start_date)';
COMMENT ON COLUMN promotions.channel IS 'Müügikanal: online, pood, both. NULL = mõlemad.';

-- ============================================
-- INDEKSID (Performance Indexes)
-- ============================================
-- Müügitabeli indeksid (kõige sagedasemad päringud)
CREATE INDEX idx_sales_date       ON sales(sale_date);
CREATE INDEX idx_sales_customer   ON sales(customer_id);
CREATE INDEX idx_sales_product    ON sales(product_id);
CREATE INDEX idx_sales_invoice    ON sales(invoice_id);
CREATE INDEX idx_sales_channel    ON sales(channel);
-- Veebikülastuste indeksid
CREATE INDEX idx_web_logs_customer ON web_logs(customer_id);
CREATE INDEX idx_web_logs_date     ON web_logs(visit_date);
CREATE INDEX idx_web_logs_session  ON web_logs(session_id);
-- Laoseisu indeksid
CREATE INDEX idx_inventory_product ON inventory(product_id);
CREATE INDEX idx_inventory_location ON inventory(location);
-- Laokannete indeksid
CREATE INDEX idx_inventory_movements_product   ON inventory_movements(product_id);
CREATE INDEX idx_inventory_movements_timestamp  ON inventory_movements(timestamp);
CREATE INDEX idx_inventory_movements_type       ON inventory_movements(movement_type);
-- Kampaaniate indeksid
CREATE INDEX idx_promotions_dates    ON promotions(start_date, end_date);
CREATE INDEX idx_promotions_product  ON promotions(product_id);
CREATE INDEX idx_promotions_category ON promotions(category);

-- ============================================
-- ANDMETE LAADIMINE (Data Loading)
-- ============================================
-- Kasuta COPY käske andmete laadimiseks CSV failidest.
-- Asenda '/path/to/' tegeliku kaustateega.
--
-- NB! COPY nõuab superuser/admin õigusi.
-- Alternatiiv: kasuta \copy (psql klient-käsk) või Supabase Table Editor import.
-- ---------------------------------------------------------
-- Variant A: Puhtad andmed (mentori versioon)
-- ---------------------------------------------------------
-- Need on vigadeta andmed, mida mentor kasutab vastuste kontrollimiseks.
-- \copy suppliers      FROM '/path/to/datasets/clean/bonus/urbanstyle_suppliers.csv'             CSV HEADER;
-- \copy products       FROM '/path/to/datasets/clean/urbanstyle_products.csv'                    CSV HEADER;
-- \copy customers      FROM '/path/to/datasets/clean/urbanstyle_customers.csv'                   CSV HEADER;
-- \copy sales          FROM '/path/to/datasets/clean/urbanstyle_sales.csv'                       CSV HEADER;
-- \copy web_logs       FROM '/path/to/datasets/clean/urbanstyle_web_logs.csv'                    CSV HEADER;
-- \copy inventory      FROM '/path/to/datasets/clean/urbanstyle_inventory.csv'                   CSV HEADER;
-- \copy inventory_movements FROM '/path/to/datasets/clean/bonus/urbanstyle_inventory_movements.csv' CSV HEADER;
-- \copy promotions     FROM '/path/to/datasets/clean/bonus/urbanstyle_promotions.csv'            CSV HEADER;
-- ---------------------------------------------------------
-- Variant B: Osalejate andmed (vigadega versioon)
-- ---------------------------------------------------------
-- Need on tahtlikult "rikutud" andmed, millega osalejad harjutavad andmepuhastust.
-- \copy suppliers      FROM '/path/to/datasets/participant/bonus/urbanstyle_suppliers.csv'                CSV HEADER;
-- \copy products       FROM '/path/to/datasets/participant/urbanstyle_products_raw.csv'                   CSV HEADER;
-- \copy customers      FROM '/path/to/datasets/participant/urbanstyle_customers_raw.csv'                  CSV HEADER;
-- \copy sales          FROM '/path/to/datasets/participant/urbanstyle_sales_raw.csv'                      CSV HEADER;
-- \copy web_logs       FROM '/path/to/datasets/participant/urbanstyle_web_logs_raw.csv'                   CSV HEADER;
-- \copy inventory      FROM '/path/to/datasets/participant/urbanstyle_inventory_raw.csv'                  CSV HEADER;
-- \copy inventory_movements FROM '/path/to/datasets/participant/bonus/urbanstyle_inventory_movements.csv' CSV HEADER;
-- \copy promotions     FROM '/path/to/datasets/participant/bonus/urbanstyle_promotions.csv'               CSV HEADER;

-- ============================================
-- SUPABASE IMPORT (Nädal 8: API pipeline)
-- ============================================
-- Supabase kasutab PostgreSQL-i, seega saab sama skeemi kasutada.
--
-- Variant 1: SQL Editor
--   1. Ava Supabase Dashboard -> SQL Editor
--   2. Kopeeri ja käivita see fail (kogu sisu)
--   3. Laadi CSV-d Table Editor kaudu (Table Editor -> Import CSV)
--   4. Kontrolli, et column types ühtivad skeemiga
--
-- Variant 2: CLI (kui kasutad Supabase CLI-d)
--   supabase db push
--   (eeldab, et skeem on migrations kaustas)
--
-- Variant 3: CSV import (kõige lihtsam)
--   1. Supabase Dashboard -> Table Editor
--   2. Vali tabel -> Import CSV
--   3. Laadi sobiv CSV fail
--   NB! Kontrolli, et:
--     - Veerunimed ühtivad skeemiga
--     - Andmetüübid ühtivad (eriti TIMESTAMP ja DECIMAL)
--     - SERIAL veerud (PK) genereeritakse automaatselt
--
-- Variant 4: Supabase JavaScript SDK (Nädal 8 harjutus)
--   const { data, error } = await supabase
--     .from('sales')
--     .insert(csvRows);
--
-- Pärast importi kontrolli ridade arve:
--   SELECT 'products' AS tabel, COUNT(*) AS ridu FROM products
--   UNION ALL SELECT 'customers', COUNT(*) FROM customers
--   UNION ALL SELECT 'sales', COUNT(*) FROM sales
--   UNION ALL SELECT 'web_logs', COUNT(*) FROM web_logs
--   UNION ALL SELECT 'inventory', COUNT(*) FROM inventory
--   UNION ALL SELECT 'inventory_movements', COUNT(*) FROM inventory_movements
--   UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
--   UNION ALL SELECT 'promotions', COUNT(*) FROM promotions;

-- ============================================
-- SKEEMI VALIDEERIMINE (Schema Validation)
-- ============================================
-- Käivita pärast tabelite loomist, et kontrollida struktuuri.
-- SELECT table_name, column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_schema = 'public'
--   AND table_name IN ('products','customers','sales','web_logs',
--                      'inventory','inventory_movements','suppliers','promotions')
-- ORDER BY table_name, ordinal_position;
 SELECT COUNT(*) FROM products;

 -- sales tabeli tegemine

 CREATE TABLE sales_import (
  sale_id TEXT, invoice_id TEXT, sale_date TEXT, customer_id TEXT,
  product_id TEXT, quantity TEXT, unit_price TEXT, total_price TEXT,
  channel TEXT, store_location TEXT, payment_method TEXT
);

SELECT COUNT(*) FROM sales_import;

INSERT INTO sales (
  sale_id, invoice_id, sale_date, customer_id, product_id,
  quantity, unit_price, total_price, channel, store_location, payment_method
)
SELECT
  sale_id::INT, invoice_id,
  CASE
    WHEN sale_date ~ '^\d{4}-\d{2}-\d{2}' THEN sale_date::DATE
    WHEN sale_date ~ '^\d{2}/\d{2}/\d{4}' THEN TO_DATE(sale_date, 'DD/MM/YYYY')
    ELSE NULL
  END,
  customer_id::INT, product_id::INT, quantity::INT,
  unit_price::NUMERIC, total_price::NUMERIC,
  channel, NULLIF(store_location, ''), payment_method
FROM sales_import;



SELECT COUNT(*) FROM sales;

DROP TABLE sales_import;

SELECT 'products' AS tabel, COUNT(*) AS ridu FROM products
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'sales', COUNT(*) FROM sales;

-- Alustan ülesannet
SELECT *
FROM sales;

SELECT customer_id, total_price, sale_date
FROM sales;

SELECT
    customer_id AS klient,
    total_price AS summa,
    sale_date AS kuupäev
FROM sales;

SELECT customer_id, total_price
FROM sales
LIMIT 10;

-- Väiksemast suuremani (vaikimisi)
SELECT customer_id, total_price
FROM sales
ORDER BY total_price;
-- Suuremast väiksemani
SELECT customer_id, total_price
FROM sales
ORDER BY total_price DESC;

-- 1.3 harjutused 1A:Shu
SELECT *
FROM sales
LIMIT 5;

SELECT sale_id, customer_id, total_price, sale_date
FROM sales
LIMIT 10;

SELECT sale_id, total_price AS summa
FROM sales
ORDER BY total_price ASC
LIMIT 5;

SELECT
    customer_id AS klient,
    total_price AS summa,
    sale_date AS kuupäev
FROM sales
ORDER BY sale_date DESC
LIMIT 20;

--harjutus 2.3
SELECT sale_id, customer_id, total_price
FROM sales
WHERE total_price > 500
ORDER BY total_price DESC
LIMIT 10;

SELECT sale_id, sale_date, total_price
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-03-31'
ORDER BY sale_date;

SELECT sale_id, customer_id, total_price
FROM sales
WHERE customer_id IS NULL;

SELECT sale_id, sale_date, total_price
FROM sales
WHERE sale_date BETWEEN '2024-01-01' AND '2024-12-31' AND total_price > 200
ORDER BY total_price DESC;

SELECT sale_id, customer_id, total_price, sale_date
FROM sales
WHERE total_price <= 0 OR customer_id IS NULL
ORDER BY total_price ASC;

-- Ainult unikaalsed kanalid
SELECT DISTINCT channel
FROM sales;
-- Tulemus: 3-5 rida (nt Tallinn, Tartu, Pärnu, E-pood)

-- Mitu customer_id on NULL?
SELECT
    COUNT(*) AS kokku,
    COUNT(customer_id) AS klientidega,
    COUNT(*) - COUNT(customer_id) AS puuduvaid
FROM sales;

-- Samm A: Mitu rida kokku?
SELECT COUNT(*) FROM sales;
-- Samm B: Mitu unikaalset sale_id on?
SELECT COUNT(DISTINCT sale_id) FROM sales;
-- Kui A > B, siis on duplikaadid!

SELECT
    COUNT(*) AS ridade_arv,
    COUNT(customer_id) AS klientidega,
    COUNT(*) - COUNT(customer_id) AS puudub_klient,
    COUNT(DISTINCT customer_id) AS unikaalseid_kliente
FROM sales;

SELECT DISTINCT channel
FROM sales
ORDER BY channel;

SELECT COUNT(DISTINCT sale_id) AS unikaalseid FROM sales;

SELECT
    COUNT(*) AS kokku,
    COUNT(DISTINCT email) AS unikaalseid_emaile,
    COUNT(*) - COUNT(DISTINCT email) AS duplikaatseid
FROM customers;

SELECT
    COUNT(*) AS toodete_arv,
    COUNT(DISTINCT category) AS kategooriaid,
    COUNT(*) - COUNT(cost_price) AS puuduvaid_hindu
FROM products;

-- Küsimus: mitu duplikaati on?
SELECT
    COUNT(*) AS ridu_kokku,
    COUNT(DISTINCT sale_id) AS unikaalseid,
    COUNT(*) - COUNT(DISTINCT sale_id) AS duplikaate
FROM sales;

--..._... tellimusel puudub kliendi ID.
SELECT sale_id, customer_id, total_price
FROM sales
WHERE customer_id IS NULL;

--Mis oli Suurim müük oli ??"
SELECT sale_id AS muuk, customer_id, total_price AS summa
FROM sales
ORDER BY total_price DESC
LIMIT 10;

-- "Leian mitu tellimust on, kus summa on 0 või negatiivne."
SELECT sale_id, customer_id, total_price, sale_date
FROM sales
WHERE total_price <= 0
ORDER BY total_price ASC;

KOKKUVÕTE

--Meie tabelis on ...15234... rida, millest ...5116... on duplikaadid."
--...1487... tellimusel puudub kliendi ID.
--Suurim müük oli 2170.40 eurot."
--"Leidsime ...305... tellimust, kus summa on 0 või negatiivne."

TEADMISTE KONTROLL

1. C - õige
2. A - õige
3. D - õige
4. C - õige
5. D - vale ( õige on B)
6. pakkumine puudub - vale 
7. A - õige
8. C - õige 
9. B - õige 
10. pakkumine puudub - vale
