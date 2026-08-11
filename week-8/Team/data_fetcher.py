"""
data_fetcher.py
UrbanStyle OÜ — Supabase API päringud
Roll: API Query
"""

from supabase import create_client
from dotenv import load_dotenv
import os
import pandas as pd
import logging

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s"
)
logger = logging.getLogger(__name__)

# --- Supabase client ---
load_dotenv()
_url = os.getenv("SUPABASE_URL")
_key = os.getenv("SUPABASE_KEY")

if not _url or not _key:
    raise ValueError("SUPABASE_URL või SUPABASE_KEY puudub .env failist!")

supabase = create_client(_url, _key)


def fetch_sales(start_date=None, end_date=None):
    """
    Päri müügiandmed Supabase'ist.

    Args:
        start_date: alguskuupäev 'YYYY-MM-DD' (valikuline)
        end_date: lõppkuupäev 'YYYY-MM-DD' (valikuline)

    Returns:
        pd.DataFrame: müügiandmed
    """
    try:
        query = supabase.table("sales").select("*")

        if start_date:
            query = query.gte("sale_date", start_date)
        if end_date:
            query = query.lte("sale_date", end_date)

        # Pagination — kui ridu > 1000
        all_data = []
        page_size = 1000
        offset = 0

        while True:
            response = query.range(offset, offset + page_size - 1).execute()
            batch = response.data or []
            all_data.extend(batch)
            if len(batch) < page_size:
                break
            offset += page_size

        df = pd.DataFrame(all_data)
        logger.info(f"fetch_sales: {len(df)} rida")
        return df

    except Exception as e:
        logger.error(f"Viga müügiandmete pärimisel: {e}")
        print(f"VIGA fetch_sales: {e}")
        return pd.DataFrame()


def fetch_customers():
    """
    Päri kliendiandmed Supabase'ist.

    Returns:
        pd.DataFrame: kliendiandmed
    """
    try:
        response = supabase.table("customers").select("*").execute()
        df = pd.DataFrame(response.data or [])
        logger.info(f"fetch_customers: {len(df)} rida")
        return df

    except Exception as e:
        logger.error(f"Viga kliendiandmete pärimisel: {e}")
        print(f"VIGA fetch_customers: {e}")
        return pd.DataFrame()


def fetch_products():
    """
    Päri tooteandmed Supabase'ist.

    Returns:
        pd.DataFrame: tooteandmed
    """
    try:
        response = supabase.table("products").select("*").execute()
        df = pd.DataFrame(response.data or [])
        logger.info(f"fetch_products: {len(df)} rida")
        return df

    except Exception as e:
        logger.error(f"Viga tooteandmete pärimisel: {e}")
        print(f"VIGA fetch_products: {e}")
        return pd.DataFrame()


# --- Test ---
if __name__ == "__main__":
    print("=" * 50)
    print("  DATA FETCHER TEST")
    print("=" * 50)

    df_sales = fetch_sales()
    print(f"\nSales: {len(df_sales)} rida")
    print(df_sales.head())

    df_customers = fetch_customers()
    print(f"\nCustomers: {len(df_customers)} rida")
    print(df_customers.head())

    df_products = fetch_products()
    print(f"\nProducts: {len(df_products)} rida")
    print(df_products.head())

    # Kuupäevafiltriga test
    df_filtered = fetch_sales(start_date="2024-01-01", end_date="2024-06-30")
    print(f"\nSales (2024 H1): {len(df_filtered)} rida")