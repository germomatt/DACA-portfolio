import pandas as pd


# 1. Puhastamise funktsioon
def clean_data(df: pd.DataFrame) -> pd.DataFrame:
    """Eemaldab duplikaadid, käsitleb NULL-id ja teisendab kuupäevad."""
    if df is None or df.empty:
        return pd.DataFrame()

    df_clean = df.copy()

    # Eemalda duplikaadid
    df_clean = df_clean.drop_duplicates()

    # Teisenda kuupäevad datetime formaati
    if "sale_date" in df_clean.columns:
        df_clean["sale_date"] = pd.to_datetime(df_clean["sale_date"])

    # Käsitle NULL-väärtused: eemalda read, kus kriitilised väljad puuduvad
    if "total_amount" in df_clean.columns:
        df_clean = df_clean.dropna(subset=["total_amount"])

    return df_clean


# 2. Nädalaste koondnäitajate arvutamine
def calculate_weekly_aggregates(df: pd.DataFrame) -> pd.DataFrame:
    """Grupeerib nädalate kaupa: tulu, tellimuste arv, keskmine ostusumma."""
    if df is None or df.empty:
        return pd.DataFrame()

    df_clean = clean_data(df)

    if df_clean.empty or "sale_date" not in df_clean.columns:
        return pd.DataFrame()

    # Grupeeri nädala kaupa (resample 'W' sale_date veeru põhjal)
    weekly = (
        df_clean.set_index("sale_date")
        .resample("W")
        .agg(
            revenue=("total_amount", "sum"),
            order_count=("id", "count"),
            avg_order_value=("total_amount", "mean"),
        )
        .reset_index()
    )

    return weekly


# 3. KPI-de arvutamine (tagastab dict vähemalt 3 meetrikaga)
def calculate_kpis(df: pd.DataFrame) -> dict:
    """Arvutab peamised KPI-d: total revenue, unique customers, avg order value."""
    if df is None or df.empty:
        return {
            "total_revenue": 0.0,
            "unique_customers": 0,
            "avg_order_value": 0.0,
        }

    df_clean = clean_data(df)

    if df_clean.empty:
        return {
            "total_revenue": 0.0,
            "unique_customers": 0,
            "avg_order_value": 0.0,
        }

    total_revenue = float(df_clean["total_amount"].sum())
    unique_customers = (
        int(df_clean["customer_id"].nunique())
        if "customer_id" in df_clean.columns
        else 0
    )
    avg_order_value = (
        float(df_clean["total_amount"].mean()) if len(df_clean) > 0 else 0.0
    )

    return {
        "total_revenue": round(total_revenue, 2),
        "unique_customers": unique_customers,
        "avg_order_value": round(avg_order_value, 2),
    }


# 4. Andmestike liitmine
def merge_datasets(
    df_sales: pd.DataFrame, df_customers: pd.DataFrame
) -> pd.DataFrame:
    """Liidab müügi- ja kliendiandmed customer_id veeru järgi."""
    if df_sales is None or df_customers is None:
        return pd.DataFrame()

    df_sales_clean = clean_data(df_sales)
    df_customers_clean = df_customers.drop_duplicates()

    # Liida customer_id järgi
    merged_df = pd.merge(
        df_sales_clean,
        df_customers_clean,
        on="customer_id",
        how="inner",
        suffixes=("_sale", "_customer"),
    )

    return merged_df


# --- TESTIMINE (Käivitub ainult selle faili otse käivitamisel) ---
if __name__ == "__main__":
    print("=== TESTIME ROLL B FUNKTSIOONE ===")

    # Loome testimiseks näidisandmed
    mock_sales = pd.DataFrame(
        {
            "id": [1, 2, 3, 4, 4],  # Sisaldab duplikaati id=4
            "customer_id": [101, 102, 101, 103, 103],
            "sale_date": [
                "2026-03-01",
                "2026-03-03",
                "2026-03-10",
                "2026-03-12",
                "2026-03-12",
            ],
            "total_amount": [50.0, 120.0, 30.0, 80.0, 80.0],
        }
    )

    mock_customers = pd.DataFrame(
        {
            "customer_id": [101, 102, 103],
            "name": ["Mari Maasikas", "Jüri Tamm", "Kati Kask"],
            "city": ["Tallinn", "Tartu", "Pärnu"],
        }
    )

    # 1. Test clean_data
    df_c = clean_data(mock_sales)
    print(f"\n1. clean_data tulemus (ridu: {len(df_c)}):")
    print(df_c)

    # 2. Test calculate_weekly_aggregates
    df_w = calculate_weekly_aggregates(mock_sales)
    print(f"\n2. calculate_weekly_aggregates tulemus:")
    print(df_w)

    # 3. Test calculate_kpis
    kpis = calculate_kpis(mock_sales)
    print(f"\n3. calculate_kpis tulemus:")
    print(kpis)

    # 4. Test merge_datasets
    df_m = merge_datasets(mock_sales, mock_customers)
    print(f"\n4. merge_datasets tulemus (ridu: {len(df_m)}):")
    print(df_m.head())