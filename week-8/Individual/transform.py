import logging
import pandas as pd

# 1. Seadistame logimise (kuvab aja, taseme ja sõnumi)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


# 1. Puhastamise ja valideerimise funktsioon
def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """Valideerib ja puhastab müügiandmed:

    kontrollib veerge, vahemikke, eemaldab duplikaadid ja vigased väärtused.
    """
    logger.info("--- Alustan andmete puhastamist ja valideerimist ---")

    if df is None or not isinstance(df, pd.DataFrame):
        logger.error("Sisend ei ole korrektne pandas DataFrame!")
        return pd.DataFrame()

    if df.empty:
        logger.warning("Sisend-DataFrame on tühi!")
        return pd.DataFrame()

    df_clean = df.copy()
    initial_rows = len(df_clean)

    # 1. DUPLIKAATIDE KONTROLL JA EEMALDAMINE
    df_clean = df_clean.drop_duplicates()
    duplicates_removed = initial_rows - len(df_clean)
    if duplicates_removed > 0:
        logger.info(f"Eemaldati {duplicates_removed} duplikaatrida.")

    # 2. VEERGUDE OLEMASOLU JA TÜÜPIDE KONTROLL
    if "sale_date" in df_clean.columns:
        try:
            df_clean["sale_date"] = pd.to_datetime(
                df_clean["sale_date"], errors="coerce"
            )
            # Kontrollime kehtetuid kuupäevi
            invalid_dates = df_clean["sale_date"].isna().sum()
            if invalid_dates > 0:
                logger.warning(
                    f"Leiti ja eemaldati {invalid_dates} vigast kuupäeva."
                )
                df_clean = df_clean.dropna(subset=["sale_date"])
        except Exception as e:
            logger.error(f"Viga kuupäevade teisendamisel: {e}")

    # 3. VAHEMIKE KONTROLL (Mõistlikud väärtused total_price jaoks)
    # Toetame eeskätt total_price, vajadusel total_amount
    price_col = (
        "total_price"
        if "total_price" in df_clean.columns
        else ("total_amount" if "total_amount" in df_clean.columns else None)
    )

    if price_col:
        # Tagame, et veerg on numbriline
        df_clean[price_col] = pd.to_numeric(
            df_clean[price_col], errors="coerce"
        )

        # Kontroll: tehingusumma ei tohi olla negatiivne ega NULL
        invalid_amounts = df_clean[
            df_clean[price_col].isna() | (df_clean[price_col] < 0)
        ]
        if len(invalid_amounts) > 0:
            logger.warning(
                f"Eemaldati {len(invalid_amounts)} rida vigase summaga (negatiivne või NULL)."
            )
            df_clean = df_clean[
                df_clean[price_col].notna() & (df_clean[price_col] >= 0)
            ]

    logger.info(
        f"Puhastus lõpetatud: {initial_rows} reast jäi alles {len(df_clean)} rida."
    )
    return df_clean


# 2. Nädalaste koondnäitajate arvutamine
def calculate_weekly_aggregates(df: pd.DataFrame) -> pd.DataFrame:
    """Valideerib ja grupeerib müügiandmed nädalate kaupa."""
    logger.info("--- Alustan nädalakoondite arvutamist ---")

    df_clean = clean_data(df)

    price_col = (
        "total_price"
        if "total_price" in df_clean.columns
        else ("total_amount" if "total_amount" in df_clean.columns else None)
    )

    # Valideerimine: kas vajalikud veerud on olemas?
    if not price_col or "sale_date" not in df_clean.columns:
        logger.error(
            "Puuduvad vajalikud veerud (sale_date või total_price) nädalakoondiks!"
        )
        return pd.DataFrame()

    id_col = "id" if "id" in df_clean.columns else df_clean.columns[0]

    weekly = (
        df_clean.set_index("sale_date")
        .resample("W")
        .agg(
            revenue=(price_col, "sum"),
            order_count=(id_col, "count"),
            avg_order_value=(price_col, "mean"),
        )
        .reset_index()
    )

    # Täidame tühjad nädalad 0-ga
    weekly["revenue"] = weekly["revenue"].fillna(0)
    weekly["order_count"] = weekly["order_count"].fillna(0)
    weekly["avg_order_value"] = weekly["avg_order_value"].fillna(0)

    logger.info(f"Nädalakoond edukalt loodud ({len(weekly)} nädalat).")
    return weekly


