# Detailed Findings — Medicare Cost Analysis

This document contains the full analysis behind each query in the repository. Each finding follows the same structure: business question, methodology, results, interpretation, and recommendations.

---

## Finding 1: State-Level Cost Variation

**Business Question:** Where are inpatient costs highest, and what does that tell us about regional cost drivers?

**Query:** `02_state_cost_comparison.sql`

**Approach:** Aggregated average covered charges (sticker price) and average total payments (actual payment) by state, with a national benchmark calculated via window function, and ranked states by sticker price.

**Top 5 States by Average Covered Charges:**

| Rank | State | Avg Covered Charges | Avg Total Payments | Hospital Count |
|---|---|---|---|---|
| 1 | California | $97,692 | $17,170 | 294 |
| 2 | Nevada | $91,063 | $14,243 | 21 |
| 3 | New Jersey | $87,982 | $14,128 | 64 |
| 4 | Alaska | $74,818 | $19,126 | 8 |
| 5 | DC | $69,066 | $19,138 | 7 |

**Interpretation:** California's high sticker price is offset by its dense hospital market (294 facilities) — actual payments are 6th nationally, not 1st. The more meaningful pattern is at the bottom of the table: Alaska and DC have the highest actual payments despite having the fewest hospitals. Limited provider competition appears to correlate with higher patient cost.

**Recommendation:** Cross-reference cost data with hospitals-per-capita to test the competition hypothesis. If confirmed, regulatory attention should focus on markets with fewer than 15 hospitals.

---

## Finding 2: Hospital Ownership and Cost Behavior

**Business Question:** Do for-profit hospitals charge more than nonprofit or government-run facilities?

**Query:** `03_ownership_vs_cost.sql`

**Results:**

| Ownership Type | Avg Covered Charges | Avg Total Payments | Hospital Count |
|---|---|---|---|
| Proprietary | $66,548 | $11,060 | 464 |
| Government - State | $62,528 | $21,274 | 29 |
| Physician | $52,778 | $12,865 | 52 |
| Voluntary non-profit - Private | $49,688 | $13,353 | 1,188 |
| Voluntary non-profit - Church | $49,515 | $12,852 | 196 |
| Government - Local | $34,191 | $11,553 | 127 |

**Interpretation:** For-profit hospitals bill the highest sticker price but collect average payments comparable to nonprofits. Government-State hospitals bill the second-highest but collect by far the highest actual payments ($21,274 — 60% above other categories). The billing-to-payment gap is largest at proprietary facilities (6:1), suggesting aggressive billing strategy rather than higher cost of care delivery.

**Recommendation:** Use billing-to-payment ratio as a regulatory signal for audit prioritization. Investigate Government-State higher actual payments to determine whether they reflect higher complexity case mix or different reimbursement structures.

---

## Finding 3: Cost vs Quality — The Headline

**Business Question:** Do patients pay more at higher-quality hospitals?

**Query:** `04_cost_vs_quality.sql`

**Results:**

| Star Rating | Avg Covered Charges | Avg Total Payments | Hospital Count |
|---|---|---|---|
| 1-star | $63,094 | $14,474 | 132 |
| 2-star | $52,831 | $12,873 | 471 |
| 3-star | $52,621 | $12,715 | 680 |
| 4-star | $48,153 | $12,864 | 686 |
| 5-star | $48,393 | $13,111 | 335 |

**Interpretation:** Cost decreases nearly linearly as quality increases. 1-star hospitals charge 31% more in covered charges and 10% more in actual payments than 5-star hospitals. This is the inverse of what consumer intuition suggests — "you get what you pay for" does not hold in Medicare inpatient care.

**Competing hypotheses:**
1. Quality ratings may partially reflect patient dissatisfaction with cost, creating a circular relationship
2. Low-rated hospitals may cluster in underserved regions where limited competition drives both higher prices AND lower quality
3. Higher-rated hospitals may have more efficient operations, lower complication rates, and shorter stays

**Recommendation:** Segment this analysis by geography (urban vs rural) and case mix complexity to isolate the driver before drawing causal conclusions. If geography explains the pattern, intervention should focus on rural market access. If not, this represents a structural failure of price-as-quality-signal in healthcare.

---

## Finding 4: Outlier Hospitals

**Business Question:** Which specific hospitals charge dramatically above the national average for routine procedures?

**Query:** `05_outlier_hospitals.sql`

**Approach:** Calculated national average per DRG procedure via window function, then flagged hospitals charging 2x+ the national average for that specific procedure.

**Top Outliers:**

