-- Query: Do certain types of hospitals charge more?
-- Compares cost by hospital ownership type (for-profit, nonprofit, government)
-- Dataset: bigquery-public-data.cms_medicare

WITH everything AS (
  SELECT
    ic.provider_id,
    ic.average_covered_charges,
    ic.average_total_payments,
    gi.hospital_ownership
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015` ic
  JOIN `bigquery-public-data.cms_medicare.hospital_general_info` gi
    ON ic.provider_id = gi.provider_id
)

SELECT
  hospital_ownership,
  ROUND(AVG(average_covered_charges), 2) AS avg_covered_charges,
  ROUND(AVG(average_total_payments), 2) AS avg_total_payments,
  COUNT(DISTINCT provider_id) AS hospital_count
FROM everything
GROUP BY hospital_ownership
ORDER BY avg_covered_charges DESC
