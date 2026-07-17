-- ============================================================
-- Week 01 | Exercise 05 | Friday
-- Topic: Cohort Analysis
-- Database: bank_exercises
-- ============================================================

USE bank_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- The product team wants to understand how different customer
-- cohorts behave over time. A cohort is a group of customers
-- who joined in the same year.
--
-- Write a query that returns for each cohort (join year):
--   - cohort_year         → year the customers joined
--   - total_customers     → how many customers are in the cohort
--   - active_in_2024      → how many made at least one
--                           transaction in 2024
--   - retention_pct       → active_in_2024 / total_customers * 100
--                           rounded to 1 decimal place
--   - total_approved_loans → total number of approved loans
--                            across the cohort
--   - avg_loans_per_customer → total_approved_loans / total_customers
--                              rounded to 2 decimal places
--
-- Business rules:
--   1. Group customers by the year of their joined_date
--   2. A customer is active in 2024 if they have at least
--      one transaction in any of their accounts in 2024
--   3. Customers with no approved loans count as 0, not NULL
--   4. Sort by cohort_year ASC
--
-- Expected columns:
--   cohort_year | total_customers | active_in_2024 |
--   retention_pct | total_approved_loans | avg_loans_per_customer
--
-- Hints:
--   - Think in 3 CTEs: cohorts, active_2024, approved_loans
--   - YEAR() extracts the year from a date column
--   - DISTINCT is important when counting customers
--   - transactions links to customers via accounts, not directly
--   - LEFT JOIN your CTEs so cohorts with no activity still appear
--
-- ─────────────────────────────────────────────────────────────

-- ─── SOLUTION ────────────────────────────────────────────
WITH cohort AS (
	SELECT
        customer_id,
        YEAR(joined_date) AS cohort_year
	FROM customers
),

active_2024 AS (
	SELECT DISTINCT
		a.customer_id
	FROM accounts a
    JOIN transactions t
		ON a.account_id = t.account_id
	WHERE t.txn_date BETWEEN '2024-01-01' AND '2024-12-31'
),

approved_loans AS (
    SELECT
        customer_id,
        COUNT(*) AS num_approved_loans
	FROM loan_applications
    WHERE status = 'approved'
    GROUP BY customer_id
)

SELECT
	co.cohort_year,
    COUNT(DISTINCT co.customer_id) AS total_customers,
    COUNT(DISTINCT ac.customer_id) AS active_in_2024,
    ROUND(COUNT(DISTINCT ac.customer_id) / COUNT(DISTINCT co.customer_id) * 100, 1) AS retention_pct,
    COALESCE(SUM(al.num_approved_loans), 0) AS total_approved_loans,
    ROUND(COALESCE(SUM(al.num_approved_loans), 0) / COUNT(DISTINCT co.customer_id), 2) AS avg_loans_per_customer
FROM cohort co
LEFT JOIN active_2024 ac
	ON co.customer_id = ac.customer_id
LEFT JOIN approved_loans al
	ON co.customer_id = al.customer_id
GROUP BY co.cohort_year
ORDER BY co.cohort_year;