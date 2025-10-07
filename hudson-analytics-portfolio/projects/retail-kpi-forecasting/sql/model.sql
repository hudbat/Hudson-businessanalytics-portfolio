-- Daily retail model (toy example)
WITH base AS (
  SELECT CAST(date AS date) AS date,
         store_id,
         traffic,
         conversions,
         revenue,
         promo_flag
  FROM retail_sample
),
agg AS (
  SELECT date,
         SUM(traffic) AS traffic,
         SUM(conversions) AS conversions,
         SUM(revenue) AS revenue,
         SUM(CASE WHEN promo_flag=1 THEN 1 ELSE 0 END) AS promo_days
  FROM base
  GROUP BY 1
)
SELECT *,
       (conversions::float/NULLIF(traffic,0)) AS close_rate,
       (revenue::float/NULLIF(conversions,0)) AS aov
FROM agg
ORDER BY date;
