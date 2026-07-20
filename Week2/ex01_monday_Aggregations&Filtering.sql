-- ============================================================
-- Week 02 | Exercise 01 | Monday
-- Topic: Aggregations & Filtering — Fraud Overview Report
-- Database: fraud_exercises
-- ============================================================

USE fraud_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- The fraud team needs a daily overview report to understand
-- the scale of suspicious activity across all customers.
--
-- Write a query that returns for each customer:
--   - customer_id, full_name, segment, risk_score
--   - total_transactions   → total number of transactions
--   - flagged_transactions → number of transactions where
--                            is_flagged = TRUE
--   - flagged_rate_pct     → flagged / total * 100
--                            rounded to 1 decimal place
--   - total_amount_out     → SUM of amount where direction = 'out'
--                            rounded to 2 decimal places
--
-- Business rules:
--   1. Only include customers with at least 1 flagged transaction
--   2. Sort by flagged_rate_pct DESC, then risk_score DESC
--
-- Expected columns:
--   customer_id | full_name | segment | risk_score |
--   total_transactions | flagged_transactions |
--   flagged_rate_pct | total_amount_out
--
-- ─────────────────────────────────────────────────────────────

-- Write your query here:

SELECT
	fc.customer_id,
    fc.full_name,
    fc.segment,
    fc.risk_score,
	COUNT(ft.txn_id) AS total_transaction, 
	SUM(CASE WHEN ft.is_flagged = TRUE THEN 1 ELSE 0 END) AS flagged_transactions,
	ROUND((SUM(CASE WHEN ft.is_flagged = TRUE THEN 1 ELSE 0 END)/COUNT(ft.txn_id)) * 100, 1) AS flagged_rate_pct,
    ROUND(SUM(CASE WHEN direction = 'out' THEN ft.amount ELSE 0 END), 2) AS total_amount_out
FROM fraud_customers fc
JOIN fraud_accounts fa 
	ON fc.customer_id = fa.customer_id
JOIN fraud_transactions ft 
	ON fa.account_id = ft.account_id
GROUP BY
	fc.customer_id,
    fc.full_name,
    fc.segment,
    fc.risk_score
HAVING
	SUM(CASE WHEN ft.is_flagged = TRUE THEN 1 ELSE 0 END) >= 1
ORDER BY
	flagged_rate_pct DESC, fc.risk_score DESC;

