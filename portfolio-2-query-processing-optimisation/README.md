# Portfolio 2 - Query Processing and Optimisation

## Objective

This portfolio demonstrates query processing and optimisation using the NovaTrust Digital Bank PostgreSQL database. The transaction table was expanded with 50,000 synthetic records, increasing the total number of transactions from 12 to 50,012 so that query performance could be tested on a larger dataset.

## Experiment 1 - Transaction Description Search

The first query searched for one specific transaction using the description column.

### Before optimisation
- Scan method: Sequential Scan
- Rows removed by filter: 50,011
- Execution time: 14.593 ms

PostgreSQL scanned the transaction table to locate the required record.

### Optimisation

An index was created on the description column:

CREATE INDEX idx_transaction_description
ON transaction_record(description);

### After optimisation
- Scan method: Index Scan
- Index used: idx_transaction_description
- Execution time: 0.317 ms

The execution plan changed from a Sequential Scan to an Index Scan. For the recorded runs, execution time reduced from 14.593 ms to 0.317 ms.

## Experiment 2 - Recent Transactions for an Account

The second query retrieved transactions for account_id 4 within the previous 30 days and ordered them by transaction date.

### Before optimisation
- Scan method: Sequential Scan
- Rows returned: 515
- Rows removed by filter: 49,497
- Execution time: 10.755 ms

### Optimisation

A composite index was created:

CREATE INDEX idx_transaction_account_date
ON transaction_record(account_id, created_at DESC);

### After optimisation
- Access method: Bitmap Heap Scan
- Supporting access method: Bitmap Index Scan
- Index used: idx_transaction_account_date
- Rows returned: 515
- Execution time: 1.456 ms

The recorded execution time reduced from 10.755 ms to 1.456 ms. The execution plan also changed from scanning the transaction table sequentially to using the composite index to identify the relevant records.

## Conclusion

The experiments demonstrate that appropriate indexes can improve query performance when queries frequently search particular columns. The description index improved a highly selective lookup, while the composite account/date index improved retrieval of recent transactions for a specific account.

The results are based on the recorded EXPLAIN ANALYZE executions in this local PostgreSQL test environment. Execution times may vary between runs depending on factors such as caching and system activity.
