-- Portfolio 2: Query Processing and Optimisation
-- NovaTrust Digital Bank

-- Query used to locate one transaction by description
EXPLAIN ANALYZE
SELECT *
FROM transaction_record
WHERE description = 'Portfolio 2 synthetic transaction 40001';

-- Index created to optimise searches on description
CREATE INDEX IF NOT EXISTS idx_transaction_description
ON transaction_record(description);

ANALYZE transaction_record;
