-- Query: Where do patients pay the most out of pocket?
-- Patient responsibility (total payments minus Medicare payments) by state
-- Key finding: DC patients pay $4,346 per stay, nearly double the next state
-- Dataset: bigquery-public-data.cms_medicare

SELECT
  provider_state,
  ROUND(AVG(average_total_payments), 2) AS avg_actual_cost,
  ROUND(AVG(average_medicare_payments), 2) AS avg_medicare_pays,
  ROUND(AVG(average_total_payments) - AVG(average_medicare_payments), 2) AS avg_patient_responsibility,
  COUNT(DISTINCT provider_id) AS hospital_count
FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015`
GROUP BY provider_state
ORDER BY avg_patient_responsibility DESC
