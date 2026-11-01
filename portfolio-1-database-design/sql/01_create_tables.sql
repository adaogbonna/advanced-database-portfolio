DROP TABLE IF EXISTS transfer CASCADE;
DROP TABLE IF EXISTS transaction_record CASCADE;
DROP TABLE IF EXISTS account CASCADE;
DROP TABLE IF EXISTS account_type CASCADE;
DROP TABLE IF EXISTS branch CASCADE;
DROP TABLE IF EXISTS customer CASCADE;

CREATE TABLE customer (
    customer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone_number VARCHAR(20) NOT NULL UNIQUE,
    date_of_birth DATE NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE branch (
    branch_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    branch_code VARCHAR(10) NOT NULL UNIQUE,
    branch_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL
);

CREATE TABLE account_type (
    account_type_id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
);

CREATE TABLE account (
    account_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    customer_id BIGINT NOT NULL REFERENCES customer(customer_id),
    account_type_id INT NOT NULL REFERENCES account_type(account_type_id),
    branch_id INT NOT NULL REFERENCES branch(branch_id),
    balance DECIMAL(18,2) NOT NULL DEFAULT 0.00,
    status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    opened_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_account_status CHECK (status IN ('ACTIVE','DORMANT','FROZEN','CLOSED'))
);

CREATE TABLE transaction_record (
    transaction_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    account_id BIGINT NOT NULL REFERENCES account(account_id),
    transaction_type VARCHAR(20) NOT NULL,
    amount DECIMAL(18,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    description VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_transaction_amount CHECK (amount > 0),
    CONSTRAINT chk_transaction_type CHECK (transaction_type IN ('DEPOSIT','WITHDRAWAL','TRANSFER')),
    CONSTRAINT chk_transaction_status CHECK (status IN ('PENDING','SUCCESS','FAILED','REVERSED'))
);

CREATE TABLE transfer (
    transfer_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    transfer_reference VARCHAR(40) NOT NULL UNIQUE,
    source_account_id BIGINT NOT NULL REFERENCES account(account_id),
    destination_account_id BIGINT NOT NULL REFERENCES account(account_id),
    amount DECIMAL(18,2) NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_transfer_amount CHECK (amount > 0),
    CONSTRAINT chk_different_accounts CHECK (source_account_id <> destination_account_id),
    CONSTRAINT chk_transfer_status CHECK (status IN ('PENDING','SUCCESS','FAILED','REVERSED'))
);

\dt
\d account
