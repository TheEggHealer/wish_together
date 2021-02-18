const functions = require("firebase-functions");

const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

exports.sendNotification = functions.https.onCall((data, context) => {
  console.log("Push notification event triggered");

  const tokens = data["tokens"];
  const title = data["title"];
  const body = data["body"];

  // Create a notification
  const payload = {
    notification: {
      title: title,
      body: body,
      sound: "default",
    },
  };

  // Create an options object that contains the time to
  // live for the notification and the priority
  const options = {
    priority: "high",
    timeToLive: 60 * 60 * 24,
  };

  return admin.messaging().sendToDevice(tokens, payload, options);
});

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
