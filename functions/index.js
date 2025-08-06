/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const axios = require("axios");
const admin = require('firebase-admin');
admin.initializeApp();

exports.createPaystackCheckout = functions.https.onRequest(async (req, res) => {
  const { email, amount } = req.body;

  try {
    const response = await axios.post(
      "https://api.paystack.co/transaction/initialize",
      {
        email: email,
        amount: amount * 100, // Paystack uses kobo
      },
      {
        headers: {
          Authorization: `sk_test_a294d99225b651bf973d93c1ae9d3d8fb735b038`,
          "Content-Type": "application/json",
        },
      }
    );

    const checkoutUrl = response.data.data.authorization_url;
    res.status(200).send({ checkoutUrl });
  } catch (error) {
    console.error("Paystack Error:", error.response.data);
    res.status(500).send({ error: "Failed to create Paystack checkout" });
  }
});

// Firestore database
const db = admin.firestore();

exports.processTransfer = functions.https.onCall(async (data, context) => {
  // Verify authentication
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }

  const { senderId, recipientId, amount, description, isInstant, timestamp } = data;

  // Validate input
  if (!senderId || !recipientId || !amount || !description) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Missing required fields'
    );
  }

  if (amount <= 0) {
    throw new functions.https.HttpsError(
      'invalid-argument',
      'Amount must be positive'
    );
  }

  // Get references to both accounts
  const senderRef = db.collection('accounts').doc(senderId);
  const recipientRef = db.collection('accounts').doc(recipientId);

  // Run transaction
  try {
    await db.runTransaction(async (transaction) => {
      const senderDoc = await transaction.get(senderRef);
      const recipientDoc = await transaction.get(recipientRef);

      // Check if accounts exist
      if (!senderDoc.exists || !recipientDoc.exists) {
        throw new functions.https.HttpsError(
          'not-found',
          'One or both accounts not found'
        );
      }

      const senderData = senderDoc.data();
      const recipientData = recipientDoc.data();

      // Check sufficient balance
      if (senderData.balance < amount) {
        throw new functions.https.HttpsError(
          'failed-precondition',
          'Insufficient funds'
        );
      }

      // Update balances
      const newSenderBalance = senderData.balance - amount;
      const newRecipientBalance = recipientData.balance + amount;

      transaction.update(senderRef, { balance: newSenderBalance });
      transaction.update(recipientRef, { balance: newRecipientBalance });

      // Record transaction
      const transferRef = db.collection('transfers').doc();
      transaction.set(transferRef, {
        senderId,
        recipientId,
        amount,
        description,
        isInstant,
        status: 'completed',
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        processedAt: timestamp,
      });
    });

    return { success: true, message: 'Transfer completed successfully' };
  } catch (error) {
    console.error('Transfer failed:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Transfer failed to process',
      error.message
    );
  }
});

exports.getTransferHistory = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      'unauthenticated',
      'User must be authenticated'
    );
  }

  const { userId } = data;

  try {
    const snapshot = await db.collection('transfers')
      .where('senderId', '==', userId)
      .orderBy('timestamp', 'desc')
      .limit(20)
      .get();

    return snapshot.docs.map(doc => doc.data());
  } catch (error) {
    console.error('Error getting transfer history:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to retrieve transfer history'
    );
  }
});