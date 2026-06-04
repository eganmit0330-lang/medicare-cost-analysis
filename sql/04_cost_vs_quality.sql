-- Query: Do expensive hospitals deliver better care?
-- Compares average cost across hospital star ratings (1-5)
-- Key finding: 1-star hospitals charge 31% more than 5-star hospitals
-- Dataset: bigquery-public-data.cms_medicare

WITH everything AS (
  SELECT
    ic.provider_id,
    gi.hospital_overall_rating,
    ic.average_covered_charges,
    ic.average_total_payments
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015` ic
  JOIN `bigquery-public-data.cms_medicare.hospital_general_info` gi
    ON ic.provider_id = gi.provider_id
)

SELECT
  hospital_overall_rating,
  ROUND(AVG(average_covered_charges), 2) AS avg_covered_charges,
  ROUND(AVG(average_total_payments), 2) AS avg_total_payments,
  COUNT(DISTINCT provider_id) AS hospital_count
FROM everything
GROUP BY hospital_overall_rating
ORDER BY avg_covered_charges DESC
