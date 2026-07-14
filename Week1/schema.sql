CREATE DATABASE IF NOT EXISTS bank_exercises;
USE bank_exercises;

-- Customers
CREATE TABLE customers (
    customer_id   INT PRIMARY KEY,
    full_name     VARCHAR(100),
    country       VARCHAR(50),
    segment       VARCHAR(20),   -- 'retail', 'premium', 'business'
    joined_date   DATE
);

-- Accounts
CREATE TABLE accounts (
    account_id    INT PRIMARY KEY,
    customer_id   INT,
    account_type  VARCHAR(20),   -- 'checking', 'savings', 'credit'
    balance       DECIMAL(15,2),
    opened_date   DATE,
    status        VARCHAR(10),   -- 'active', 'closed', 'frozen'
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions
CREATE TABLE transactions (
    txn_id        INT PRIMARY KEY,
    account_id    INT,
    txn_date      DATE,
    txn_type      VARCHAR(20),   -- 'deposit', 'withdrawal', 'transfer', 'fee'
    amount        DECIMAL(15,2), -- always positive
    direction     VARCHAR(4),    -- 'in' or 'out'
    description   VARCHAR(200),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- Loan applications
CREATE TABLE loan_applications (
    application_id  INT PRIMARY KEY,
    customer_id     INT,
    applied_date    DATE,
    loan_type       VARCHAR(30),  -- 'mortgage', 'personal', 'auto', 'business'
    requested_amount DECIMAL(15,2),
    status          VARCHAR(20),  -- 'approved', 'rejected', 'pending', 'withdrawn'
    approved_amount DECIMAL(15,2) NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ─── Seed data ───────────────────────────────────────────────

INSERT INTO customers VALUES
(1,  'Alice Moreau',      'France',    'premium',  '2018-03-15'),
(2,  'Bob Tremblay',      'Canada',    'retail',   '2020-07-01'),
(3,  'Carlos Vega',       'Mexico',    'business', '2017-11-20'),
(4,  'Diana Chen',        'Canada',    'premium',  '2019-04-10'),
(5,  'Evan Peters',       'USA',       'retail',   '2021-01-05'),
(6,  'Fatima Nour',       'Morocco',   'retail',   '2022-06-18'),
(7,  'George Lim',        'Singapore', 'business', '2016-09-30'),
(8,  'Hannah Smith',      'USA',       'premium',  '2018-12-01'),
(9,  'Ivan Petrov',       'Russia',    'retail',   '2023-02-14'),
(10, 'Julia Souza',       'Brazil',    'business', '2015-05-22');

INSERT INTO accounts VALUES
(101, 1,  'checking', 12400.00,  '2018-03-15', 'active'),
(102, 1,  'savings',  85000.00,  '2018-03-15', 'active'),
(103, 2,  'checking', 3200.50,   '2020-07-01', 'active'),
(104, 3,  'checking', 54000.00,  '2017-11-20', 'active'),
(105, 3,  'savings',  120000.00, '2017-11-20', 'active'),
(106, 4,  'savings',  67500.00,  '2019-04-10', 'active'),
(107, 5,  'checking', 890.00,    '2021-01-05', 'active'),
(108, 6,  'checking', 1500.00,   '2022-06-18', 'active'),
(109, 7,  'checking', 98000.00,  '2016-09-30', 'active'),
(110, 7,  'savings',  250000.00, '2016-09-30', 'active'),
(111, 8,  'checking', 22000.00,  '2018-12-01', 'active'),
(112, 8,  'credit',   -4500.00,  '2019-06-01', 'active'),
(113, 9,  'checking', 300.00,    '2023-02-14', 'active'),
(114, 10, 'checking', 75000.00,  '2015-05-22', 'active'),
(115, 10, 'savings',  310000.00, '2015-05-22', 'active'),
(116, 2,  'savings',  15000.00,  '2021-03-10', 'active'),
(117, 5,  'savings',  2500.00,   '2021-06-01', 'closed'),
(118, 4,  'credit',   -1200.00,  '2020-01-15', 'frozen');

INSERT INTO transactions VALUES
(1001, 101, '2024-01-05', 'deposit',    5000.00, 'in',  'Salary January'),
(1002, 101, '2024-01-10', 'withdrawal', 200.00,  'out', 'ATM withdrawal'),
(1003, 101, '2024-01-15', 'fee',        15.00,   'out', 'Monthly service fee'),
(1004, 102, '2024-01-06', 'deposit',    3000.00, 'in',  'Savings transfer'),
(1005, 103, '2024-01-07', 'deposit',    1200.00, 'in',  'Freelance payment'),
(1006, 103, '2024-01-20', 'withdrawal', 400.00,  'out', 'Grocery store'),
(1007, 104, '2024-01-03', 'deposit',    20000.00,'in',  'Business revenue'),
(1008, 104, '2024-01-25', 'withdrawal', 5000.00, 'out', 'Supplier payment'),
(1009, 105, '2024-01-08', 'deposit',    50000.00,'in',  'Investment returns'),
(1010, 107, '2024-01-12', 'deposit',    1000.00, 'in',  'Part-time job'),
(1011, 107, '2024-01-28', 'fee',        15.00,   'out', 'Monthly service fee'),
(1012, 109, '2024-01-04', 'deposit',    30000.00,'in',  'Business revenue'),
(1013, 109, '2024-01-18', 'transfer',   10000.00,'out', 'Wire to supplier'),
(1014, 110, '2024-01-09', 'deposit',    100000.00,'in', 'Investment fund'),
(1015, 111, '2024-01-11', 'deposit',    8000.00, 'in',  'Salary January'),
(1016, 111, '2024-01-22', 'withdrawal', 1500.00, 'out', 'Rent payment'),
(1017, 113, '2024-01-30', 'deposit',    500.00,  'in',  'Cash deposit'),
(1018, 114, '2024-01-05', 'deposit',    40000.00,'in',  'Business revenue'),
(1019, 114, '2024-01-15', 'withdrawal', 12000.00,'out', 'Payroll'),
(1020, 115, '2024-01-07', 'deposit',    80000.00,'in',  'Bond maturity'),
(1021, 101, '2024-02-05', 'deposit',    5000.00, 'in',  'Salary February'),
(1022, 103, '2024-02-07', 'deposit',    1200.00, 'in',  'Freelance payment'),
(1023, 107, '2024-02-10', 'withdrawal', 300.00,  'out', 'Online shopping'),
(1024, 109, '2024-02-03', 'deposit',    15000.00,'in',  'Business revenue'),
(1025, 114, '2024-02-05', 'deposit',    40000.00,'in',  'Business revenue'),
(1026, 114, '2024-02-15', 'withdrawal', 12000.00,'out', 'Payroll'),
(1027, 101, '2024-02-20', 'fee',        15.00,   'out', 'Monthly service fee'),
(1028, 108, '2024-02-01', 'deposit',    800.00,  'in',  'Remittance'),
(1029, 106, '2024-02-14', 'deposit',    5000.00, 'in',  'Bonus'),
(1030, 102, '2024-02-28', 'deposit',    3000.00, 'in',  'Savings transfer');

INSERT INTO loan_applications VALUES
(201, 1,  '2023-06-01', 'mortgage',  350000.00, 'approved',  340000.00),
(202, 2,  '2023-08-15', 'personal',  10000.00,  'approved',  10000.00),
(203, 3,  '2022-11-10', 'business',  500000.00, 'approved',  450000.00),
(204, 4,  '2024-01-20', 'auto',      35000.00,  'pending',   NULL),
(205, 5,  '2023-03-05', 'personal',  5000.00,   'rejected',  NULL),
(206, 6,  '2023-07-22', 'personal',  3000.00,   'rejected',  NULL),
(207, 7,  '2021-05-14', 'business',  1000000.00,'approved',  900000.00),
(208, 8,  '2023-09-30', 'mortgage',  600000.00, 'approved',  580000.00),
(209, 9,  '2024-02-01', 'personal',  2000.00,   'pending',   NULL),
(210, 10, '2020-03-18', 'business',  2000000.00,'approved',  1800000.00),
(211, 1,  '2024-02-10', 'auto',      28000.00,  'pending',   NULL),
(212, 3,  '2024-01-05', 'business',  750000.00, 'withdrawn', NULL);