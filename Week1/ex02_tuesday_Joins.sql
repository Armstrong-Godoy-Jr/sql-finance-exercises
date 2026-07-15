-- ============================================================
-- Week 01 | Exercise 02 | Tuesday
-- Topic: JOINs
-- Database: bank_exercises
-- ============================================================

USE bank_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- Your manager now wants a full transaction report for
-- January 2024 to review customer activity.
--
-- Write a query that returns for each transaction:
--   - full_name, segment         → from customers
--   - account_id, account_type,
--     account_status             → from accounts
--   - txn_id, txn_date, txn_type,
--     direction, amount,
--     description                → from transactions
--
-- Business rules:
--   1. Only include transactions from January 2024
--   2. Also include customers who have accounts but ZERO
--      transactions in that period (NULL transaction columns)
--   3. Sort by full_name, then txn_date
--
-- Expected columns:
--   full_name | segment | account_id | account_type |
--   account_status | txn_id | txn_date | txn_type |
--   direction | amount | description
--
-- Hint: think carefully about WHERE vs ON for the date filter
--       and which JOIN type preserves accounts with no activity
--
-- ─────────────────────────────────────────────────────────────

-- ─── MY QUERY ────────────────────────────────────────────────
SELECT
	c.full_name,
    c.segment,
    a.account_id,
    a.account_type,
    a.status,
    t.txn_id, 
    t.txn_date, 
    t.txn_type,
	t.direction, 
    t.amount,
	t.description 
FROM    
    customers c
JOIN
    accounts a 
		ON c.customer_id = a.customer_id
LEFT JOIN
    transactions t
		ON a.account_id = t.account_id AND
		YEAR(t.txn_date) = 2024 AND
		MONTH(t.txn_date) = 1
ORDER BY
	c.full_name, t.txn_date;

-- ─── SOLUTION (remove the /* and */ to uncomment) ───────────
/*
SELECT
    c.full_name,
    c.segment,
    a.account_id,
    a.account_type,
    a.status            AS account_status,
    t.txn_id,
    t.txn_date,
    t.txn_type,
    t.direction,
    t.amount,
    t.description
FROM customers c
JOIN accounts a
    ON c.customer_id = a.customer_id
LEFT JOIN transactions t
    ON a.account_id = t.account_id
    AND t.txn_date BETWEEN '2024-01-01' AND '2024-01-31'
ORDER BY c.full_name, t.txn_date;
*/

-- ─── BONUS CHALLENGE ────────────────────────────────────────
--
-- Extend the query to also show a summary column:
--   - total_in  → SUM of amounts where direction = 'in'
--                 for that account in January
--   - total_out → SUM of amounts where direction = 'out'
--                 for that account in January
--   - net_flow  → total_in - total_out
--
-- This should still show one row per transaction, with the
-- account totals repeated on each row (window functions are
-- the right tool here -- a preview of Wednesday!)
--
-- Write your bonus query here: