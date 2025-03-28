WITH quarterly_revenue AS (
    SELECT
        EXTRACT(YEAR FROM tpep_pickup_datetime) AS year,
        EXTRACT(QUARTER FROM tpep_pickup_datetime) AS quarter,
        ROUND(SUM(total_amount), 2) AS total_revenue
    FROM
        `skilled-tiger-450623-n7.ny_yellow_taxi.yellow_taxi_2019_2020`
    GROUP BY
        year, quarter
),
yoy_growth AS (
    SELECT
        q1.year,
        q1.quarter,
        q1.total_revenue AS current_revenue,
        IFNULL(q2.total_revenue, 0) AS previous_revenue,
        ROUND((((q1.total_revenue - q2.total_revenue) / q2.total_revenue) * 100), 2) AS          yoy_growth_percentage
    FROM
        quarterly_revenue q1
    LEFT JOIN
        quarterly_revenue q2
    ON
        q1.quarter = q2.quarter
        AND q1.year = q2.year + 1
)
SELECT
    year,
    quarter,
    current_revenue,
    previous_revenue,
    yoy_growth_percentage
FROM
    yoy_growth
ORDER BY
    yoy_growth_percentage DESC;