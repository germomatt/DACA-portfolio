from datetime import datetime
import logging
import os
import pandas as pd
import plotly.express as px
import plotly.graph_objects as go
from plotly.subplots import make_subplots

# Impordime sinu Roll B funktsioonid
from transform import (
    calculate_kpis,
    calculate_weekly_aggregates,
    clean_data,
    merge_datasets,
)

# Seadistame logimise
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%H:%M:%S",
)
logger = logging.getLogger(__name__)


# 1. Nädalase tululiikumise joondiagramm
def create_weekly_chart(df_weekly: pd.DataFrame) -> go.Figure:
    """Loob Plotly joondiagrammi nädalasest tulust."""
    logger.info("--- Loon nädalase tulu joondiagrammi ---")
    if df_weekly is None or df_weekly.empty:
        logger.warning("df_weekly on tühi, tagastan tühja graafiku.")
        return go.Figure()

    x_col = (
        "sale_date" if "sale_date" in df_weekly.columns else df_weekly.columns[0]
    )

    fig = px.line(
        df_weekly,
        x=x_col,
        y="revenue",
        markers=True,
        title="📈 Nädalane tululiikumine (Weekly Revenue Trend)",
        labels={x_col: "Kuupäev / Nädal", "revenue": "Tulu (€)"},
        template="plotly_white",
    )
    fig.update_traces(line=dict(width=3, color="#2563eb"), marker=dict(size=8))
    return fig


# 2. KPI-de kokkuvõtte indikaatorkaardid
def create_kpi_summary(kpis: dict) -> go.Figure:
    """Loob Plotly Indicator kaartide paneeli peamistest KPI-dest."""
    logger.info("--- Loon KPI kokkuvõtte kaardid ---")
    if not kpis:
        logger.warning("KPI sõnastik on tühi.")
        return go.Figure()

    fig = make_subplots(
        rows=1,
        cols=3,
        specs=[
            [
                {"type": "indicator"},
                {"type": "indicator"},
                {"type": "indicator"},
            ]
        ],
    )

    # 1. Kogutulu (Total Revenue)
    fig.add_trace(
        go.Indicator(
            mode="number",
            value=kpis.get("total_revenue", 0),
            number={"prefix": "€", "valueformat": ",.2f"},
            title={"text": "<b>Kogutulu (Total Revenue)</b>"},
        ),
        row=1,
        col=1,
    )

    # 2. Unikaalsed kliendid (Unique Customers)
    fig.add_trace(
        go.Indicator(
            mode="number",
            value=kpis.get("unique_customers", 0),
            number={"valueformat": "d"},
            title={"text": "<b>Kliendid (Unique Customers)</b>"},
        ),
        row=1,
        col=2,
    )

    # 3. Keskmine ostusumma (Avg Order Value)
    fig.add_trace(
        go.Indicator(
            mode="number",
            value=kpis.get("avg_order_value", 0),
            number={"prefix": "€", "valueformat": ".2f"},
            title={"text": "<b>Keskmine ost (Avg Order)</b>"},
        ),
        row=1,
        col=3,
    )

    fig.update_layout(
        title="🎯 Peamised tulemusmõõdikud (KPI Overview)",
        template="plotly_white",
        height=300,
    )
    return fig


# 3. Tulemuste eksport (CSV + HTML graafikud)
def export_results(
    df: pd.DataFrame, figures: dict = None, output_dir: str = "output"
) -> None:
    """Salvestab DataFrame'i kuupäevatempliga CSV-na ja graafikud HTML-failidena."""
    logger.info(f"--- Alustan tulemuste eksporti kausta: '{output_dir}' ---")

    # 1. Loo output/ kaust, kui seda pole
    os.makedirs(output_dir, exist_ok=True)

    # 2. Kuupäevatempel failinimesse (nt results_20260811.csv)
    date_str = datetime.now().strftime("%Y%m%d")

    # 3. Salvesta CSV
    if df is not None and not df.empty:
        csv_path = os.path.join(output_dir, f"results_{date_str}.csv")
        df.to_csv(csv_path, index=False)
        logger.info(f"✅ CSV edukalt salvestatud: {csv_path}")

    # 4. Salvesta Plotly graafikud HTML failidena
    if figures:
        for name, fig in figures.items():
            if fig and isinstance(fig, go.Figure):
                html_path = os.path.join(output_dir, f"{name}_{date_str}.html")
                fig.write_html(html_path)
                logger.info(f"✅ Graafik salvestatud: {html_path}")


# --- TESTIMINE JA LÄBIJOOKS ---
if __name__ == "__main__":
    logger.info("=== KÄIVITAN ROLL C TESTI ===")

    # 1. Loome näidisandmed
    mock_sales = pd.DataFrame(
        {
            "id": [1, 2, 3, 4, 4, 5],
            "customer_id": [101, 102, 101, 103, 103, 104],
            "sale_date": [
                "2026-03-01",
                "2026-03-03",
                "2026-03-10",
                "2026-03-12",
                "2026-03-12",
                "2026-03-15",
            ],
            "total_amount": [50.0, 120.0, 30.0, 80.0, 80.0, 95.0],
        }
    )
    mock_customers = pd.DataFrame(
        {
            "customer_id": [101, 102, 103, 104],
            "name": ["Mari Maasikas", "Jüri Tamm", "Kati Kask", "Toomas Kivi"],
            "city": ["Tallinn", "Tartu", "Pärnu", "Tallinn"],
        }
    )

    # 2. Käivitame Roll B transformatsioonid
    df_clean = clean_data(mock_sales)
    df_weekly = calculate_weekly_aggregates(mock_sales)
    kpis = calculate_kpis(mock_sales)
    df_merged = merge_datasets(mock_sales, mock_customers)

    # 3. Käivitame Roll C visualiseerimised
    fig_weekly = create_weekly_chart(df_weekly)
    fig_kpis = create_kpi_summary(kpis)

    # 4. Ekspordime tulemused output/ kausta
    export_results(
        df=df_merged,
        figures={"weekly_revenue": fig_weekly, "kpi_summary": fig_kpis},
        output_dir="output",
    )

    logger.info("🎉 Roll C töö edukalt lõpetatud! Kontrolli kausta 'output'.")
