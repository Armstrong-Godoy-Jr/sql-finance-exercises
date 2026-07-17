-- ============================================================
-- Week 02 | Fraud Detection
-- Schema & Seed Data
-- Database: fraud_exercises
-- ============================================================

CREATE DATABASE IF NOT EXISTS fraud_exercises;
USE fraud_exercises;

-- ─── DROP TABLES (safe re-run) ───────────────────────────────
DROP TABLE IF EXISTS fraud_alerts;
DROP TABLE IF EXISTS fraud_transactions;
DROP TABLE IF EXISTS fraud_accounts;
DROP TABLE IF EXISTS fraud_customers;

-- ─── CREATE TABLES ───────────────────────────────────────────

CREATE TABLE fraud_customers (
    customer_id     INT PRIMARY KEY,
    full_name       VARCHAR(100),
    country         VARCHAR(50),
    segment         VARCHAR(20),    -- 'retail', 'premium', 'business'
    joined_date     DATE,
    risk_score      DECIMAL(4,2),   -- 0.00 to 10.00, higher = riskier
    is_blocked      BOOLEAN         -- TRUE if account is blocked
);

CREATE TABLE fraud_accounts (
    account_id      INT PRIMARY KEY,
    customer_id     INT,
    account_type    VARCHAR(20),    -- 'checking', 'savings', 'credit'
    balance         DECIMAL(15,2),
    opened_date     DATE,
    status          VARCHAR(10),    -- 'active', 'closed', 'frozen'
    FOREIGN KEY (customer_id) REFERENCES fraud_customers(customer_id)
);

CREATE TABLE fraud_transactions (
    txn_id          INT PRIMARY KEY,
    account_id      INT,
    txn_date        DATETIME,       -- includes time, not just date
    txn_type        VARCHAR(20),    -- 'purchase', 'withdrawal', 'transfer', 'deposit'
    amount          DECIMAL(15,2),
    direction       VARCHAR(4),     -- 'in' or 'out'
    merchant        VARCHAR(100),
    device_type     VARCHAR(20),    -- 'mobile', 'web', 'atm', 'pos'
    ip_country      VARCHAR(50),    -- country of the IP used
    is_flagged      BOOLEAN,        -- TRUE if auto-flagged by rules engine
    FOREIGN KEY (account_id) REFERENCES fraud_accounts(account_id)
);

CREATE TABLE fraud_alerts (
    alert_id        INT PRIMARY KEY,
    txn_id          INT,
    alert_date      DATE,
    alert_type      VARCHAR(50),    -- 'velocity', 'geo_anomaly', 'large_amount', 'unusual_device'
    severity        VARCHAR(10),    -- 'low', 'medium', 'high', 'critical'
    status          VARCHAR(20),    -- 'open', 'resolved', 'false_positive'
    reviewed_by     VARCHAR(50),
    FOREIGN KEY (txn_id) REFERENCES fraud_transactions(txn_id)
);

-- ─── SEED DATA ───────────────────────────────────────────────

INSERT INTO fraud_customers VALUES
(1,  'Alice Moreau',    'France',      'premium',  '2018-03-15', 2.10, FALSE),
(2,  'Bob Tremblay',    'Canada',      'retail',   '2020-07-01', 4.50, FALSE),
(3,  'Carlos Vega',     'Mexico',      'business', '2017-11-20', 7.80, TRUE),
(4,  'Diana Chen',      'Canada',      'premium',  '2019-04-10', 1.90, FALSE),
(5,  'Evan Peters',     'USA',         'retail',   '2021-01-05', 6.30, FALSE),
(6,  'Fatima Nour',     'Morocco',     'retail',   '2022-06-18', 5.50, FALSE),
(7,  'George Lim',      'Singapore',   'business', '2016-09-30', 3.20, FALSE),
(8,  'Hannah Smith',    'USA',         'premium',  '2018-12-01', 2.80, FALSE),
(9,  'Ivan Petrov',     'Russia',      'retail',   '2023-02-14', 8.90, TRUE),
(10, 'Julia Souza',     'Brazil',      'business', '2015-05-22', 3.60, FALSE),
(11, 'Kevin Marsh',     'UK',          'retail',   '2021-08-10', 7.10, FALSE),
(12, 'Lena Fischer',    'Germany',     'premium',  '2019-11-25', 1.50, FALSE),
(13, 'Marco Rossi',     'Italy',       'business', '2016-04-18', 4.20, FALSE),
(14, 'Nina Patel',      'India',       'retail',   '2022-09-03', 6.80, FALSE),
(15, 'Omar Hassan',     'UAE',         'premium',  '2020-01-12', 3.90, FALSE);