# 3. KPI-de arvutamine
def calculate_kpis(df: pd.DataFrame) -> dict:
    """Arvutab peamised tulemusmõõdikud ja valideerib tulemused."""
    logger.info("--- Alustan KPI-de arvutamist ---")

    df_clean = clean_data(df)

    if df_clean.empty:
        logger.warning("Andmestik on tühi, tagastan null-KPI-d.")
        return {
            "total_revenue": 0.0,
            "unique_customers": 0,
            "avg_order_value": 0.0,
        }

    price_col = (
        "total_price"
        if "total_price" in df_clean.columns
        else ("total_amount" if "total_amount" in df_clean.columns else None)
    )
    total_revenue = (
        float(df_clean[price_col].sum())
        if price_col and price_col in df_clean.columns
        else 0.0
    )
    unique_customers = (
        int(df_clean["customer_id"].nunique())
        if "customer_id" in df_clean.columns
        else 0
    )
    avg_order_value = (
        float(df_clean[price_col].mean())
        if price_col and len(df_clean) > 0
        else 0.0
    )

    kpis = {
        "total_revenue": round(total_revenue, 2),
        "unique_customers": unique_customers,
        "avg_order_value": round(avg_order_value, 2),
    }

    if kpis["total_revenue"] < 0:
        logger.warning("Hoiatus: Kogukäive arvutati negatiivsena!")

    logger.info(f"KPI-d edukalt arvutatud: {kpis}")
    return kpis


# 4. Andmestike liitmine
def merge_datasets(
    df_sales: pd.DataFrame, df_customers: pd.DataFrame
) -> pd.DataFrame:
    """Valideerib ja liidab müügi- ning kliendiandmed customer_id järgi."""
    logger.info("--- Alustan andmestike liitmist (merge) ---")

    if (
        df_sales is None
        or df_customers is None
        or df_sales.empty
        or df_customers.empty
    ):
        logger.error("Üks liidetavatest tabelitest on tühi või puudu!")
        return pd.DataFrame()

    df_sales_clean = clean_data(df_sales)
    df_customers_clean = df_customers.drop_duplicates()

    # Valideerimine: kontrollime ühise võtme olemasolu
    if (
        "customer_id" not in df_sales_clean.columns
        or "customer_id" not in df_customers_clean.columns
    ):
        logger.error("Veerg 'customer_id' puudub ühest tabelitest!")
        return pd.DataFrame()

    merged_df = pd.merge(
        df_sales_clean,
        df_customers_clean,
        on="customer_id",
        how="inner",
        suffixes=("_sale", "_customer"),
    )

    logger.info(
        f"Liitmine edukas: {len(df_sales_clean)} müügireast tekkis {len(merged_df)} seotud rida."
    )
    return merged_df


# --- TESTIMISALA ---
if __name__ == "__main__":
    logger.info("=== KÄIVITAN ROLL B TÄIELIKU TESTI KOOS VALIDEERIMISEGA ===")

    # Testandmed kasutavad nüüd õiget veergu 'total_price':
    mock_sales = pd.DataFrame(
        {
            "id": [1, 2, 3, 4, 4, 5, 6],
            "customer_id": [101, 102, 101, 103, 103, 104, 105],
            "sale_date": [
                "2026-03-01",
                "2026-03-03",
                "2026-03-10",
                "2026-03-12",
                "2026-03-12",
                "2026-03-15",
                "vigane-kp",
            ],
            "total_price": [50.0, 120.0, 30.0, 80.0, 80.0, -50.0, 100.0],
        }
    )

    mock_customers = pd.DataFrame(
        {
            "customer_id": [101, 102, 103],
            "name": ["Mari Maasikas", "Jüri Tamm", "Kati Kask"],
            "city": ["Tallinn", "Tartu", "Pärnu"],
        }
    )

    # Testime funktsioone
    df_clean = clean_data(mock_sales)
    df_weekly = calculate_weekly_aggregates(mock_sales)
    kpi_dict = calculate_kpis(mock_sales)
    df_merged = merge_datasets(mock_sales, mock_customers)

    print("\n--- 1. Puhastatud andmed (df_clean) ---")
    print(df_clean)

    print("\n--- 2. Nädalakoond (df_weekly) ---")
    print(df_weekly)

    print("\n--- 3. KPI-d (kpi_dict) ---")
    print(kpi_dict)

    print("\n--- 4. Liidetud tabel (df_merged) ---")
    print(df_merged)