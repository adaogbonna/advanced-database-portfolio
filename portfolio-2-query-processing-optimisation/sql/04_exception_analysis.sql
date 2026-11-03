-- Portfolio 2: Exception Analysis
-- Identifies accounts with a high volume of failed transactions.

SELECT
    account_id,
    COUNT(*) AS failed_transactions,
    SUM(amount) AS total_failed_value
FROM transaction_record
WHERE status = 'FAILED'
GROUP BY account_id
HAVING COUNT(*) >= 100
ORDER BY total_failed_value DESC;
