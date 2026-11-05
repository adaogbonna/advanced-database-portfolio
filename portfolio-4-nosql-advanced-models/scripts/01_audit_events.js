use("novatrust_audit");

db.audit_events.deleteMany({});

db.audit_events.insertMany([
  {
    event_id: "EVT001",
    event_type: "LOGIN",
    actor: "user_demo01",
    timestamp: new Date(),
    result: "SUCCESS",
    metadata: {
      channel: "WEB",
      authentication_method: "PASSWORD"
    }
  },
  {
    event_id: "EVT002",
    event_type: "PRIVILEGED_DATABASE_ACCESS",
    actor: "admin_demo01",
    timestamp: new Date(),
    result: "SUCCESS",
    metadata: {
      database: "novatrust_db",
      access_method: "PAM",
      operation: "SELECT",
      request_reference: "REQ-10028"
    }
  },
  {
    event_id: "EVT003",
    event_type: "ACCOUNT_STATUS_CHANGE",
    actor: "control_demo01",
    timestamp: new Date(),
    result: "SUCCESS",
    metadata: {
      account_number: "0100000007",
      previous_status: "ACTIVE",
      new_status: "FROZEN",
      reason: "Synthetic control review"
    }
  },
  {
    event_id: "EVT004",
    event_type: "LOGIN",
    actor: "user_demo02",
    timestamp: new Date(),
    result: "FAILED",
    metadata: {
      channel: "MOBILE",
      authentication_method: "PASSWORD",
      failure_reason: "INVALID_CREDENTIALS"
    }
  }
]);

print("TOTAL AUDIT EVENTS");
print(db.audit_events.countDocuments({}));

print("PRIVILEGED DATABASE ACCESS EVENTS");
printjson(db.audit_events.findOne({event_type:"PRIVILEGED_DATABASE_ACCESS"}));

print("FAILED EVENTS");
db.audit_events.find({result:"FAILED"}).forEach(printjson);
