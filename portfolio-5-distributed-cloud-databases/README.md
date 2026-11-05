# Portfolio 5 - Distributed and Cloud Databases

## 1. Overview

This portfolio extends the fictional NovaTrust Digital Bank case study by demonstrating distributed database concepts using a local MongoDB replica set.

A three-node replica set was configured to demonstrate replication, availability, automatic failover and continued database operation after failure of the original PRIMARY.

All databases and records used in this exercise are synthetic.

## 2. Replica Set Design

The replica set was named `novatrustRS`.

Three MongoDB server instances were configured locally:

- Node 1: 127.0.0.1:27031
- Node 2: 127.0.0.1:27032
- Node 3: 127.0.0.1:27033

Each node used a separate data directory.

After initialisation:

- Port 27031 was PRIMARY
- Port 27032 was SECONDARY
- Port 27033 was SECONDARY

## 3. Replication Test

A synthetic document named `REP001` was written to the PRIMARY node on port 27031.

The same document was then queried directly from SECONDARY node 27032 and was returned successfully.

This demonstrated that data written to the PRIMARY was replicated to another member of the replica set.

## 4. Automatic Failover

To test availability, the MongoDB process serving the original PRIMARY on port 27031 was deliberately stopped.

The remaining nodes automatically held an election.

After the election:

- Port 27031 was unavailable
- Port 27032 remained SECONDARY
- Port 27033 became the new PRIMARY

No manual promotion of port 27033 was performed.

## 5. Write After Failover

After port 27033 was elected as the new PRIMARY, a second synthetic document called REP002 was inserted.

The write was acknowledged successfully by the new PRIMARY. REP002 was then queried directly from SECONDARY port 27032 and was returned successfully.

This demonstrated that the replica set remained writable after failover and that replication continued between the surviving members.

## 6. Consistency Considerations

Only the PRIMARY accepted writes during the tests, while the SECONDARY nodes maintained replicated copies of the data.

For a banking environment such as NovaTrust, this controlled write model is important because financial information should not be updated independently on different database nodes.

Secondary reads were used deliberately during this portfolio to verify that replication had occurred.

## 7. Relationship to NovaTrust

A digital banking platform requires database services to remain available even when an individual server becomes unavailable.

The NovaTrust test demonstrated that loss of one database node did not necessarily make the entire database service unavailable. After the original PRIMARY failed, another replica-set member was automatically elected and accepted new writes.

This implementation is a local technical simulation and does not represent a production banking architecture.

## 8. Cloud Database Context

The local replica set demonstrates concepts that are also relevant to managed cloud database environments.

In a cloud deployment, database nodes could be placed across separate infrastructure or availability zones rather than running as three processes on one computer.

Managed database platforms can additionally provide automated monitoring, backups, node replacement and failover.

## 9. Evidence

The Portfolio 5 folder contains:

- scripts/01_init_replica.js - replica-set configuration
- scripts/02_replication_test.js - initial replication test using REP001
- scripts/03_verify_replication.js - secondary verification of REP001
- scripts/04_post_failover_write.js - REP002 write after automatic failover
- scripts/05_verify_post_failover.js - secondary verification of REP002
- output/01_replica_status.txt - replica-set state before failure
- output/02_secondary_replication_check.txt - evidence that REP001 reached a secondary
- output/03_failover_status.txt - replica-set state after loss of the original PRIMARY
- output/04_post_failover_write.txt - acknowledged write after failover
- output/05_post_failover_replication.txt - evidence that REP002 reached the surviving secondary

## 10. Conclusion

This portfolio demonstrated a three-node MongoDB replica set, replication from PRIMARY to SECONDARY, automatic election after failure of the original PRIMARY, continued write availability through the newly elected PRIMARY, and continued replication after failover.

The exercise demonstrated how replication and automatic failover can contribute to database availability and resilience.
