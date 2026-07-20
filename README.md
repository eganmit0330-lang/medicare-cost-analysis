# Medicare Cost Analysis: Do Patients Get What They Pay For?

> **I analyzed 200,000+ Medicare hospital bills to answer one question: if you pay more, do you get better care? The answer is no — and sometimes it's the opposite.**

---

## The Three Findings That Matter Most

**1. The worst hospitals charge the most.**
Patients at 1-star hospitals pay an average of $14,474 per stay. At 5-star hospitals: $13,111. As quality goes up, cost goes down. "You get what you pay for" is not true in American hospitals.

**2. A few hospitals charge 8-10x what everyone else charges — for the same procedures.**
Orlando Health billed over $1 million for a treatment that averages $101,847 nationally. Two hospital systems — CarePoint Health (NJ) and Stanford Health Care (CA) — show up again and again charging 8x+ across completely unrelated procedures. That's not case complexity. That's a pattern.

**3. What patients pay is decided by state policy, not by the hospital's bill.**
DC patients pay 23% of their hospital's total cost — $4,346 per stay, the highest in the country. Maryland patients pay just 9% — $1,481, nearly the lowest — even though Maryland hospitals are among the most expensive in America. The difference? Maryland is the only state that sets hospital rates itself. Where you live decides what you owe.

---

## The Data

**Source:** CMS Medicare Provider Utilization and Payment Data (2015), via `bigquery-public-data.cms_medicare`

| Table | What it holds | Rows |
|---|---|---|
| Inpatient charges | One row per hospital per procedure type | 201,876 |
| Outpatient charges | Same, for same-day visits | 32,532 |
| Hospital info | Ownership, location, 1-5 star quality rating | 5,336 |

**Three numbers appear throughout, and they are not the same thing:**
- **Covered charges** = the sticker price. Nobody pays this. It's a negotiation opener.
- **Total payments** = what the hospital actually collects, from all sources combined.
- **Medicare payments** = the government's share of that.
- **What the patient owes** = total payments minus Medicare payments.

**Tools:** BigQuery (SQL), Tableau Public, GitHub

---

## All Eight Findings

### 1. Sticker prices and real prices live in different worlds
California has the highest sticker prices in America ($97,692 average) — but ranks 21st in what patients actually pay. The number on the bill and the number that leaves your bank account are almost unrelated.

### 2. For-profit hospitals bill big and collect small
For-profit hospitals put $66,548 on the average bill — 34% more than nonprofits. But they collect roughly the same ($11K vs $13K). The giant bill is a negotiating tactic, not a real price.

### 3. The worst hospitals cost the most (the headline)
Cost falls as quality rises, almost in a straight line. Two possible reasons: patients who get big bills rate hospitals worse on the satisfaction surveys that feed the star ratings (bills and surveys can arrive in the same window after discharge) — or low-rated hospitals sit in areas where they face little pressure to improve. Either way, price is not a signal of quality in this data.

### 4. The outliers have names
CarePoint Health (NJ) and Stanford Health Care (CA) appear repeatedly at 8-10x the national average — across unrelated, often routine procedures. Stanford treats complex cases, which explains some markup. But basic cellulitis treatment shouldn't cost 8x the national average because a hospital also does transplants. The breadth across routine procedures points to pricing strategy, not just hard cases.

### 5. Some states' hospitals bill 6x what they collect
Nevada hospitals bill 6.4 times what they're actually paid — the biggest gap in the country. New Jersey: 6.2x. Florida: 5.9x. The bigger the gap, the more aggressive the billing culture.

### 6. What patients owe is a policy outcome, not a market outcome
The patient's share of the bill ranges from 9% in Maryland — the only state that sets hospital rates itself — to 23% in DC. Hospital supply doesn't explain it: Montana has just 13 hospitals and the cheapest patient costs in America, while DC's 7 hospitals are the most expensive for patients. Two patients with the same $16K hospital stay can owe $1,500 or $4,300 depending on the state line between them.

### 7. Some states are packed with for-profit hospitals
Half of Nevada's hospitals are for-profit — the highest share in the country. Florida (40%) and Texas (36%) follow. These are the same states with the biggest billing markups. The kind of hospitals a state has shapes how aggressively its hospitals bill.

### 8. But the billing aggression never reaches the patient
Here's the twist: states full of for-profit hospitals bill harder, but their patients don't pay more. Florida has the 2nd-most for-profit hospitals and some of the LOWEST patient costs ($1,669). Why? Medicare decides what patients owe using its own rate schedule, it ignores the hospital's bill entirely. The sticker-price fight happens between hospitals and insurers. The patient was never in the room.

---

## What I'd Tell a State Health Department

| Finding | What to do about it |
|---|---|
| Hospitals billing 8-10x average | Audit these specific hospitals first — investigator time is scarce, start where the signal is loudest |
| Worst hospitals cost most | Check whether geography and case mix explain it before assuming bad care causes high prices |
| Patient share varies 9%-23% by state | Study Maryland's rate-setting model — it produced near-lowest patient costs despite high total costs |
| Billing markup varies 2x-6x by state | Use the billing-to-payment ratio as an audit flag — a hospital asking 6x deserves more scrutiny than one asking 3x |

---

## The Dashboard

**[Interactive Tableau Dashboard →](https://public.tableau.com/app/profile/mitchell.egan/viz/MedicareCostandQualityAnalysis/Dashboard1)**

Four charts, one story:
1. **Cost vs quality scatter** — the headline finding in one picture
2. **Patient cost heatmap** — where in America patients pay most
3. **Ownership comparison** — for-profit billing behavior
4. **The outlier table** — hospitals charging 6x+, by name

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
│   ├── 07_patient_out_of_pocket.sql
│   ├── 08_ownership_mix_by_state.sql
│   └── 09_ownership_vs_cost.sql
├── data/
│   └── data_dictionary.md
├── findings/
│   └── detailed_findings.md
└── visualizations/
    ├── dashboard_screenshot.png
    └── tableau_link.md
```

---

## What This Project Shows About How I Work

- **I verify before I publish.** When early results suggested hospital supply drove patient costs, I tested the claim against all 50 states before including it, and the full data pointed to state policy instead. When another query showed impossible 40-to-1 ratios, I traced it to a many-to-many join silently multiplying rows, fixed the method, and pivoted when the data still wasn't comparable.
- **I know this domain.** Five years of research at Fred Hutchinson Cancer Center means I understand reserch data sets in the life sciences
- **I write for humans.** Every finding here is one paragraph a non-analyst can read.

---

## About

Built by Mitch Egan — transitioning from cancer research at Fred Hutchinson Cancer Center into data analytics.

[LinkedIn](https://www.linkedin.com/in/mitchegan/) · [GitHub](https://github.com/eganmit0330-lang) · [Tableau Public](https://public.tableau.com/app/profile/mitchell.egan/viz/MedicareCostandQualityAnalysis/Dashboard1)
