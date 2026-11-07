# Portfolio 4 - NoSQL and Advanced Data Models

## 1. Overview

For this portfolio, I extended the fictional NovaTrust Digital Bank case study by modelling security and audit events using MongoDB.

The main banking data, such as customers, accounts, transactions and transfers, remains in PostgreSQL because that information has clear relationships and requires strong integrity controls. MongoDB is used for audit-event data, where the information recorded can vary depending on the type of event.

All users, event references and audit records used in this portfolio are synthetic.

## 2. Why I Used a Document Database

Audit events do not always contain the same information.

For example, a login event may contain the authentication method and access channel, while a privileged database access event may contain the database name, operation performed, access method and request reference.

Trying to place every possible audit attribute into one relational table could result in many columns that are irrelevant or empty for particular event types.

A document model allows the common information to remain consistent while the event-specific details can be stored inside the metadata section of each document.

## 3. MongoDB Design

The MongoDB database is:

novatrust_audit

The collection is:

audit_events

Each document contains common fields:

- event_id
- event_type
- actor
- timestamp
- result
- metadata

The metadata field contains information specific to the event type.

## 4. Implemented Event Types

Four synthetic audit events were created.

### Login Event

The LOGIN event records information such as:

- access channel
- authentication method
- result

### Privileged Database Access Event

The PRIVILEGED_DATABASE_ACCESS event records:

- database accessed
- access method
- database operation
- request reference

For the synthetic example, the access method is PAM and the operation is SELECT.

### Account Status Change Event

The ACCOUNT_STATUS_CHANGE event records:

- account number
- previous status
- new status
- reason for the change

### Failed Login Event

A second LOGIN document demonstrates that documents with the same event type can still contain additional information when relevant. The failed login includes a failure_reason value.

## 5. Example Document

An example of the privileged-access document is:

{
  "event_id": "EVT002",
  "event_type": "PRIVILEGED_DATABASE_ACCESS",
  "actor": "admin_demo01",
  "result": "SUCCESS",
  "metadata": {
    "database": "novatrust_db",
    "access_method": "PAM",
    "operation": "SELECT",
    "request_reference": "REQ-10028"
  }
}

This example shows how event-specific information can be kept together in a single document.

## 6. Queries Tested

The implementation included queries to:

1. Count the audit-event documents.
2. Retrieve privileged database access events.
3. Retrieve events with a FAILED result.

The implementation returned a total of four synthetic audit events.

The privileged-access query successfully returned EVT002, while the failed-event query returned the synthetic failed login EVT004.

## 7. Relationship with the Relational Model

I did not replace the PostgreSQL database with MongoDB.

The two models are intended for different types of information.

PostgreSQL remains appropriate for customers, accounts, financial transactions and transfers because the relationships between these entities are structured and transaction integrity is important.

MongoDB is used for the audit-event component because the structure of the event-specific metadata can vary.

Using the two approaches in this way allowed me to apply the database model according to the type of data being stored rather than using NoSQL simply as a replacement for the relational database.

## 8. Professional Context

My choice of audit events for the NoSQL implementation was influenced by my previous exposure to control testing, log analysis and the review of system-generated information.

This made audit events a useful extension of the NovaTrust case study because they allow different types of technical and control-related activity to be represented without changing the core banking transaction model.

## 9. Evidence

The following files provide evidence of the implementation:

- scripts/01_audit_events.js - reproducible MongoDB implementation and queries
- output/01_audit_events_output.txt - actual output generated when the MongoDB script was executed
- screenshots/ - supporting screenshots where applicable

## 10. Conclusion

This portfolio demonstrated how a document-oriented NoSQL database can complement a relational banking database.

The exercise showed that PostgreSQL is suitable for highly structured financial information and transaction processing, while MongoDB provides flexibility for audit events whose metadata varies according to the type of activity being recorded.
