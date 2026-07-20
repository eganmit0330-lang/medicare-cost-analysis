-- Query: Do states with more for-profit hospitals cost patients more?
-- Combines ownership mix with billing markup and patient out-of-pocket cost
-- Finding: for-profit share tracks with aggressive BILLING (NV, FL, TX lead both)
-- but does NOT predict what patients actually pay — Medicare sets patient
-- responsibility by its own rates regardless of what the hospital bills
-- Dataset: bigquery-public-data.cms_medicare

WITH ownership AS (
  SELECT
    state,
    COUNT(DISTINCT provider_id) AS total_hospitals,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN hospital_ownership = 'Proprietary' THEN provider_id END) / COUNT(DISTINCT provider_id), 1) AS pct_for_profit
  FROM `bigquery-public-data.cms_medicare.hospital_general_info`
  GROUP BY state
),

costs AS (
  SELECT
    provider_state,
    ROUND(AVG(average_total_payments) - AVG(average_medicare_payments), 2) AS avg_patient_cost,
    ROUND(AVG(average_covered_charges) / AVG(average_total_payments), 1) AS markup_ratio
  FROM `bigquery-public-data.cms_medicare.inpatient_charges_2015`
  GROUP BY provider_state
)

SELECT
  o.state,
  o.pct_for_profit,
  c.markup_ratio,
  c.avg_patient_cost,
  o.total_hospitals
FROM ownership o
JOIN costs c
  ON o.state = c.provider_state
ORDER BY o.pct_for_profit DESC
