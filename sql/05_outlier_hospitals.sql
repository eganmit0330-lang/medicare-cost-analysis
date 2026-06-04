-- Query: Which hospitals charge dramatically above the national average?
-- Flags hospitals billing 2x+ the procedure-level national average
-- Key finding: CarePoint Health (NJ) and Stanford (CA) appear repeatedly at 8-10x average
-- Dataset: bigquery-public-data.cms_medicare

WITH ntl_avg AS (
  SELECT
    provider_name,
    provider_state,
    drg_definition,
    average_covered_charges,
    AVG(average_covered_charges) OVER(PARTITION BY drg_definition) AS national_avg_for_procedure
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015`
)

SELECT
  provider_name,
  provider_state,
  drg_definition,
  average_covered_charges,
  ROUND(national_avg_for_procedure, 2) AS national_avg_for_procedure,
  ROUND(average_covered_charges / national_avg_for_procedure, 1) AS times_above_average
FROM ntl_avg
WHERE average_covered_charges / national_avg_for_procedure >= 2.0
ORDER BY times_above_average DESC
