-- ============================================================
-- Week 01 | Exercise 03 | Wednesday
-- Topic: Window Functions
-- Database: bank_exercises
-- ============================================================

USE bank_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- Your manager wants a detailed transaction analysis report
-- for account 114 (Julia Souza's checking account).
--
-- Write a query that returns for each transaction:
--   - txn_id, txn_date, txn_type, direction, amount
--   - net_amount    → positive if direction = 'in',
--                     negative if direction = 'out'
--   - running_balance → cumulative net cash flow over time
--   - amount_rank   → rank of each transaction by amount
--                     (largest first) within the account
--   - prev_amount   → amount of the previous transaction
--                     on the same account
--
-- Business rules:
--   1. Only show transactions for account_id = 114
--   2. Order results chronologically by txn_date, then txn_id
--   3. running_balance accumulates from the first transaction
--
-- Expected columns:
--   txn_id | txn_date | txn_type | direction | amount |
--   net_amount | running_balance | amount_rank | prev_amount
--
-- Hints:
--   - CASE WHEN is your friend for net_amount
--   - SUM() OVER (...) for running_balance
--   - RANK() OVER (...) for amount_rank
--   - LAG() OVER (...) for prev_amount
--   - Think carefully about what goes inside OVER()
--
-- ─────────────────────────────────────────────────────────────

-- ─── My Query ────────────────────────────────────────────────
WITH transactions_clean AS (
	SELECT
		account_id,
		txn_id, 
		txn_date, 
		txn_type, 
		direction, 
		amount,
		CASE 
			WHEN direction = 'in' THEN amount 
			ELSE amount * -1 
		END AS net_amount		
	FROM
		transactions
	WHERE
		account_id = 114
)
SELECT         
	account_id,
	txn_id, 
	txn_date, 
	txn_type, 
	direction, 
	amount, 
    net_amount,
    SUM(net_amount) OVER (
		PARTITION BY account_id
        ORDER BY txn_date, txn_id
	) AS running_balance,
    RANK() OVER (
		PARTITION BY account_id
		ORDER BY amount DESC
    ) AS amount_rank,
    LAG(amount) OVER (
		PARTITION BY account_id
		ORDER BY txn_date, txn_id 
    )  AS prev_amount
FROM
	transactions_clean;


-- ─── Claude's SOLUTION (remove the /* and */ to uncomment) ───
/*
SELECT
    txn_id,
    account_id,
    txn_date,
    txn_type,
    direction,
    amount,
    CASE WHEN direction = 'in' THEN amount ELSE -amount END
        AS net_amount,
    SUM(CASE WHEN direction = 'in' THEN amount ELSE -amount END)
        OVER (
            PARTITION BY account_id
            ORDER BY txn_date, txn_id
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_balance,
    RANK()
        OVER (PARTITION BY account_id ORDER BY amount DESC)
        AS amount_rank,
    LAG(amount)
        OVER (PARTITION BY account_id ORDER BY txn_date, txn_id)
        AS prev_amount
FROM transactions
WHERE account_id = 114
ORDER BY txn_date, txn_id;
*/

-- ─── BONUS CHALLENGE ────────────────────────────────────────
--
-- Extend the query to work for ALL accounts, not just 114.
-- Add a column moving_avg_3 that shows the 3-transaction
-- moving average of amount for each account
-- (current row + 2 preceding rows).
--
-- Hint: AVG() OVER (... ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
--
-- Write your bonus query here: