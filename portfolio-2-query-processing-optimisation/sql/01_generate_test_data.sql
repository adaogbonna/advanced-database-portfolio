INSERT INTO transaction_record
    (account_id, transaction_type, amount, status, description, created_at)
SELECT
    ((g - 1) % 8) + 1,
    CASE
        WHEN g % 3 = 0 THEN 'DEPOSIT'
        WHEN g % 3 = 1 THEN 'WITHDRAWAL'
        ELSE 'TRANSFER'
    END,
    ((g % 50000) + 100)::numeric(18,2),
    CASE
        WHEN g % 20 = 0 THEN 'FAILED'
        WHEN g % 25 = 0 THEN 'PENDING'
        ELSE 'SUCCESS'
    END,
    'Portfolio 2 synthetic transaction ' || g,
    CURRENT_TIMESTAMP - ((g % 365) * INTERVAL '1 day')
FROM generate_series(1, 50000) AS g;

ANALYZE transaction_record;

SELECT COUNT(*) AS total_transactions
FROM transaction_record;
