import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/common/api/api.dart';
import 'package:smart_parking/core.dart';
import '../../../service/notification_service.dart';
import '../view/home_view.dart';

class HomeController extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static late HomeController instance;
  late HomeView view;
  late AnimationController controller;
  late Animation<double> animation;
  bool isNotif = false;
  String? gcmToken;
  int? roomIds;

  NotificationService messaging = NotificationService();
  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken(
      vapidKey: "${MyApi.FCM_KEY}",
    );

    print("FCM Token: $token");
    gcmToken = token;
    return token;
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  List<bool> statusParking = List.generate(8, (index) => false);
  final DatabaseReference database = FirebaseDatabase.instance.reference();

  void listenToStatusChanges() {
    for (int i = 0; i < statusParking.length; i++) {
      database.child('/statusParking/parking${i + 1}').onValue.listen((event) {
        var dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          dynamic value = dataSnapshot.value;
          if (value is bool) {
            bool currentStatus = statusParking[i];
            if (currentStatus != value) {
              setState(() {
                statusParking[i] = value;
              });
              if (isNotif && roomIds == i + 1) {
                sendNotifForMy(i + 1, value);
              }
            }
          } else if (value is String) {
            setState(() {
              statusParking[i] = value.toLowerCase() == 'true';
            });
          }
        }
      });
    }
  }

  void send(int roomId) {
    roomIds = int.parse(roomId.toString());
    getToken();
    if (gcmToken != null) {
      sendNotifForMy;
    }
  }

  void sendNotifForMy(int parkingNumber, bool status) {
    getToken().then((token) {
      if (token != null) {
        messaging.sendNotif(
          to: token,
          title: "Smart Parking",
          body: status
              ? "Room $parkingNumber telah diisi."
              : "Room $parkingNumber kosong, Anda bisa parkir di sini.",
        );
      }
    });
  }

  @override
  void initState() {
    instance = this;
    super.initState();
    controller = AnimationController(
      vsync: this,
      lowerBound: 0.1,
      duration: const Duration(seconds: 1),
    )..repeat();
    listenToStatusChanges();
  }

  AnimationController get animationController => controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
