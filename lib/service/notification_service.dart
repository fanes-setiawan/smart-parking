import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_parking/common/api/api.dart';
import '../../firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Handling a background message ${message.messageId}');
}

class NotificationService {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationChannel channel;
  static bool isFlutterLocalNotificationsInitialized = false;

  initNotifications() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen(showFlutterNotification);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance
        .getToken(vapidKey: "${MyApi.Vapid_Key}");

    print("FCM Token: $token");
    return token;
  }

  Future<void> setupFlutterNotifications() async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    isFlutterLocalNotificationsInitialized = true;
  }

  void showFlutterNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: 'launch_background',
          ),
        ),
      );
    }
  }

  Future<void> sendNotif({
    required String to,
    required String title,
    required String body,
  }) async {
    try {
      Response response = await Dio().post(
        '${MyApi.FCM_URL}/send',
        options: Options(
          headers: {
            "Authorization": "Bearer ${MyApi.FCM_KEY}",
          },
        ),
        data: {
          "to": to,
          "notification": {"title": title, "body": body},
          "android": {"priority": "high"},
          "priority": 10,
          "data": {
            "id": getRandomInteger()
          }, // Panggil getRandomInteger() di sini
        },
      );

      if (response.statusCode == 200) {
        // Permintaan berhasil
        print('Notifikasi berhasil dikirim!');
        print(response.data); // Jika Anda ingin mencetak respons data
      } else {
        // Penanganan jika permintaan tidak berhasil
        print('Gagal mengirim notifikasi. Kode status: ${response.statusCode}');
      }
    } on DioError catch (e) {
      // Penanganan jika terjadi error pada permintaan
      if (e.response != null) {
        print('Ada masalah dengan respons: ${e.response!.statusCode}');
      } else {
        print('Ada masalah dengan koneksi atau permintaan.');
      }
    }
  }

  int getRandomInteger() {
    final random = Random();
    return random.nextInt(1000000);
  }
}
