# PesaPap Growth Memo

**To:** Head of Growth  
**Subject:** Simplified onboarding experiment and customer-growth priorities  
**Data:** Synthetic seed-77 cohort; 3,000 assigned users, transactions observed 15 Jan–13 Jun 2026

## Result

Variant B converted **215/1,557 users (13.81%)**, compared with **151/1,443 (10.46%)** for A. The absolute lift is **+3.34 percentage points** and relative lift **+32.0%**. The two-sided chi-square test gives **p = 0.0052**; the approximate 95% confidence interval for the absolute difference is **+1.01 to +5.67 percentage points**. The interval excludes zero, supporting a positive conversion effect in this generated experiment. Allocation was 48.1% A / 51.9% B; a 50/50 goodness-of-fit check gives p = 0.037, so record the modest imbalance and retain group-denominator rates in interpretation.

## Impact

At an assumed **3,000 sign-ups per month**, the observed lift implies about **100 additional conversions per month** (95% interval: approximately **30–170**). This is a scenario based on the sample effect, not a financial forecast. Eligible transaction value in the analyzed post-signup records is KES 10.96M across 8,263 payments and 2,716 active users; the latest June value is partial and fell 57.6% versus May, so it should not be read as a full-month trend.

## Recommendation

**Phase-roll out B to a monitored share of new sign-ups**, since conversion improvement is statistically supported in this simulated test. Preserve a randomized holdout, verify the experience across acquisition channels, and monitor first-payment rate, eligible transaction value, repeat usage and support/fraud signals before full rollout. For lifecycle work, test reactivation messaging first with the **544 At Risk High Frequency** users: they have prior repeat activity and KES 3.00M historical eligible value, so they offer a plausible recovery opportunity.

## Caveats

These are synthetic records, not PesaPap production evidence. The transaction generator produces **3,737 payments dated before signup**; these are left intact for audit but excluded from behavioral KPIs, RFM and cohorts. June data end on 13 June and are incomplete. The confidence interval is a large-sample Wald approximation; the experiment measures conversion, not downstream value or retention. The monthly impact assumes 3,000 sign-ups and a stable effect; implementation costs, margin, eligibility and sustained behavior are unknown. Validate the assignment and all decision metrics on production data before committing budget.
