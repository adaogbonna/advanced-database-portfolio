\echo '--- BEFORE ROLLBACK TEST ---'
SELECT account_number, balance
FROM account
WHERE account_number = '0100000001';

BEGIN;

UPDATE account
SET balance = balance - 10000
WHERE account_number = '0100000001';

\echo '--- BALANCE INSIDE TRANSACTION ---'
SELECT account_number, balance
FROM account
WHERE account_number = '0100000001';

ROLLBACK;

\echo '--- BALANCE AFTER ROLLBACK ---'
SELECT account_number, balance
FROM account
WHERE account_number = '0100000001';
