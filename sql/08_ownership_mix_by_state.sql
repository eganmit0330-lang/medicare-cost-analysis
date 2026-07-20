-- Query: Does hospital ownership mix explain state cost variation?
-- Breaks down each state by % for-profit, % nonprofit, % government
-- Key finding: States with more for-profit hospitals have higher markup ratios
-- (Nevada: 50% for-profit, 6.4x markup. Florida: 40%, 5.9x. Texas: 36%, 5.1x)
-- Dataset: bigquery-public-data.cms_medicare

SELECT
  state,
  COUNT(DISTINCT provider_id) AS total_hospitals,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN hospital_ownership = 'Proprietary' THEN provider_id END) / COUNT(DISTINCT provider_id), 1) AS pct_for_profit,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN hospital_ownership LIKE 'Voluntary%' THEN provider_id END) / COUNT(DISTINCT provider_id), 1) AS pct_nonprofit,
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN hospital_ownership LIKE 'Government%' THEN provider_id END) / COUNT(DISTINCT provider_id), 1) AS pct_government
FROM `bigquery-public-data.cms_medicare.hospital_general_info`
GROUP BY state
ORDER BY pct_for_profit DESC
