-- ============================================================
-- Week 02 | Exercise 02 | Tuesday
-- Topic: JOINs — Enrich Alerts with Customer Context
-- Database: fraud_exercises
-- ============================================================

USE fraud_exercises;

-- ─── EXERCISE ───────────────────────────────────────────────
--
-- The fraud investigation team needs a full alert report.
-- For each alert, they want to see the complete context:
-- who the customer is, what account was involved, and the
-- full transaction details behind the alert.
--
-- Write a query that returns for each alert:
--   - alert_id, alert_date, alert_type, severity, status
--   - reviewed_by
--   - txn_id, txn_date, txn_type, amount, device_type,
--     ip_country, merchant
--   - account_id, account_type, account status
--   - customer_id, full_name, segment, risk_score, is_blocked
--
-- Business rules:
--   1. Include ALL alerts, even if transaction or customer
--      data is somehow missing (think about JOIN type)
--   2. Sort by severity first (critical → high → medium → low)
--      then by alert_date ASC
--
-- Expected columns:
--   alert_id | alert_date | alert_type | severity | status |
--   reviewed_by | txn_id | txn_date | txn_type | amount |
--   device_type | ip_country | merchant | account_id |
--   account_type | account_status | customer_id | full_name |
--   segment | risk_score | is_blocked
--
-- ─────────────────────────────────────────────────────────────

-- Write your query here:

SELECT
    fal.alert_id, 
    fal.alert_date, 
    fal.alert_type, 
    fal.severity, 
    fal.status, 
    fal.reviewed_by, 
    ft.txn_id, 
    ft.txn_date, 
    ft.txn_type, 
    ft.amount, 
    ft.device_type, 
    ft.ip_country, 
    ft.merchant, 
    fac.account_id, 
    fac.account_type, 
    fac.status AS account_status, 
    fc.customer_id, 
    fc.full_name, 
    fc.segment, 
    fc.risk_score, 
    fc.is_blocked
FROM fraud_alerts fal
LEFT JOIN fraud_transactions ft
	ON fal.txn_id = ft.txn_id
LEFT JOIN fraud_accounts fac
    ON ft.account_id = fac.account_id
LEFT JOIN fraud_customers fc
    ON fac.customer_id = fc.customer_id
ORDER BY 
	CASE fal.severity
		WHEN 'critical' THEN 1
        WHEN 'high'     THEN 2
        WHEN 'medium'   THEN 3
        WHEN 'low'      THEN 4
	END,
		fal.alert_date ASC;