TRUNCATE TABLE transfer, transaction_record, account, customer, account_type, branch RESTART IDENTITY CASCADE;

INSERT INTO branch (branch_code, branch_name, city) VALUES
('LAG001','Victoria Island Branch','Lagos'),
('ABJ001','Wuse Branch','Abuja'),
('PHC001','GRA Branch','Port Harcourt');

INSERT INTO account_type (type_name, description) VALUES
('Savings','Personal savings account'),
('Current','Transactional current account');

INSERT INTO customer (first_name,last_name,email,phone_number,date_of_birth) VALUES
('Ada','Eze','ada.eze@adaobimit.assessment','+2348000000001','1990-03-14'),
('Tunde','Bello','tunde.bello@adaobimit.assessment','+2348000000002','1985-07-22'),
('Ngozi','Okafor','ngozi.okafor@adaobimit.assessment','+2348000000003','1992-11-05'),
('Musa','Danjuma','musa.danjuma@adaobimit.assessment','+2348000000004','1988-01-30'),
('Funke','Adeyemi','funke.adeyemi@adaobimit.assessment','+2348000000005','1995-09-18'),
('Chidi','Nwosu','chidi.nwosu@adaobimit.assessment','+2348000000006','1980-12-02');

INSERT INTO account (account_number,customer_id,account_type_id,branch_id,balance,status)
SELECT v.account_number,c.customer_id,t.account_type_id,b.branch_id,v.balance,v.status
FROM (VALUES
('0100000001','ada.eze@adaobimit.assessment','Savings','LAG001',250000.00,'ACTIVE'),
('0100000002','ada.eze@adaobimit.assessment','Current','LAG001',75000.00,'ACTIVE'),
('0100000003','tunde.bello@adaobimit.assessment','Current','LAG001',180000.00,'ACTIVE'),
('0100000004','ngozi.okafor@adaobimit.assessment','Savings','ABJ001',520000.00,'ACTIVE'),
('0100000005','musa.danjuma@adaobimit.assessment','Current','ABJ001',30000.00,'DORMANT'),
('0100000006','funke.adeyemi@adaobimit.assessment','Savings','PHC001',410000.00,'ACTIVE'),
('0100000007','chidi.nwosu@adaobimit.assessment','Current','PHC001',95000.00,'FROZEN'),
('0100000008','tunde.bello@adaobimit.assessment','Savings','LAG001',640000.00,'ACTIVE')
) AS v(account_number,email,type_name,branch_code,balance,status)
JOIN customer c ON c.email=v.email
JOIN account_type t ON t.type_name=v.type_name
JOIN branch b ON b.branch_code=v.branch_code;

INSERT INTO transaction_record (account_id,transaction_type,amount,status,description)
SELECT a.account_id,v.transaction_type,v.amount,v.status,v.description
FROM (VALUES
('0100000001','DEPOSIT',100000.00,'SUCCESS','Salary credit'),
('0100000001','WITHDRAWAL',20000.00,'SUCCESS','ATM withdrawal'),
('0100000002','DEPOSIT',50000.00,'SUCCESS','Cash deposit'),
('0100000003','WITHDRAWAL',15000.00,'SUCCESS','POS purchase'),
('0100000003','WITHDRAWAL',500000.00,'FAILED','Insufficient funds'),
('0100000004','DEPOSIT',300000.00,'SUCCESS','Business income'),
('0100000006','DEPOSIT',80000.00,'SUCCESS','Mobile deposit'),
('0100000006','WITHDRAWAL',10000.00,'PENDING','Awaiting processing'),
('0100000008','DEPOSIT',200000.00,'SUCCESS','Transfer in'),
('0100000001','TRANSFER',30000.00,'SUCCESS','Transfer out'),
('0100000003','TRANSFER',30000.00,'SUCCESS','Transfer in'),
('0100000004','TRANSFER',45000.00,'REVERSED','Reversed transfer')
) AS v(account_number,transaction_type,amount,status,description)
JOIN account a ON a.account_number=v.account_number;

INSERT INTO transfer (transfer_reference,source_account_id,destination_account_id,amount,status)
SELECT v.reference,s.account_id,d.account_id,v.amount,v.status
FROM (VALUES
('TRF-2026-0001','0100000001','0100000003',30000.00,'SUCCESS'),
('TRF-2026-0002','0100000004','0100000006',45000.00,'REVERSED'),
('TRF-2026-0003','0100000008','0100000002',60000.00,'SUCCESS'),
('TRF-2026-0004','0100000003','0100000004',999999.00,'FAILED')
) AS v(reference,source_account,destination_account,amount,status)
JOIN account s ON s.account_number=v.source_account
JOIN account d ON d.account_number=v.destination_account;

SELECT 'customer' AS table_name, COUNT(*) AS row_count FROM customer
UNION ALL SELECT 'branch',COUNT(*) FROM branch
UNION ALL SELECT 'account_type',COUNT(*) FROM account_type
UNION ALL SELECT 'account',COUNT(*) FROM account
UNION ALL SELECT 'transaction_record',COUNT(*) FROM transaction_record
UNION ALL SELECT 'transfer',COUNT(*) FROM transfer;
