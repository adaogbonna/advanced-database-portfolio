-- Portfolio 2: Account and Date Query Optimisation

-- Banking query: retrieve recent transactions for one account
EXPLAIN ANALYZE
SELECT *
FROM transaction_record
WHERE account_id = 4
  AND created_at >= CURRENT_TIMESTAMP - INTERVAL '30 days'
ORDER BY created_at DESC;

-- Composite index used to optimise account/date searches
CREATE INDEX IF NOT EXISTS idx_transaction_account_date
ON transaction_record(account_id, created_at DESC);

ANALYZE transaction_record;
