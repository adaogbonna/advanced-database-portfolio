db = db.getSiblingDB("novatrust_distributed");
printjson(
  db.replication_test.insertOne({
    event_id: "REP002",
    description: "Write after automatic failover",
    created_at: new Date()
  })
);
