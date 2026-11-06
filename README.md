# PesaPap Growth Analytics

## Project summary

This project combines SQLite business reporting, pandas customer analytics and a randomized onboarding experiment for the synthetic PesaPap Kenyan payments dataset. It creates a reproducible local database, answers the requested growth questions in SQL, builds KPI/RFM/cohort outputs, and estimates the experiment’s conversion impact with uncertainty made explicit.

## Data model and keys

| Table | Grain and key | Relationships |
| --- | --- | --- |
| `users` | One row per registered user; `user_id` is the primary key. | Referenced by `transactions.user_id` and `experiment.user_id`. Includes signup date, county and acquisition channel. |
| `transactions` | One row per payment; `txn_id` is the primary key. | `user_id` is a foreign key to `users.user_id`. Amounts are KES and dates are transaction dates. |
| `experiment` | One row per assigned experiment participant; `user_id` is the primary key and a foreign key to `users.user_id`. | `group` is A/control or B/simplified onboarding; `converted` is a 0/1 outcome. |

SQLite foreign-key enforcement is enabled when the notebook creates the database. Generated CSVs and `pesapap.db` are local, reproducible files and are excluded from Git.

## How to run

From the repository root:

1. Install dependencies: `python -m pip install -r requirements.txt`
2. Generate inputs: `python generate_data.py`
3. Open `pesapap_analysis.ipynb`, restart the kernel, and run every cell from top to bottom.

The notebook rebuilds `pesapap.db`, executes each documented query via `pd.read_sql`, prints KPI, RFM, cohort and experiment results, and generates the memo metrics.

## Headline recommendation

**Phase-roll out Group B with a randomized holdout.** In this seed-77 sample, B converted 13.81% (215/1,557) versus 10.46% (151/1,443) for A: +3.34 percentage points, +32.0% relative lift, chi-square p=0.0052 and approximate 95% CI [+1.01, +5.67] percentage points. At an assumed 3,000 sign-ups per month, that corresponds to about 100 incremental conversions monthly (scenario range about 30–170). This is synthetic evidence; verify the effect and downstream value on production data before full rollout.
