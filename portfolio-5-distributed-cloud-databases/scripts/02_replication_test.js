db = db.getSiblingDB("novatrust_distributed");

db.replication_test.insertOne({
  event_id: "REP001",
  description: "NovaTrust replication test",
  created_at: new Date()
});
