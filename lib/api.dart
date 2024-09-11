import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:note/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    
    // Get the FCM token asynchronously
    String? token = await _firebaseMessaging.getToken();
    
    // Print the token
    if (token != null) {
      print('Token: $token');
    } else {
      print('Failed to get FCM token.');
    }

    void handleMessage(RemoteMessage? message) {
      if(message == null) return;

      navigatorKey.currentState?.pushNamed('/notification');

      Future initPushNotification() async{
        FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
        FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
      }
    }
  }
}
