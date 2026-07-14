-- ============================================================
-- Week 01 | Exercise 01 | Monday
-- Topic: Aggregations & Filtering
-- Database: bank_exercises
-- ============================================================

USUSE bank_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- You just joined the analytics team. Your manager asks for
-- a customer wealth summary report for a portfolio review.
--
-- Write a query that returns for each customer:
--   - customer_id, full_name, segment
--   - total_balance  → SUM of balance across active accounts
--   - num_accounts   → COUNT of active accounts
--   - avg_balance    → AVG balance per active account
--
-- Business rules:
--   1. Only count accounts with status = 'active'
--   2. Only show customers with total_balance > 10000
--   3. Round all monetary values to 2 decimal places
--   4. Sort from wealthiest to least wealthy
--
-- Expected columns:
--   customer_id | full_name | segment | total_balance | num_accounts | avg_balance
--
-- ─────────────────────────────────────────────────────────────

-- ─── MY QUERY ────────────────────────────────────────────────
SELECT
    c.customer_id,
    c.full_name,
    c.segment,
    ROUND(SUM(a.balance), 2) AS total_balance,
    COUNT(a.account_id) AS num_acounts,
    ROUND(AVG(a.balance), 2) AS avg_balance
FROM
    customers c JOIN accounts a ON c.customer_id = a.customer_id
WHERE
    a.status = 'active'
GROUP BY
    customer_id
HAVING
    SUM(a.balance) > 10000
ORDER BY
    total_balance DESC;

-- ─── CLAUDE'S SOLUTION ────────────────────────────────────────────────
SELECT
    c.customer_id,
    c.full_name,
    c.segment,
    ROUND(SUM(a.balance), 2)  AS total_balance,
    COUNT(a.account_id)       AS num_accounts,
    ROUND(AVG(a.balance), 2)  AS avg_balance
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
WHERE a.status = 'active'
GROUP BY c.customer_id, c.full_name, c.segment
HAVING SUM(a.balance) > 10000
ORDER BY total_balance DESC;