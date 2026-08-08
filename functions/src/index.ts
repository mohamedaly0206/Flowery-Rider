import * as admin from "firebase-admin";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";

admin.initializeApp();

export const sendOrderStatusNotification = onDocumentUpdated(
  "orders/{orderId}",
  async (event) => {
    const beforeData = event.data?.before.data();
    const afterData = event.data?.after.data();

    if (!beforeData || !afterData) {
      console.log("No data found");
      return;
    }

    const previousStatus = beforeData.status;
    const currentStatus = afterData.status;

    // 1. Check if the status has actually changed
    if (previousStatus === currentStatus) {
      console.log("Status unchanged, ignoring.");
      return;
    }

    // 2. Extract the user ID from the order details
    // Based on the OrderDto structure: orderDetails.user._id
    const userId = afterData.orderDetails?.user?._id;

    if (!userId) {
      console.error("No user ID found in order details.");
      return;
    }

    try {
      // 3. Fetch the user's FCM token
      const userRef = admin.firestore().collection("users").doc(userId);
      const userDoc = await userRef.get();

      if (!userDoc.exists) {
        console.error(`User document not found for ID: ${userId}`);
        return;
      }

      const userData = userDoc.data();
      const fcmToken = userData?.fcmToken;

      const title = "Order Status Updated";
      const body = `Your order status is now: ${currentStatus}`;

      // 4. Save notification to users/{userId}/notifications
      const notificationsRef = userRef.collection("notifications");
      await notificationsRef.add({
        title: title,
        body: body,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isRead: false,
      });

      // 5. Send FCM push notification if token exists
      if (fcmToken) {
        const message = {
          notification: {
            title: title,
            body: body,
          },
          token: fcmToken,
        };

        await admin.messaging().send(message);
        console.log(`Successfully sent notification to user: ${userId}`);
      } else {
        console.log(`No FCM token found for user: ${userId}`);
      }
    } catch (error) {
      console.error("Error processing order status update:", error);
    }
  }
);