\echo '--- A. Customers, accounts, types and branches'
SELECT c.first_name || ' ' || c.last_name AS customer,
       a.account_number, t.type_name, b.branch_name, a.balance, a.status
FROM account a
JOIN customer c ON c.customer_id=a.customer_id
JOIN account_type t ON t.account_type_id=a.account_type_id
JOIN branch b ON b.branch_id=a.branch_id
ORDER BY a.account_number;

\echo '--- B. Transaction history for account 0100000001'
SELECT a.account_number, tr.transaction_type, tr.amount, tr.status, tr.description
FROM transaction_record tr
JOIN account a ON a.account_id=tr.account_id
WHERE a.account_number='0100000001'
ORDER BY tr.transaction_id;

\echo '--- C. Transfers with source and destination accounts'
SELECT t.transfer_reference, s.account_number AS source_account,
       d.account_number AS destination_account, t.amount, t.status
FROM transfer t
JOIN account s ON s.account_id=t.source_account_id
JOIN account d ON d.account_id=t.destination_account_id
ORDER BY t.transfer_id;

\echo '--- D. Successful deposits per branch'
SELECT b.branch_name, SUM(tr.amount) AS successful_deposit_total
FROM transaction_record tr
JOIN account a ON a.account_id=tr.account_id
JOIN branch b ON b.branch_id=a.branch_id
WHERE tr.transaction_type='DEPOSIT' AND tr.status='SUCCESS'
GROUP BY b.branch_name
ORDER BY successful_deposit_total DESC;

\echo '--- E1. Negative amount (expect chk_transaction_amount error)'
INSERT INTO transaction_record (account_id,transaction_type,amount,status)
SELECT account_id,'DEPOSIT',-500.00,'PENDING' FROM account WHERE account_number='0100000001';

\echo '--- E2. Invalid transaction type (expect chk_transaction_type error)'
INSERT INTO transaction_record (account_id,transaction_type,amount,status)
SELECT account_id,'CASHBACK',500.00,'PENDING' FROM account WHERE account_number='0100000001';

\echo '--- E3. Same source and destination (expect chk_different_accounts error)'
INSERT INTO transfer (transfer_reference,source_account_id,destination_account_id,amount)
SELECT 'TRF-BAD-0001',account_id,account_id,1000.00 FROM account WHERE account_number='0100000001';

\echo '--- E4. Duplicate email (expect unique violation)'
INSERT INTO customer (first_name,last_name,email,phone_number,date_of_birth)
VALUES ('Test','Duplicate','ada.eze@adaobimit.assessment','+2348000000099','1991-01-01');

\echo '--- E5. Customer does not exist (expect foreign key violation)'
INSERT INTO account (account_number,customer_id,account_type_id,branch_id)
VALUES ('0100000099',999999,1,1);

\echo '--- E6. Invalid account status (expect chk_account_status error)'
UPDATE account SET status='SUSPENDED' WHERE account_number='0100000001';
