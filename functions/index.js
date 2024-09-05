const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.cleanupDeletedNotes=functions.pubsub.schedule("every 24 hours").onRun(async(context)=>{
  const now = new Date();
  const cutoffDate = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);

  const notesRef = admin.firestore().collection("notes");
  const query=notesRef.where("deleted", "==", true).where("deletedAt", "<=", cutoffDate);
  const snapshot = await query.get();

  const batch = admin.firestore().batch();
  snapshot.forEach(doc => {
    batch.delete(doc.ref);
  });

  await batch.commit();
  console.log("Deleted notes older than 7 days have been removed.");
});
