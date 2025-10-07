# SQL Showcase — Retail Analytics (SQLite)
**Goal:** Demonstrate practical SQL for analytics hiring screens using a tiny SQLite database you can run locally (DB Browser for SQLite, DBeaver, or DuckDB/SQLite from Python).

## What’s inside
- `/data/retail_demo.sqlite` — ready-to-query database
- `/sql/queries.sql` — CTEs, joins, window functions, rolling 7d, naive forecast MAPE
- `/results/*.csv` — query outputs you can screenshot or chart
- (Optional) import CSVs into Tableau/Power BI for a quick KPI dashboard

## Example questions this repo answers
1. Daily KPI table (revenue, units, AOV) by store
2. Promo vs non‑promo impact
3. Top categories by daily revenue share (window functions)
4. Rolling 7‑day revenue by store (window frame)
5. Baseline forecast (lag) and MAPE calculation

## How to run
1) **Download** a SQLite client: *DB Browser for SQLite* (simple GUI).  
2) **Open** `/data/retail_demo.sqlite`.  
3) Go to the **Execute SQL** tab → paste queries from `/sql/queries.sql` block by block.  
4) Export results to CSV (or take screenshots) and drop them in `/results` for your portfolio.

## Talk track (interview)
- “I modeled revenue using price×quantity at line level, then aggregated to daily grain via CTEs.”
- “I used window functions for revenue share and rolling 7‑day sums; frames keep store partitions isolated.”
- “For forecasting I start with a naive lag model to establish a baseline and compute MAPE before adding seasonality.”

## Next steps (if you extend)
- Add a calendar table for robust date joins and business-day filters.
- Parameterize promo windows and compare uplift with a difference‑in‑differences cut.
- Create a small Tableau dashboard from `/results/01_daily_kpis.csv` and `/results/04_rolling_7d_revenue.csv`.
