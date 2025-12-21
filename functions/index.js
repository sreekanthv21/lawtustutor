const admin = require("firebase-admin");
const functions = require("firebase-functions/v2");
const {CloudTasksClient} = require("@google-cloud/tasks");
const {DateTime} = require("luxon");
const cors = require("cors")({origin: true});
admin.initializeApp();
const client = new CloudTasksClient();
exports.scheduleWrite = functions.https.onRequest(async (req, res) => {
  cors(req, res, async () => {
    try {
      const {data1, data2} = req.body;
      const dateha1 = DateTime.fromISO(data1.time, {zone: "Asia/Kolkata"});
      const dateha2 = DateTime.fromISO(data2.time, {zone: "Asia/Kolkata"});

      const project = "lawtus-d033f";
      const queue = "scheduling-queue";
      const location = "us-central1";
      const url = `https://${location}-${project}.cloudfunctions.net/delayedWrite`;

      const parent = client.queuePath(project, location, queue);

      const task1 = {
        httpRequest: {
          httpMethod: "POST",
          url,
          headers: {"Content-Type": "application/json"},
          body: Buffer.from(JSON.stringify(data1)).toString("base64"),
        },
        scheduleTime: {
          seconds: Math.floor(dateha1.toSeconds()),
        }};

      const task2 = {
        httpRequest: {
          httpMethod: "POST",
          url,
          headers: {"Content-Type": "application/json"},
          body: Buffer.from(JSON.stringify(data2)).toString("base64"),
        },
        scheduleTime: {
          seconds: Math.floor(dateha2.toSeconds()),
        },
      };

      await client.createTask({parent, task: task1});
      await client.createTask({parent, task: task2});

      res.send("Task scheduled");
    } catch (err) {
      console.error("Task scheduling error:", err);
      res.status(500).send("Failed to schedule task");
    }
  });
});

exports.delayedWrite = functions.https.onRequest(async (req, res) => {
  await admin.firestore().collection("tests").doc(req.body.quizid).update({
    "status": req.body.status,
    "executedAt": admin.firestore.FieldValue.serverTimestamp(),
  });

  res.send("Document written");
});

exports.delayedWrite = functions.https.onRequest(async (req, res) => {
  await admin.firestore().collection("tests").doc(req.body.quizid).update({
    "status": req.body.status,
    "executedAt": admin.firestore.FieldValue.serverTimestamp(),
  });

  res.send("Document written");
});