-- Query: Which states have the highest Medicare inpatient costs?
-- Compares average sticker price and actual payments by state
-- Dataset: bigquery-public-data.cms_medicare.inpatient_charges_2015

WITH helper AS (
  SELECT
    provider_state,
    ROUND(AVG(average_covered_charges), 2) AS avg_covered_charges,
    ROUND(AVG(average_total_payments), 2) AS avg_total_payments,
    COUNT(DISTINCT provider_id) AS hospital_count
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015`
  GROUP BY provider_state
)

SELECT
  provider_state,
  avg_covered_charges,
  avg_total_payments,
  ROUND(AVG(avg_covered_charges) OVER(), 2) AS national_avg_charges,
  hospital_count,
  RANK() OVER(ORDER BY avg_covered_charges DESC) AS cost_rank
FROM helper
