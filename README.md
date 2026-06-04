# Medicare Cost Analysis: Do Patients Get What They Pay For?

> **Investigating whether Medicare patients pay more at hospitals that deliver better care — and where the system is broken.**

---

## Executive Summary

This analysis examines 200,000+ Medicare billing records across 5,000+ U.S. hospitals to answer a question patients can't easily answer themselves: *does paying more get you better care?*

**The short answer: no — and in many cases, it's the opposite.**

### Three findings that matter

1. **1-star hospitals are 31% more expensive than 5-star hospitals.** Patients at the lowest-rated facilities pay an average of $14,474 per inpatient stay vs $13,111 at top-rated hospitals — for comparable procedures.

2. **A handful of hospitals charge 8-10x the national average for routine procedures.** Orlando Health billed $1,052,088 for coagulation disorder treatment — 10.3x the national average. CarePoint Health (NJ) and Stanford Health Care (CA) appear repeatedly as systematic outliers.

3. **Patients in low-supply markets pay double the national average out of pocket.** DC patients pay $4,346 per hospital stay vs $2,000–$3,000 in larger markets — driven by limited provider competition.

### So what?

These findings have direct implications for **state health departments, payers, and patients evaluating care options**. Each finding maps to a specific next investigation, detailed in the findings document.

---

## The Business Question

Healthcare consulting firms, state regulators, and health insurers face a recurring question: where is Medicare money being spent inefficiently, and how can patients and policymakers identify it?

This analysis treats that question as an analyst at a healthcare consultancy would: by examining the public CMS Medicare dataset to find cost variation, identify outliers, and test whether higher cost correlates with better quality.

---

## Methodology

**Data Source:** CMS Medicare Provider Utilization and Payment Data (2015), accessed via `bigquery-public-data.cms_medicare`

**Scope:**
- 201,876 inpatient billing records (DRG-level)
- 32,532 outpatient billing records (APC-level)
- 5,336 hospital metadata records (ownership, type, quality ratings)

**Tools:** BigQuery (SQL), Tableau Public (dashboard), GitHub (documentation)

**Approach:** Seven analytical queries answering progressively deeper questions — starting with where costs vary by state, then who charges more, whether quality justifies cost, which hospitals are outliers, and what patients actually pay out of pocket.

---

## Key Findings

### 1. Geographic cost variation is driven by hospital supply, not sticker price
California has the highest average sticker price ($97,692) but ranks only 6th in patient out-of-pocket cost. Alaska and DC — with 8 and 7 hospitals respectively — have the highest actual patient costs. **Limited provider competition predicts higher real prices.**

### 2. For-profit hospitals charge more, but collect average
Proprietary hospitals bill $66,548 on average — 34% above nonprofit hospitals — yet collect $11,059, comparable to nonprofits. The billing-payment gap is largest at for-profit facilities, suggesting aggressive billing strategy rather than higher cost of care.

### 3. The cost-quality inversion (headline finding)
1-star hospitals charge an average of $63,094 in covered charges and collect $14,474 in total payments. 5-star hospitals charge $48,393 and collect $13,111. **The worst hospitals cost the most.** Hypotheses:
- Ratings may partially reflect patient dissatisfaction with cost
- Low-rated hospitals may cluster in underserved areas with limited competition
- Either way, "paying more for better care" is not supported by the data

### 4. Systematic outliers exist and are nameable
Two providers — CarePoint Health (NJ) and Stanford Health Care (CA) — appear repeatedly among hospitals charging 8x+ the national average across multiple procedure categories. This isn't a one-off; it's a pattern that warrants regulatory attention.

### 5. Markup behavior varies dramatically by state
Nevada hospitals bill 6.4x what they collect — the highest ratio in the country. New Jersey is second at 6.2x. States with the highest markups also have higher actual patient costs, suggesting markup correlates with patient-paid prices despite the negotiation gap.

### 6. Patient out-of-pocket cost is concentrated in low-supply markets
DC patients pay $4,346 out of pocket per inpatient stay — nearly double the next-highest state. The top 5 most expensive states for patients are a mix of small markets (DC, HI, DE) and large states (NY, PA), suggesting both competition and state-level factors drive cost burden.

---

## Recommendations

For a hypothetical state health department or healthcare consultancy:

| Finding | Recommended Action |
|---|---|
| For-profit billing markup | Audit billing practices at proprietary hospitals; investigate billing-to-payment ratio as a regulatory signal |
| Cost-quality inversion | Investigate confounding variables (geography, case mix) before drawing causal conclusions; flag 1-star hospitals for quality intervention |
| Systematic outliers | Initiate formal review of CarePoint Health and Stanford Health Care billing practices |
| Low-supply state pricing | Cross-reference with hospitals-per-capita data to test the competition hypothesis |
| Patient out-of-pocket burden | Provide cost transparency tools to patients in DC, Alaska, Hawaii markets |

---

## Visualizations

(https://public.tableau.com/app/profile/mitchell.egan/viz/MedicareCostandQualityAnalysis/Dashboard1)

The dashboard tells the story in four sheets:
1. **Cost vs Quality scatter plot** — the headline finding visualized
2. **Patient out-of-pocket heatmap** — geographic burden by state
3. **Ownership type comparison** — for-profit billing behavior
4. **Outlier hospitals table** — named hospitals charging 3x+ national average

---

## Repository Structure

```
medicare-cost-analysis/
├── README.md
├── sql/
│   ├── 01_exploration.sql
│   ├── 02_state_cost_comparison.sql
│   ├── 03_ownership_vs_cost.sql
│   ├── 04_cost_vs_quality.sql
│   ├── 05_outlier_hospitals.sql
│   ├── 06_billing_markup_by_state.sql
│   └── 07_patient_out_of_pocket.sql
├── data/
│   └── data_dictionary.md
├── findings/
│   └── detailed_findings.md
└── visualizations/
    ├── dashboard_screenshot.png
    └── tableau_link.md
```

---

## What This Project Demonstrates

- **Multi-table SQL analysis** — joins across inpatient, outpatient, and hospital metadata tables
- **Window functions** — benchmarking against national and regional averages
- **Data quality instincts** — caught and corrected a many-to-many join that inflated initial results; pivoted analysis to use comparable metrics
- **Domain expertise** — interpretation grounded in healthcare reimbursement structure (covered charges vs total payments vs Medicare payments)
- **Business communication** — every finding paired with specific recommendations, not raw observations

---

## About

Built by Mitch Egan, transitioning from cancer research at Fred Hutchinson Cancer Center to data analytics. Clinical research background informs interpretation of healthcare data quality and reimbursement structures.

- [LinkedIn](#)
- [GitHub Portfolio](#)
- [Tableau Public](#)
