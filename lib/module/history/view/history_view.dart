import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_parking/core.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({Key? key}) : super(key: key);

  Widget build(context, HistoryController controller) {
    controller.view = this;
    return Scaffold(
      body: FutureBuilder(
        future: controller.getHistoryData(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (controller.historyList.isEmpty) {
              return const Center(
                child: Text('Tidak ada data history.'),
              );
            } else {
              controller.historyList.sort((a, b) =>
                  DateTime.parse(b.time).compareTo(DateTime.parse(a.time)));
              return ListView.builder(
                itemCount: controller.historyList.length,
                itemBuilder: (BuildContext context, int index) {
                  var history = controller.historyList[index];
                  var formattedDate = DateFormat('HH:mm dd/MM/yy')
                      .format(DateTime.parse(history.time));

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 3,
                      child: ListTile(
                        title: Text(
                          'Time: ${formattedDate}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Plat: ${history.platNumber}'),
                            const SizedBox(height: 4),
                            Text('Room: ${history.roomNumber}'),
                          ],
                        ),
                        trailing: history.myBooking
                            ? Text(
                                "Booked",
                                style: TextStyle(
                                  color: myColor.green,
                                ),
                              )
                            : Text(
                                "Not Booked",
                                style: TextStyle(
                                  color: myColor.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  @override
  State<HistoryView> createState() => HistoryController();
}
