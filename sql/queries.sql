-- Validation: How many transaction records predate the signup date of the user who made them?
SELECT COUNT(*) AS transactions_before_signup
FROM transactions AS t
JOIN users AS u ON u.user_id = t.user_id
WHERE date(t.txn_date) < date(u.signup_date);

-- Question a: What are the transaction count and total transaction value for each product?
SELECT product, COUNT(*) AS transaction_count, SUM(amount) AS total_value_kes
FROM transactions
GROUP BY product
ORDER BY total_value_kes DESC;

-- Question b: Which five counties generated the greatest transaction value?
SELECT u.county, SUM(t.amount) AS total_value_kes
FROM transactions AS t
JOIN users AS u ON u.user_id = t.user_id
GROUP BY u.county
ORDER BY total_value_kes DESC
LIMIT 5;

-- Question c: What is monthly transaction value and its cumulative running total?
WITH monthly_value AS (
    SELECT strftime('%Y-%m', txn_date) AS month, SUM(amount) AS transaction_value_kes
    FROM transactions
    GROUP BY strftime('%Y-%m', txn_date)
)
SELECT month, transaction_value_kes,
       SUM(transaction_value_kes) OVER (
           ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
       ) AS running_total_kes
FROM monthly_value
ORDER BY month;

-- Question d: How much transaction value is associated with each user's acquisition channel?
SELECT u.acquisition_channel, SUM(t.amount) AS total_value_kes, COUNT(*) AS transaction_count
FROM transactions AS t
JOIN users AS u ON u.user_id = t.user_id
GROUP BY u.acquisition_channel
ORDER BY total_value_kes DESC;

-- Question e: Who are the ten highest-value transacting users, using RANK() to preserve ties?
WITH user_value AS (
    SELECT user_id, SUM(amount) AS total_value_kes
    FROM transactions
    GROUP BY user_id
), ranked_users AS (
    SELECT user_id, total_value_kes,
           RANK() OVER (ORDER BY total_value_kes DESC) AS value_rank
    FROM user_value
)
SELECT user_id, total_value_kes, value_rank
FROM ranked_users
WHERE value_rank <= 10
ORDER BY value_rank, user_id;

-- Question f: Which products have average transaction amount greater than KES 1,300?
SELECT product, AVG(amount) AS average_transaction_kes, COUNT(*) AS transaction_count
FROM transactions
GROUP BY product
HAVING AVG(amount) > 1300
ORDER BY average_transaction_kes DESC;

-- Question g: How many transacting users fall into High, Medium, and Low lifetime-value tiers?
WITH user_value AS (
    SELECT user_id, SUM(amount) AS total_value_kes
    FROM transactions
    GROUP BY user_id
), value_tiers AS (
    SELECT user_id,
           CASE WHEN total_value_kes >= 10000 THEN 'High'
                WHEN total_value_kes >= 4000 THEN 'Medium'
                ELSE 'Low' END AS value_tier
    FROM user_value
)
SELECT value_tier, COUNT(*) AS user_count
FROM value_tiers
GROUP BY value_tier
ORDER BY CASE value_tier WHEN 'High' THEN 1 WHEN 'Medium' THEN 2 ELSE 3 END;

-- Question h: How does the number of active users change month over month?
WITH monthly_active AS (
    SELECT strftime('%Y-%m', txn_date) AS month,
           COUNT(DISTINCT user_id) AS active_users
    FROM transactions
    GROUP BY strftime('%Y-%m', txn_date)
), active_with_lag AS (
    SELECT month, active_users,
           LAG(active_users) OVER (ORDER BY month) AS previous_month_active_users
    FROM monthly_active
)
SELECT month, active_users, previous_month_active_users,
       active_users - previous_month_active_users AS change_in_active_users,
       CASE WHEN previous_month_active_users IS NULL THEN NULL
            WHEN previous_month_active_users = 0 THEN NULL
            ELSE 100.0 * (active_users - previous_month_active_users)
                 / previous_month_active_users END AS mom_change_pct
FROM active_with_lag
ORDER BY month;
