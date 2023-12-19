import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';
import 'package:smart_parking/module/home/widget/home_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    String inp = "MASUK";
    String out = "KELUAR";
    return Scaffold(
      backgroundColor: myColor.blueGrey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FDottedLine(
                  color: myColor.yellow,
                  height: 100.0,
                  strokeWidth: 5.0,
                  dottedLength: 10.0,
                  space: 2.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: inp.split('').map((String letter) {
                    return Text(
                      letter,
                      style: TextStyle(
                        fontSize: 15,
                        color: myColor.yellow,
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Builder(
              builder: (context) {
                List roomParking = [
                  {"parkingNumber": 1},
                  {"parkingNumber": 2},
                  {"parkingNumber": 3},
                  {"parkingNumber": 4},
                  {"parkingNumber": 5},
                  {"parkingNumber": 6},
                  {"parkingNumber": 7},
                  {"parkingNumber": 8},
                ];
                return SizedBox(
                  child: GridView.count(
                    padding: EdgeInsets.zero,
                    childAspectRatio: 2.0,
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 45,
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    children: List.generate(
                      roomParking.length,
                      (index) {
                        var room = roomParking[index];
                        bool status = controller.statusParking[index];

                        return status
                            ? InkWell(
                                onTap: () async {
                                  bool currentStatus =
                                      controller.statusParking[index];
                                  controller.statusParking[index] =
                                      !currentStatus;
                                  await showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder:
                                            (BuildContext context, setState) {
                                          return AlertDialog(
                                            title: const Text("Messaging"),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      "Ingatkan Saya Jika Room ${room['parkingNumber']} Kosong"),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Switch(
                                                value: controller
                                                        .roomNotifications[
                                                    index], // Menggunakan status notifikasi untuk ruangan tertentu
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    controller.roomNotifications[
                                                            index] =
                                                        value; // Mengubah status notifikasi untuk ruangan tertentu
                                                    if (value &&
                                                        controller
                                                                .statusParking[
                                                            index]) {
                                                      // Mengirim notifikasi jika status ruangan dan notifikasi aktif
                                                      controller.send(room[
                                                          'parkingNumber']);
                                                    }
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: myColor.black,
                                    image: const DecorationImage(
                                      image:
                                          AssetImage("assets/images/car.png"),
                                    ),
                                    border: Border.all(
                                      width: 2,
                                      color: myColor.yellow,
                                    ),
                                  ),
                                ),
                              )
                            : InkWell(
                                onTap: () async {
                                  bool currentStatus =
                                      controller.statusParking[index];
                                  controller.statusParking[index] =
                                      !currentStatus;
                                  await showDialog<void>(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder:
                                            (BuildContext context, setState) {
                                          return AlertDialog(
                                            title: const Text("Messaging"),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      "Ingatkan Saya Jika Room ${room['parkingNumber']} Telah Diisi"),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Switch(
                                                value: controller
                                                        .roomNotifications[
                                                    index], // Menggunakan status notifikasi untuk ruangan tertentu
                                                onChanged: (bool value) {
                                                  setState(() {
                                                    controller.roomNotifications[
                                                            index] =
                                                        value; // Mengubah status notifikasi untuk ruangan tertentu
                                                    if (value &&
                                                        controller
                                                                .statusParking[
                                                            index]) {
                                                      // Mengirim notifikasi jika status ruangan dan notifikasi aktif
                                                      controller.send(room[
                                                          'parkingNumber']);
                                                    }
                                                    Navigator.pop(context);
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: myColor.black,
                                    border: Border.all(
                                      width: 2,
                                      color: myColor.yellow,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      room['parkingNumber'].toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                      },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FDottedLine(
                  color: myColor.yellow,
                  height: 115.0,
                  strokeWidth: 5.0,
                  dottedLength: 10.0,
                  space: 2.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: out.split('').map((String letter) {
                    return Text(
                      letter,
                      style: TextStyle(
                        fontSize: 14,
                        color: myColor.yellow,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 105,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: myColor.black,
                        border: Border.all(
                          width: 2,
                          color: myColor.white,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "stop!!!",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    HomeWidget.buildBody(controller.animationController),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<HomeView> createState() => HomeController();
}
