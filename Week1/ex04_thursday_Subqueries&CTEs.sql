-- ============================================================
-- Week 01 | Exercise 04 | Thursday
-- Topic: Subqueries & CTEs
-- Database: bank_exercises
-- ============================================================

USE bank_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- The credit risk team needs a loan risk report.
-- For each customer with at least one loan application,
-- show a complete risk profile.
--
-- Write a query that returns for each customer:
--   - customer_id, full_name, segment
--   - total_applications → total number of loan applications
--   - approved_count     → how many were approved
--   - approval_rate_pct  → approved_count / total * 100
--                          rounded to 1 decimal place
--   - total_approved_amount → total amount approved
--                             (NULL applications count as 0)
--   - risk_label → classified as follows:
--       'High'   if approved_count = 0
--       'High'   if total_approved_amount > 500000
--       'Medium' if approval_rate_pct < 50
--                OR total_approved_amount BETWEEN 100000 AND 500000
--       'Low'    everything else
--
-- Business rules:
--   1. Only include customers who have at least one application
--   2. Customers with no approved loans must appear as 'High'
--   3. Sort by total_approved_amount DESC
--
-- Expected columns:
--   customer_id | full_name | segment | total_applications |
--   approved_count | approval_rate_pct | total_approved_amount |
--   risk_label
--
-- Hints:
--   - Use a first CTE to aggregate loan_applications
--   - Use a second CTE to join with customers and build
--     the risk_label with CASE WHEN
--   - COALESCE is your friend for NULL amounts
--   - Think about the order of conditions in CASE WHEN
--
-- ─────────────────────────────────────────────────────────────

-- ─── SOLUTION ────────────────────────────────────────────────
WITH loan_summary AS (
	SELECT
		customer_id, 
		COUNT(*) AS total_applications, 
		SUM(CASE WHEN status = 'approved' THEN 1 ELSE 0 END) AS approved_count
	FROM
		loan_applications
	GROUP BY
		customer_id
),

customer_risk AS (
	SELECT
	    c.customer_id,
        c.full_name,
        ls.total_applications,
        ls.approved_count
	FROM customers c
    JOIN loan_summary ls
        ON c.customer_id = ls.customer_id
)

SELECT *
FROM customer_risk
ORDER BY total_applications DESC;

