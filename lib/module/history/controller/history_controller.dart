import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';
import '../view/history_view.dart';

class HistoryController extends State<HistoryView> {
  static late HistoryController instance;
  late HistoryView view;
  List<HistoryData> historyList = [];

  Future<void> getHistoryData() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
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
          // Mendapatkan subkoleksi history di dalam dokumen user
          Map<String, dynamic> history = userData['history'] ?? {};

          // Mengonversi data history menjadi objek HistoryData dan memasukkannya ke dalam historyList
          historyList = history.values.map((data) {
            return HistoryData(
              myBooking: data['myBooking'],
              time: data['time'],
              platNumber: data['platNumber'],
              roomNumber: data['roomNumber'],
            );
          }).toList();
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

  @override
  void initState() {
    instance = this;
    super.initState();
    getHistoryData();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}

class HistoryData {
  final bool myBooking;
  final String time;
  final String platNumber;
  final int roomNumber;

  HistoryData({
    required this.myBooking,
    required this.time,
    required this.platNumber,
    required this.roomNumber,
  });
}
