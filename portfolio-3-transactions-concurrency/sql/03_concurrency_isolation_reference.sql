-- Portfolio 3: Concurrency and Isolation (reference script)
-- These steps were run MANUALLY in two separate psql sessions (Session A and Session B).
-- Evidence is in the screenshots folder and in the other output logs.

-- TEST 1: ROW LOCKING
-- Session A:
BEGIN;
UPDATE account SET balance = balance - 5000 WHERE account_number = '0100000001';
-- (transaction left open)

-- Session B (while Session A is still open):
UPDATE account SET balance = balance - 3000 WHERE account_number = '0100000001';
-- Session B waited for Session A.

-- Session A:
COMMIT;
-- Session B's update then completed (UPDATE 1).

-- TEST 2: ISOLATION (no dirty reads)
-- Session A:
BEGIN;
UPDATE account SET balance = balance + 7000 WHERE account_number = '0100000001';
SELECT account_number, balance FROM account WHERE account_number = '0100000001';
-- Session A saw 239000.00 (uncommitted)

-- Session B:
SELECT account_number, balance FROM account WHERE account_number = '0100000001';
-- Session B saw 232000.00 (last committed value)

-- Session A:
ROLLBACK;
