db = db.getSiblingDB("novatrust_distributed");
printjson(db.replication_test.findOne({event_id:"REP002"}));
