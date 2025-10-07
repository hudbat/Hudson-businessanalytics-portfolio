-- 00_schema_peek.sql
SELECT name FROM sqlite_schema WHERE type='table';

-- 01_daily_kpis.sql
WITH line AS (
  SELECT sa.sale_date,
         sa.store_id,
         (sa.quantity * p.price) AS revenue,
         sa.quantity AS units
  FROM sales sa
  JOIN products p ON p.product_id = sa.product_id
)
SELECT sale_date,
       store_id,
       ROUND(SUM(revenue),2) AS revenue,
       SUM(units) AS units,
       ROUND(SUM(revenue) / NULLIF(SUM(units),0),2) AS aov
FROM line
GROUP BY 1,2
ORDER BY 1,2;

-- 02_promotions_impact.sql
WITH line AS (
  SELECT sa.sale_date,
         sa.promo_flag,
         (sa.quantity * p.price) AS revenue,
         sa.quantity AS units
  FROM sales sa
  JOIN products p ON p.product_id = sa.product_id
)
SELECT promo_flag,
       ROUND(AVG(revenue),2) AS avg_daily_revenue_per_line,
       ROUND(AVG(units),2)   AS avg_daily_units_per_line
FROM line
GROUP BY 1;

-- 03_top_categories.sql
WITH cat AS (
  SELECT sa.sale_date,
         pr.category,
         (sa.quantity * pr.price) AS revenue
  FROM sales sa
  JOIN products pr ON pr.product_id = sa.product_id
),
daily AS (
  SELECT sale_date,
         category,
         SUM(revenue) AS revenue
  FROM cat
  GROUP BY 1,2
),
ranked AS (
  SELECT sale_date,
         category,
         revenue,
         ROUND(revenue * 1.0 / SUM(revenue) OVER (PARTITION BY sale_date), 4) AS revenue_share,
         ROW_NUMBER() OVER (PARTITION BY sale_date ORDER BY revenue DESC) AS rn
  FROM daily
)
SELECT * FROM ranked WHERE rn <= 3 ORDER BY sale_date, rn;

-- 04_rolling_7d_revenue.sql
WITH d AS (
  SELECT sa.sale_date,
         sa.store_id,
         SUM(sa.quantity * p.price) AS revenue
  FROM sales sa
  JOIN products p ON p.product_id = sa.product_id
  GROUP BY 1,2
),
w AS (
  SELECT sale_date,
         store_id,
         revenue,
         SUM(revenue) OVER (
           PARTITION BY store_id
           ORDER BY sale_date
           ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
         ) AS rev_7d
  FROM d
)
SELECT * FROM w ORDER BY store_id, sale_date;

-- 05_mape_baseline.sql
WITH daily AS (
  SELECT sale_date, SUM(sa.quantity * p.price) AS revenue
  FROM sales sa
  JOIN products p ON p.product_id = sa.product_id
  GROUP BY 1
),
with_lag AS (
  SELECT sale_date,
         revenue AS actual,
         LAG(revenue) OVER (ORDER BY sale_date) AS forecast_naive
  FROM daily
)
SELECT sale_date,
       ROUND(actual,2) AS actual,
       ROUND(forecast_naive,2) AS forecast,
       ROUND(ABS(actual - forecast_naive) / NULLIF(actual,0),4) AS ape
FROM with_lag
ORDER BY sale_date;
