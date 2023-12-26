import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';
import 'package:smart_parking/module/home/widget/dialog.dart';

import '../controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    String inp = "MASUK";
    // String out = "KELUAR";
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
                        bool bookingStatus = controller.statusBooking[index];
                        // if (status == true) {
                        //   controller.updateIsBooking(index + 1);
                        // }

                        return InkWell(
                          onTap: () async {
                            bool currentStatus =
                                controller.statusParking[index];
                            controller.statusParking[index] = !currentStatus;
                            await showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (BuildContext context, setState) {
                                    return MyDialog().dialogRooms(
                                      isBooking: bookingStatus,
                                      title: "Room ${index + 1}",
                                      content1: "Notification",
                                      trailing1: Switch(
                                        value:
                                            controller.roomNotifications[index],
                                        onChanged: (bool value) {
                                          setState(() {
                                            controller
                                                    .roomNotifications[index] =
                                                value;
                                            if (value &&
                                                controller
                                                    .statusParking[index]) {
                                              controller
                                                  .send(room['parkingNumber']);
                                            }
                                            Navigator.pop(context);
                                          });
                                        },
                                      ),
                                      isOpen: status,
                                      content2: "Booking",
                                      trailing2: Container(
                                        height: 35,
                                        padding: EdgeInsets.zero,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: controller
                                                        .statusBooking[index] ==
                                                    true
                                                ? myColor.red
                                                : myColor.green,
                                            shape: const StadiumBorder(),
                                          ),
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            await showDialog<void>(
                                                context: context,
                                                barrierDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return controller
                                                                  .statusBooking[
                                                              index] ==
                                                          false
                                                      ? MyDialog()
                                                          .dialogBooking(
                                                          trailingY:
                                                              ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  controller.platNumber
                                                                              .length >=
                                                                          3
                                                                      ? myColor
                                                                          .green
                                                                      : myColor
                                                                          .grey,
                                                            ),
                                                            onPressed:
                                                                () async {
                                                              Navigator.pop(
                                                                  context);
                                                              if (controller
                                                                      .platNumber
                                                                      .length >=
                                                                  3)
                                                                controller
                                                                    .myBooking(
                                                                        index +
                                                                            1);

                                                              await showDialog<
                                                                  void>(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return MyDialog().dialogSuccess(
                                                                      text: controller.platNumber.length >=
                                                                              3
                                                                          ? "Success Your Booking!!!"
                                                                          : 'Invalid Your Bookings',
                                                                      assets: controller.platNumber.length >=
                                                                              3
                                                                          ? "assets/lottie/success.json"
                                                                          : "assets/lottie/invalid.json",
                                                                      textColor:
                                                                          myColor
                                                                              .green);
                                                                },
                                                              );
                                                            },
                                                            child: Text(
                                                              "Lanjutkan",
                                                              style: TextStyle(
                                                                color: myColor
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          trailingX:
                                                              ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  myColor.red,
                                                            ),
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text(
                                                              "Batal",
                                                              style: TextStyle(
                                                                color: myColor
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                          contentText:
                                                              'enter your plat number',
                                                          title: "Booking",
                                                          content: Container(
                                                            height: 100,
                                                            margin:
                                                                const EdgeInsets
                                                                    .only(),
                                                            child:
                                                                TextFormField(
                                                              maxLength: 11,
                                                              maxLines: 1,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .multiline,
                                                              initialValue:
                                                                  null,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 40,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              decoration:
                                                                  InputDecoration(
                                                                filled: true,
                                                                fillColor:
                                                                    Colors
                                                                        .white,
                                                                hintText:
                                                                    "xx xxxx xx",
                                                                hintStyle: const TextStyle(
                                                                    fontSize:
                                                                        35,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                border:
                                                                    OutlineInputBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                              ),
                                                              onChanged:
                                                                  (value) {
                                                                controller
                                                                        .platNumber =
                                                                    value;

                                                                ();
                                                              },
                                                            ),
                                                          ),
                                                        )
                                                      : MyDialog()
                                                          .dialogBooking(
                                                          title: "Booking",
                                                          contentText:
                                                              "Anda yakin? ingin membatalkan booking?",
                                                        );
                                                });
                                          },
                                          child: Text(
                                            controller.statusBooking[index] ==
                                                    false
                                                ? "Booking"
                                                : "Batalkan",
                                            style: TextStyle(
                                              color: myColor.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: bookingStatus
                              ? Container(
                                  decoration: BoxDecoration(
                                    color: bookingStatus
                                        ? myColor.red
                                        : myColor.black,
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
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: bookingStatus
                                        ? myColor.red
                                        : myColor.black,
                                    border: Border.all(
                                      width: 2,
                                      color: myColor.yellow,
                                    ),
                                  ),
                                  child: status
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: myColor.black,
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/car.png"),
                                            ),
                                            border: Border.all(
                                              width: 2,
                                              color: myColor.yellow,
                                            ),
                                          ),
                                        )
                                      : Center(
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
            // const SizedBox(
            //   height: 40.0,
            // ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     FDottedLine(
            //       color: myColor.yellow,
            //       height: 115.0,
            //       strokeWidth: 5.0,
            //       dottedLength: 10.0,
            //       space: 2.0,
            //     ),
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: out.split('').map((String letter) {
            //         return Text(
            //           letter,
            //           style: TextStyle(
            //             fontSize: 14,
            //             color: myColor.yellow,
            //           ),
            //         );
            //       }).toList(),
            //     ),
            //     const SizedBox(
            //       width: 20.0,
            //     ),
            //     Stack(
            //       children: [
            //         Container(
            //           width: 150,
            //           height: 105,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(5),
            //             color: myColor.black,
            //             border: Border.all(
            //               width: 2,
            //               color: myColor.white,
            //             ),
            //           ),
            //           child: const Center(
            //             child: Text(
            //               "stop!!!",
            //               style: TextStyle(
            //                 fontSize: 20.0,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //         HomeWidget.buildBody(controller.animationController),
            //       ],
            //     )
            // ],
            // ),
          ],
        ),
      ),
    );
  }

  @override
  State<HomeView> createState() => HomeController();
}