INSERT INTO fraud_accounts VALUES
(101, 1,  'checking', 12400.00,  '2018-03-15', 'active'),
(102, 2,  'checking', 3200.50,   '2020-07-01', 'active'),
(103, 3,  'checking', 500.00,    '2017-11-20', 'frozen'),
(104, 4,  'savings',  67500.00,  '2019-04-10', 'active'),
(105, 5,  'checking', 890.00,    '2021-01-05', 'active'),
(106, 6,  'checking', 1500.00,   '2022-06-18', 'active'),
(107, 7,  'checking', 98000.00,  '2016-09-30', 'active'),
(108, 8,  'checking', 22000.00,  '2018-12-01', 'active'),
(109, 9,  'checking', 300.00,    '2023-02-14', 'frozen'),
(110, 10, 'checking', 75000.00,  '2015-05-22', 'active'),
(111, 11, 'checking', 4200.00,   '2021-08-10', 'active'),
(112, 12, 'savings',  89000.00,  '2019-11-25', 'active'),
(113, 13, 'checking', 31000.00,  '2016-04-18', 'active'),
(114, 14, 'checking', 950.00,    '2022-09-03', 'active'),
(115, 15, 'checking', 18500.00,  '2020-01-12', 'active'),
(116, 3,  'savings',  200.00,    '2018-05-10', 'frozen'),
(117, 9,  'savings',  100.00,    '2023-03-01', 'frozen'),
(118, 5,  'savings',  1200.00,   '2021-06-01', 'active');

INSERT INTO fraud_transactions VALUES
(1001, 101, '2024-01-05 08:23:00', 'purchase',    250.00,   'out', 'Amazon',           'mobile', 'France',    FALSE),
(1002, 101, '2024-01-05 08:45:00', 'purchase',    4800.00,  'out', 'Apple Store',       'mobile', 'Romania',   TRUE),
(1003, 101, '2024-01-05 09:10:00', 'withdrawal',  1000.00,  'out', NULL,                'atm',    'Romania',   TRUE),
(1004, 102, '2024-01-06 14:00:00', 'purchase',    120.00,   'out', 'Walmart',           'pos',    'Canada',    FALSE),
(1005, 102, '2024-01-06 14:35:00', 'transfer',    5000.00,  'out', NULL,                'web',    'Nigeria',   TRUE),
(1006, 103, '2024-01-07 03:15:00', 'withdrawal',  500.00,   'out', NULL,                'atm',    'Mexico',    TRUE),
(1007, 104, '2024-01-08 11:00:00', 'purchase',    89.00,    'out', 'Netflix',           'web',    'Canada',    FALSE),
(1008, 105, '2024-01-09 22:47:00', 'purchase',    3200.00,  'out', 'Crypto Exchange',   'web',    'Russia',    TRUE),
(1009, 105, '2024-01-09 22:51:00', 'purchase',    3100.00,  'out', 'Crypto Exchange',   'web',    'Russia',    TRUE),
(1010, 106, '2024-01-10 09:00:00', 'deposit',     800.00,   'in',  NULL,                'mobile', 'Morocco',   FALSE),
(1011, 107, '2024-01-11 10:30:00', 'purchase',    450.00,   'out', 'Singapore Airlines','web',    'Singapore', FALSE),
(1012, 107, '2024-01-11 10:45:00', 'transfer',    15000.00, 'out', NULL,                'web',    'Singapore', FALSE),
(1013, 108, '2024-01-12 07:15:00', 'purchase',    199.00,   'out', 'Spotify',           'mobile', 'USA',       FALSE),
(1014, 109, '2024-01-13 02:30:00', 'withdrawal',  300.00,   'out', NULL,                'atm',    'Ukraine',   TRUE),
(1015, 110, '2024-01-14 13:00:00', 'purchase',    5500.00,  'out', 'Luxury Watches',    'web',    'Brazil',    TRUE),
(1016, 111, '2024-01-15 16:20:00', 'purchase',    75.00,    'out', 'Uber',              'mobile', 'UK',        FALSE),
(1017, 112, '2024-01-16 09:45:00', 'purchase',    320.00,   'out', 'Zalando',           'web',    'Germany',   FALSE),
(1018, 113, '2024-01-17 11:00:00', 'transfer',    8000.00,  'out', NULL,                'web',    'Italy',     FALSE),
(1019, 114, '2024-01-18 23:55:00', 'purchase',    2800.00,  'out', 'Unknown Merchant',  'mobile', 'Nigeria',   TRUE),
(1020, 115, '2024-01-19 08:00:00', 'purchase',    340.00,   'out', 'Carrefour',         'pos',    'UAE',       FALSE),
(1021, 101, '2024-01-20 03:22:00', 'transfer',    9500.00,  'out', NULL,                'web',    'China',     TRUE),
(1022, 102, '2024-01-21 15:10:00', 'purchase',    60.00,    'out', 'Tim Hortons',       'pos',    'Canada',    FALSE),
(1023, 105, '2024-01-22 08:30:00', 'deposit',     500.00,   'in',  NULL,                'mobile', 'USA',       FALSE),
(1024, 108, '2024-01-23 14:00:00', 'purchase',    4200.00,  'out', 'Jewelry Store',     'pos',    'UAE',       TRUE),
(1025, 110, '2024-01-24 09:30:00', 'purchase',    180.00,   'out', 'Mercado Livre',     'mobile', 'Brazil',    FALSE),
(1026, 111, '2024-01-25 21:45:00', 'withdrawal',  1500.00,  'out', NULL,                'atm',    'France',    TRUE),
(1027, 112, '2024-01-26 10:00:00', 'purchase',    540.00,   'out', 'MediaMarkt',        'web',    'Germany',   FALSE),
(1028, 113, '2024-01-27 12:30:00', 'purchase',    290.00,   'out', 'Eataly',            'pos',    'Italy',     FALSE),
(1029, 114, '2024-01-28 01:10:00', 'withdrawal',  900.00,   'out', NULL,                'atm',    'Ghana',     TRUE),
(1030, 115, '2024-01-29 07:45:00', 'purchase',    210.00,   'out', 'Noon',              'mobile', 'UAE',       FALSE),
(1031, 101, '2024-02-01 09:00:00', 'purchase',    95.00,    'out', 'Monoprix',          'pos',    'France',    FALSE),
(1032, 102, '2024-02-02 18:30:00', 'purchase',    3800.00,  'out', 'Electronics Store', 'web',    'China',     TRUE),
(1033, 104, '2024-02-03 11:15:00', 'purchase',    145.00,   'out', 'Indigo',            'pos',    'Canada',    FALSE),
(1034, 105, '2024-02-04 23:40:00', 'purchase',    2700.00,  'out', 'Crypto Exchange',   'web',    'Russia',    TRUE),
(1035, 107, '2024-02-05 10:00:00', 'purchase',    600.00,   'out', 'Lazada',            'mobile', 'Singapore', FALSE),
(1036, 108, '2024-02-06 08:30:00', 'purchase',    155.00,   'out', 'Whole Foods',       'pos',    'USA',       FALSE),
(1037, 110, '2024-02-07 14:20:00', 'transfer',    12000.00, 'out', NULL,                'web',    'Brazil',    FALSE),
(1038, 111, '2024-02-08 02:15:00', 'purchase',    3500.00,  'out', 'Unknown Merchant',  'mobile', 'Romania',   TRUE),
(1039, 112, '2024-02-09 09:00:00', 'purchase',    480.00,   'out', 'Douglas',           'web',    'Germany',   FALSE),
(1040, 115, '2024-02-10 11:30:00', 'purchase',    890.00,   'out', 'Harvey Nichols',    'web',    'UK',        FALSE);

