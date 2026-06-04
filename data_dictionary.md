# Data Dictionary — Medicare Cost Analysis

## Dataset: CMS Medicare Provider Utilization and Payment Data (2015)
**Source:** `bigquery-public-data.cms_medicare` (Google BigQuery Public Datasets)
**Original publisher:** Centers for Medicare and Medicaid Services (CMS)

---

## Table 1: `inpatient_charges_2015`

**Description:** Provider-level summary of Medicare inpatient discharges, charges, and payments by Diagnosis-Related Group (DRG). One row per provider per DRG.

**Row count:** 201,876

| Column | Type | Description |
|---|---|---|
| `provider_id` | STRING | Unique hospital identifier (CMS Certification Number). Joins to `hospital_general_info`. |
| `provider_name` | STRING | Hospital legal name |
| `provider_street_address` | STRING | Hospital street address |
| `provider_city` | STRING | Hospital city |
| `provider_state` | STRING | Hospital state (2-letter code) |
| `provider_zipcode` | STRING | Hospital ZIP code |
| `drg_definition` | STRING | DRG code and description (e.g., "470 - MAJOR JOINT REPLACEMENT OR REATTACHMENT OF LOWER EXTREMITY W/O MCC") |
| `hospital_referral_region_description` | STRING | Hospital Referral Region (geographic market area) |
| `total_discharges` | INTEGER | Number of Medicare patients treated for this DRG at this hospital |
| `average_covered_charges` | FLOAT | Hospital's submitted charge ("sticker price"). Largely fictional — represents what hospital bills, not what it collects |
| `average_total_payments` | FLOAT | Total payment hospital received from all sources (Medicare + patient + secondary insurance). This is the actual collected amount |
| `average_medicare_payments` | FLOAT | Portion of total payments coming from Medicare specifically |

**Key derived metrics:**
- Patient responsibility = `average_total_payments` - `average_medicare_payments`
- Markup ratio = `average_covered_charges` / `average_total_payments`

---

## Table 2: `outpatient_charges_2015`

**Description:** Provider-level summary of Medicare outpatient services by Ambulatory Payment Classification (APC). One row per provider per APC.

**Row count:** 32,532

| Column | Type | Description |
|---|---|---|
| `provider_id` | STRING | Unique hospital identifier |
| `provider_name` | STRING | Hospital name |
| `provider_state` | STRING | Hospital state |
| `apc` | STRING | Ambulatory Payment Classification code and description |
| `outpatient_services` | INTEGER | Number of Medicare outpatient services provided |
| `average_estimated_submitted_charges` | FLOAT | Hospital's submitted charge for outpatient services |
| `average_total_payments` | FLOAT | Total payments received for outpatient services |

**Note:** Outpatient table has narrower scope than inpatient (32K vs 201K rows). Direct dollar-to-dollar comparison between tables is unreliable without normalization.

---

## Table 3: `hospital_general_info`

**Description:** Hospital metadata including ownership, services, and quality ratings. One row per hospital.

**Row count:** 5,336

| Column | Type | Description |
|---|---|---|
| `provider_id` | STRING | Unique hospital identifier (joins to inpatient/outpatient tables) |
| `hospital_name` | STRING | Hospital name |
| `address`, `city`, `state`, `zip_code`, `county_name` | STRING | Hospital location |
| `phone_number` | STRING | Hospital phone |
| `hospital_type` | STRING | E.g., "Acute Care Hospital," "Critical Access Hospital" |
| `hospital_ownership` | STRING | Ownership category. See key values below. |
| `emergency_services` | STRING | Whether hospital provides emergency services (Yes/No) |
| `hospital_overall_rating` | STRING | CMS Overall Star Rating (1-5). May be "Not Available" |
| `mortality_measures_*` | INTEGER | Count of mortality measures where hospital performs better/same/worse than national average |
| `safety_measures_*` | INTEGER | Count of safety measures (same structure) |
| `readmission_measures_*` | INTEGER | Count of readmission measures (same structure) |
| `patient_experience_measures_*` | INTEGER | Count of patient experience measures |
| `timely_and_effective_care_measures_*` | INTEGER | Count of timely and effective care measures |

**Hospital ownership categories (key values):**
- `Proprietary` — for-profit hospitals (run by companies for shareholder return)
- `Voluntary non-profit - Private` — nonprofit hospitals run by private organizations (most common)
- `Voluntary non-profit - Church` — religiously-affiliated nonprofit hospitals
- `Voluntary non-profit - Other` — nonprofits not fitting the above categories
- `Government - Federal` — federal government hospitals (e.g., VA)
- `Government - State` — state government hospitals (often major university medical centers)
- `Government - Local` — city/county hospitals
- `Government - Hospital District or Authority` — special tax district hospitals (common in rural areas)
- `Physician` — physician-owned hospitals
- `Tribal` — Native American tribal hospitals

---

## Reference: Covered Charges vs Total Payments vs Medicare Payments

A critical distinction for interpreting this dataset:

**Covered Charges ("sticker price"):** The amount the hospital bills. Largely fictional — Medicare sets its own reimbursement rates and rarely pays close to the billed amount. Hospitals inflate charges as a starting point for negotiation with private insurers.

**Total Payments:** The actual amount the hospital collects, summed across all payers (Medicare + patient + secondary insurance). This is real money in the door.

**Medicare Payments:** The portion of total payments coming from Medicare specifically. The remainder is patient responsibility (deductibles, co-insurance) plus any secondary insurance.

**Patient responsibility = Total Payments - Medicare Payments**

This is the number that matters most to patients — what they actually pay out of pocket.

---

## DRG Reference

DRGs (Diagnosis-Related Groups) classify inpatient stays into ~750 categories for Medicare reimbursement purposes. Each DRG has a fixed payment weight regardless of actual cost. Examples used in this analysis:

- `470` — Major joint replacement (most common DRG)
- `057` — Degenerative nervous system disorders
- `206` — Other respiratory system diagnoses
- `299` — Peripheral vascular disorders
- `393` — Other digestive system diagnoses
- `603` — Cellulitis
- `682` — Renal failure
- `813` — Coagulation disorders
- `881` — Depressive neuroses
- `884` — Organic disturbances

For full DRG reference, see [CMS DRG Code Lookup](https://www.cms.gov/icd10m/version372-fullcode-cms/fullcode_cms/P0001.html).
