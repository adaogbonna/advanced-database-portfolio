\echo '--- BEFORE TRANSFER ---'
SELECT account_number, balance
FROM account
WHERE account_number IN ('0100000001','0100000003')
ORDER BY account_number;

BEGIN;

UPDATE account
SET balance = balance - 10000
WHERE account_number = '0100000001';

UPDATE account
SET balance = balance + 10000
WHERE account_number = '0100000003';

COMMIT;

\echo '--- AFTER COMMIT ---'
SELECT account_number, balance
FROM account
WHERE account_number IN ('0100000001','0100000003')
ORDER BY account_number;