INSERT INTO fraud_alerts VALUES
(501, 1002, '2024-01-05', 'geo_anomaly',     'high',     'open',           'system'),
(502, 1003, '2024-01-05', 'geo_anomaly',     'critical', 'open',           'system'),
(503, 1005, '2024-01-06', 'geo_anomaly',     'critical', 'resolved',       'analyst_1'),
(504, 1006, '2024-01-07', 'unusual_device',  'medium',   'false_positive', 'analyst_2'),
(505, 1008, '2024-01-09', 'velocity',        'high',     'open',           'system'),
(506, 1009, '2024-01-09', 'velocity',        'high',     'open',           'system'),
(507, 1014, '2024-01-13', 'geo_anomaly',     'critical', 'resolved',       'analyst_1'),
(508, 1015, '2024-01-14', 'large_amount',    'high',     'open',           'system'),
(509, 1019, '2024-01-18', 'geo_anomaly',     'critical', 'open',           'system'),
(510, 1021, '2024-01-20', 'geo_anomaly',     'critical', 'open',           'system'),
(511, 1024, '2024-01-23', 'large_amount',    'high',     'resolved',       'analyst_2'),
(512, 1026, '2024-01-25', 'geo_anomaly',     'medium',   'false_positive', 'analyst_1'),
(513, 1029, '2024-01-28', 'geo_anomaly',     'critical', 'open',           'system'),
(514, 1032, '2024-02-02', 'geo_anomaly',     'high',     'open',           'system'),
(515, 1034, '2024-02-04', 'velocity',        'high',     'open',           'system'),
(516, 1038, '2024-02-08', 'unusual_device',  'high',     'open',           'system');