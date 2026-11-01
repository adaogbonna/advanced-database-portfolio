# Portfolio 1 - Database Design and Modelling
NovaTrust Digital Bank (fictional).

# Portfolio 1 - Database Design and Modelling

**Course:** MIT 8103 Advanced Database Systems
**DBMS:** PostgreSQL 17 (local installation)
**Case study:** NovaTrust Digital Bank (fictional)

## 1. Case Study

NovaTrust Digital Bank is a fictional digital bank. It keeps records of customers, their accounts, the branches that maintain them, and the transactions and transfers made on those accounts. 
The database supports deposits, withdrawals and transfers between accounts, and lets staff and auditors review transaction history. 
NOTE : All data in this repository is synthetic. No real customer, bank or employer data is used.

## 2. Business Rules

| ID | Rule |
|---|---|
| BR01 | Every customer has a unique customer_id. |
| BR02 | A customer may own one or more accounts. |
| BR03 | Every account belongs to exactly one customer. Joint accounts are outside the scope of this model. |
| BR04 | Every account has a unique account number. |
| BR05 | Every account has exactly one account type, and one account type applies to many accounts. |
| BR06 | Every account is maintained by one branch, and one branch maintains many accounts. |
| BR07 | An account may have many transaction records. |
| BR08 | Transaction and transfer amounts must be greater than zero. |
| BR09 | Transaction type must be DEPOSIT, WITHDRAWAL or TRANSFER. |
| BR10 | Transaction and transfer status must be PENDING, SUCCESS, FAILED or REVERSED. |
| BR11 | Account status must be ACTIVE, DORMANT, FROZEN or CLOSED. |
| BR12 | Every transfer has a unique reference, a source account and a destination account. |
| BR13 | A transfer's source and destination cannot be the same account. |

## 3. Entities and Attributes

- **customer**: customer_id (PK), first_name, last_name, email (unique), phone_number (unique), date_of_birth, created_at
- **branch**: branch_id (PK), branch_code (unique), branch_name, city
- **account_type**: account_type_id (PK), type_name (unique), description
- **account**: account_id (PK), account_number (unique), customer_id (FK), account_type_id (FK), branch_id (FK), balance, status, opened_at
- **transaction_record**: transaction_id (PK), account_id (FK), transaction_type, amount, status, description, created_at
- **transfer**: transfer_id (PK), transfer_reference (unique), source_account_id (FK), destination_account_id (FK), amount, status, created_at

The transaction table is named `transaction_record`.

## 4. ER Model

Relationships:
- customer 1:M account
- account_type 1:M account
- branch 1:M account
- account 1:M transaction_record
- account 1:M transfer (as source)
- account 1:M transfer (as destination)

The ER diagram image is in `diagrams/`.

## 5. Relational Schema

The full schema is in `sql/01_create_tables.sql`. 
Foreign keys:
- account.customer_id references customer
- account.account_type_id references account_type
- account.branch_id references branch
- transaction_record.account_id references account
- transfer.source_account_id and transfer.destination_account_id reference account

## 6. Constraints Implemented

| Type | Examples |
|---|---|
| Primary key | One identity primary key per table |
| Foreign key | Account to customer, account type and branch; transaction and transfer to account |
| Unique | email, phone_number, account_number, branch_code, type_name, transfer_reference |
| NOT NULL | Required fields such as names, amounts and account numbers |
| CHECK | amount > 0; allowed values for type and status; source account is different from destination account |

## 7. Normalisation (1NF to 3NF)

**Unnormalised design.** One wide table holding customer, account, branch and transaction details would repeat customer and branch data on every transaction row. That causes update, insertion and deletion anomalies.

**1NF.** Every field holds one atomic value and there are no repeating groups. Each transaction is its own row with its own transaction_id.

**2NF.** Every non-key attribute depends on the whole key of its table. Customer details sit in customer, account details in account, and transaction details in transaction_record. Because each table has a single-column key, there are no partial dependencies.

**3NF.** Transitive dependencies are removed. In the wide design, account_id determines branch_id, and branch_id determines branch_code, branch_name and city. Branch details are therefore stored once in branch, and account keeps only branch_id. The same applies to account_type.

[The purpose of including normalisation is to avoid repitition and to stay optimal. Each piece of information is stored in only one table and in the event of a change, the change will only have to be applied once.]

**NOTE:** account.balance is stored directly for fast reads, although it could be derived from transaction history. This is deliberate and could be revisited in the optimisation portfolio. The sample balances are synthetic and are not reconciled to the sample transactions.

## 8. Implementation Evidence

| File | Purpose |
|---|---|
| `sql/01_create_tables.sql` | Creates six tables with keys and constraints |
| `sql/02_sample_data.sql` | Loads synthetic data: 6 customers, 3 branches, 2 account types, 8 accounts, 12 transactions, 4 transfers |
| `sql/03_validation_queries.sql` | Four relationship queries and six constraint tests |
| `output/` | Saved psql output for each script |
| `screenshots/` | Screenshots of tables, data, query results and constraint errors |

**Constraint tests.** All six intentionally invalid statements were rejected:

| Test | Result |
|---|---|
| Negative amount | Rejected by chk_transaction_amount |
| Invalid transaction type | Rejected by chk_transaction_type |
| Same source and destination | Rejected by chk_different_accounts |
| Duplicate email | Rejected by customer_email_key |
| Non-existent customer | Rejected by the account-to-customer foreign key |
| Invalid account status | Rejected by chk_account_status |

## 9. Reflection

[LESSON  LEARNED: The use and application of constraints and how it protects data quality when i inserted negative amount, or tried  transfer where the source and destination accounts were the same. 
PROBLEM ENCOUNTERED: On my first attempt to run an automated setup script for the installation of git and pgadmin on my pc, i kept getting errors ecause the file always seemed to be empty after saving it on my pc. I fixed this by manually running the commands directly on Powershell instead which meant i had to understand each step.
WHAT I WOULD IMPROVE: The balance column is stored directly and the sample balances are not reconciled with the sample transactions. In a real system I would keep the two consistent through transaction processing, which I plan to look at in the transactions portfolio. I would also add support for joint accounts using a separate linking table, and add indexes once I start optimising my queries.

*Use of AI.* I used an AI assistant to help draft the SQL, the commands and the README. I ran every command myself, checked the output against what I expected, and corrected errors as they came up.]