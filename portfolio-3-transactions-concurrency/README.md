# Portfolio 3 - Transactions and Concurrency

## Objective
This portfolio demonstrates transaction control and concurrency behaviour in the NovaTrust Digital Bank PostgreSQL database. All balances are synthetic. A banking database must keep related changes consistent, so these tests check that changes are either saved completely or not saved at all, and that two sessions do not interfere with each other.

## Control perspective
My professional background includes control testing and exception analysis. I applied the same mindset here by testing the expected behaviour first, then recording what the database actually did.

## Test 1 - COMMIT (successful transfer)
A transfer of 10,000 was made from account 0100000001 to account 0100000003 inside one transaction (BEGIN, debit, credit, COMMIT). Both changes were saved together.
- Script: sql/01_commit_demo.sql
- Evidence: output/01_commit_demo.log

## Test 2 - ROLLBACK
A further 10,000 debit was made on account 0100000001 inside a transaction, then cancelled.
- Balance before: 240,000.00
- Balance inside the transaction: 230,000.00
- Balance after ROLLBACK: 240,000.00
- Script: sql/02_rollback_demo.sql
- Evidence: output/02_rollback_demo.log

This shows that a failed or cancelled operation leaves no partial change behind.

## Test 3 - Concurrency (row locking)
Two psql sessions were used on the same account (0100000001).
1. Session A began a transaction and reduced the balance by 5,000 without committing.
2. Session B tried to reduce the same account by 3,000 and had to wait.
3. After Session A ran COMMIT, Session B's update completed (UPDATE 1).

The final balance was 232,000.00 (240,000 - 5,000 - 3,000). PostgreSQL's row lock made the second update wait for the first, so the two updates did not overwrite each other.

## Test 4 - Isolation (uncommitted changes are not visible)
1. Session A began a transaction and added 7,000 to account 0100000001 without committing. Session A saw 239,000.00.
2. Session B read the same account and saw 232,000.00, the last committed balance.
3. Session A ran ROLLBACK, so the temporary change was discarded.

This shows that Session B could not read Session A's uncommitted change (no dirty read). PostgreSQL's default isolation level is READ COMMITTED, and this test was run at that default.

## Evidence
| File | Purpose |
|---|---|
| sql/01_commit_demo.sql | COMMIT demonstration |
| sql/02_rollback_demo.sql | ROLLBACK demonstration |
| sql/03_concurrency_isolation_reference.sql | Steps run manually across two sessions |
| output/01_commit_demo.log, output/02_rollback_demo.log | Saved psql output |
| output/03_final_balances.txt | Final balances |
| screenshots/ | Screenshots of the two-session tests |

## Limitations
- The two-session tests were run by hand, so they are evidenced by screenshots, not by a single log file.
