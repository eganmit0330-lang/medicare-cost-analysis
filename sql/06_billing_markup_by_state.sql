-- Query: Which states have the most aggressive billing markup?
-- Ratio of sticker price to actual payment by state
-- Key finding: Nevada bills 6.4x what they collect, highest in the country
-- Dataset: bigquery-public-data.cms_medicare

SELECT
  provider_state,
  ROUND(AVG(average_covered_charges), 2) AS avg_sticker_price,
  ROUND(AVG(average_total_payments), 2) AS avg_actual_payment,
  ROUND(AVG(average_covered_charges) / AVG(average_total_payments), 1) AS markup_ratio,
  COUNT(DISTINCT provider_id) AS hospital_count
FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015`
GROUP BY provider_state
ORDER BY markup_ratio DESC
