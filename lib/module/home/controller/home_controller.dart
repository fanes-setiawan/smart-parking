import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';

class HomeController extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static late HomeController instance;
  late HomeView view;
  late AnimationController controller;
  late Animation<double> animation;
  bool isNotif = false;
  late List<bool> roomNotifications;
  String? gcmToken;
  int? roomIds;

  NotificationService messaging = NotificationService();
  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken(
      vapidKey: MyApi.FCM_KEY,
    );
    gcmToken = token;
    return token;
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  List<bool> statusParking = List.generate(8, (index) => false);
  List<bool> statusBooking = List.generate(8, (index) => false);
  final DatabaseReference database = FirebaseDatabase.instance.reference();
  final DatabaseReference databaseBooking =
      FirebaseDatabase.instance.reference();

  void listenToStatusChanges() {
    for (int i = 0; i < statusParking.length; i++) {
      database
          .child('/statusParking/room${i + 1}/parking${i + 1}')
          .onValue
          .listen((event) {
        var dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          dynamic value = dataSnapshot.value;
          if (value is bool || value is String) {
            bool status = value is bool ? value : value.toLowerCase() == 'true';
            bool currentStatus = statusParking[i];

            if (currentStatus != status) {
              setState(() {
                statusParking[i] = status;
              });

              if (roomNotifications[i]) {
                if (status && !currentStatus) {
                  // Mobil datang kembali setelah sebelumnya kosong
                  sendNotifForMy(i + 1, status);
                } else if (!status && currentStatus) {
                  // Mobil pergi setelah sebelumnya terisi
                  sendNotifForMy(i + 1, status);
                }
              }
            }
          }
        }
      });
    }
  }

  void listenToStatusBooking() {
    for (int i = 0; i < statusBooking.length; i++) {
      databaseBooking
          .child("/statusParking/room${i + 1}/isBooking${i + 1}")
          .onValue
          .listen((event) {
        var dataSnapshot = event.snapshot;
        if (dataSnapshot.value != null) {
          dynamic value = dataSnapshot.value;
          if (value is bool || value is String) {
            bool status = value is bool ? value : value.toLowerCase() == 'true';
            bool currentStatus = statusBooking[i];
            if (currentStatus != status) {
              setState(() {
                statusBooking[i] = status;
              });
            }
          }
        }
      });
    }
  }

  void send(int roomId) {
    roomIds = int.parse(roomId.toString());
    getToken();
    if (gcmToken != null) {
      sendNotifForMy(roomIds!, statusParking[roomIds! - 1]);
    }
  }

  void sendNotifForMy(int parkingNumber, bool status) {
    getToken().then(
      (token) {
        if (token != null) {
          messaging.sendNotif(
            to: token,
            title: "Smart Parking",
            body: status
                ? "Room $parkingNumber telah diisi."
                : "Room $parkingNumber kosong, Anda bisa parkir di sini.",
          );
        }
      },
    );
  }

  @override
  void initState() {
    instance = this;
    super.initState();
    roomNotifications = List.generate(8, (index) => false);
    controller = AnimationController(
      vsync: this,
      lowerBound: 0.1,
      duration: const Duration(seconds: 1),
    )..repeat();
    listenToStatusChanges();
    listenToStatusBooking();
  }

  AnimationController get animationController => controller;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
  String platNumber = '';

  void myBooking(int roomNumber) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        String currentTime = DateTime.now().toString();
        String userUID = user.uid;

        // Path dokumen user dalam koleksi users
        String userDocumentPath = 'users/$userUID';

        // Mendapatkan referensi dokumen user
        final userDocRef = firestore.doc(userDocumentPath);

        // Mendapatkan data history dari dokumen user
        DocumentSnapshot userDocSnapshot = await userDocRef.get();
        Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;

        if (userData != null) {
          // Mendapatkan atau membuat subkoleksi history di dalam dokumen user
          Map<String, dynamic> history = userData['history'] ?? {};

          // Mendapatkan jumlah booking yang sudah ada untuk menentukan nomor urut berikutnya
          int nextBookingNumber = history.length + 1;

          // Data yang akan disimpan di dalam dokumen history
          Map<String, dynamic> bookingData = {
            "myBooking": true,
            "time": currentTime,
            "platNumber": platNumber,
            "roomNumber": roomNumber,
            // Data lain yang ingin Anda simpan
          };

          // Menambahkan data booking ke dalam subkoleksi history dengan nomor urut berikutnya
          final String bookingKey = 'booking_$nextBookingNumber';
          history[bookingKey] = bookingData;
          updateIsBookingValue(roomNumber);

          // Update data history di dokumen user
          await userDocRef.update({'history': history});

          print(
              'Data booking berhasil ditambahkan ke history user dengan nomor urut $nextBookingNumber');
        } else {
          print('Tidak ada data pengguna yang ditemukan');
        }
      } else {
        print('Tidak ada pengguna yang masuk');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
      // Lakukan tindakan lain, seperti memberi notifikasi atau handling khusus
    }
  }

  void updateIsBookingValue(int number) async {
    // Pastikan sudah terinisialisasi Firebase
    await Firebase.initializeApp();

    // Mendapatkan referensi ke database Firebase
    DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

    // Mendefinisikan path ke lokasi yang ingin diperbarui
    DatabaseReference roomRef =
        databaseReference.child('statusParking').child('room${number}');

    try {
      // Melakukan patch data dengan mengubah nilai isBooking menjadi true
      await roomRef.update({
        'isBooking${number}': true,
      });
    } catch (_) {}
  }

  // void updateIsBooking(int number) async {
  //   // Pastikan sudah terinisialisasi Firebase
  //   await Firebase.initializeApp();

  //   // Mendapatkan referensi ke database Firebase
  //   DatabaseReference databaseReference = FirebaseDatabase.instance.reference();

  //   // Mendefinisikan path ke lokasi yang ingin diperbarui
  //   DatabaseReference roomRef =
  //       databaseReference.child('statusParking').child('room${number}');

  //   try {
  //     // Melakukan patch data dengan mengubah nilai isBooking menjadi true
  //     await roomRef.update({
  //       'isBooking${number}': false,
  //     });
  //   } catch (_) {}
  // }
}