| Hospital | State | Procedure | Hospital Charge | National Avg | Times Above |
|---|---|---|---|---|---|
| Orlando Health | FL | Coagulation Disorders | $1,052,088 | $101,847 | 10.3x |
| CarePoint Health-Christ Hospital | NJ | Organic Mental Disorders | $301,398 | $32,081 | 9.4x |
| Stanford Health Care | CA | Peripheral Vascular Disorders | $411,439 | $44,307 | 9.3x |
| Stanford Health Care | CA | Respiratory Diagnoses | $257,410 | $29,458 | 8.7x |
| CarePoint Health-Christ Hospital | NJ | Degenerative Nervous Disorders | $289,295 | $33,654 | 8.6x |
| CarePoint Health-Christ Hospital | NJ | Depressive Neuroses | $122,244 | $14,457 | 8.5x |
| CarePoint Health-Hoboken UMC | NJ | Cellulitis | $188,642 | $22,856 | 8.3x |
| Stanford Health Care | CA | Digestive System Diagnoses | $466,020 | $55,926 | 8.3x |

**Interpretation:** Two hospital systems — CarePoint Health (NJ) and Stanford Health Care (CA) — appear repeatedly in the top outliers across multiple, unrelated procedure categories. This indicates systematic billing behavior, not isolated incidents. The cross-procedure consistency suggests organizational pricing strategy rather than case-specific cost drivers.

**Recommendation:** Initiate formal billing review of CarePoint Health and Stanford Health Care. Investigate whether case severity, specialist concentration, or operational costs justify the markup, or whether this represents a regulatory gap.

---

## Finding 5: Billing Markup by State

**Business Question:** Which states have the largest gap between what hospitals bill and what they collect?

**Query:** `06_billing_markup_by_state.sql`

**Top Markup Ratios:**

| State | Sticker Price | Actual Payment | Markup Ratio | Hospital Count |
|---|---|---|---|---|
| Nevada | $91,063 | $14,243 | 6.4x | 21 |
| New Jersey | $87,982 | $14,128 | 6.2x | 64 |
| Florida | $67,915 | $11,426 | 5.9x | 167 |
| California | $97,692 | $17,170 | 5.7x | 294 |
| Colorado | $67,299 | $13,314 | 5.1x | 45 |

**Interpretation:** Markup ratio captures aggressive billing behavior independent of actual cost. Nevada hospitals bill 6.4x what they collect — the highest in the country — despite a small market (21 hospitals). The pattern correlates with states that also have higher actual patient costs, suggesting markup behavior translates into real patient burden through co-insurance and deductible calculations.

**Recommendation:** Use markup ratio as a state-level regulatory signal. States with ratios above 5.5x warrant investigation into billing practices.

---

## Finding 6: Patient Out-of-Pocket Burden

**Business Question:** Where do patients actually pay the most out of pocket?

**Query:** `07_patient_out_of_pocket.sql`

**Top States by Patient Responsibility:**

| State | Avg Actual Cost | Medicare Pays | Patient Responsibility | Hospital Count |
|---|---|---|---|---|
| DC | $19,138 | $14,791 | $4,346 | 7 |
| Utah | $14,968 | $11,786 | $3,182 | 31 |
| Hawaii | $18,080 | $14,910 | $3,171 | 12 |
| Pennsylvania | $13,038 | $10,459 | $2,579 | 152 |
| New York | $16,547 | $14,090 | $2,457 | 151 |
| Delaware | $13,870 | $11,439 | $2,431 | 6 |

**Interpretation:** Patient out-of-pocket cost (total payments minus Medicare payments) varies by 75%+ across states. DC patients pay $4,346 per inpatient stay — nearly double the lowest-cost states. The top states are a mix of small markets (DC, HI, DE) and large states (PA, NY), indicating both market concentration AND state-level factors drive patient cost burden.

**Recommendation:** This is the metric that matters most to patients and should be publicly accessible. State health departments should provide cost transparency tools showing patient-paid burden by hospital, not just hospital sticker price.

---

## Limitations and Future Analysis

**Limitations:**
- 2015 data; reimbursement structures and quality ratings have evolved
- "Average" payments mask within-hospital variation
- Inpatient-only focus; outpatient comparison limited by dataset scope mismatch
- Star ratings methodology is itself contested in healthcare policy literature

**Future analysis (planned extensions):**
- Hospital ownership mix by state — does for-profit prevalence explain state-level cost variation?
- Medicare coverage ratio by state — what % of total cost does Medicare cover, and where do gaps fall on patients?
- Procedure-specific deep dives — joint replacement, cardiac procedures, and oncology billing patterns
- Time-series analysis using multiple years of CMS data

---

## Methodology Notes

**Data quality issue identified and corrected:** Initial inpatient-vs-outpatient comparison produced wildly inflated ratios due to a many-to-many join (each provider had multiple rows in both tables, multiplying the row count). Corrected approach: aggregate each table to the state level in separate CTEs, then join the aggregates. This is a common pitfall worth documenting.

**Aggregation choice:** Used AVG of per-procedure averages rather than weighted average by discharge count. A more rigorous version would weight by `total_discharges` for true population-level averages. Acceptable for comparative analysis but should be noted for any absolute-dollar claims.

**Quality rating handling:** "Not Available" ratings (173 hospitals) excluded from cost-quality analysis to avoid distorting the relationship.
