import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyDialog {
  Widget dialogBooking({
    required String title,
    Widget? content,
    String? contentText,
    Widget? trailingY,
    Widget? trailingX,
  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              // Text(content),
              content!,
              Text(
                contentText.toString(),
                style: const TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          trailingY!,
          trailingX!,
        ],
      );
    });
  }

  Widget dialogRooms({
    required String title,
    required String content1,
    required Widget trailing1,
    required bool isOpen,
    required bool isBooking,
    String? content2,
    Widget? trailing2,
  }) {
    return AlertDialog(
      title: Text(title),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Divider(),
            ListTile(
              title: Text(content1),
              trailing: trailing1,
            ),
            if (isOpen == false && isBooking == false)
              ListTile(
                title: Text(content2!),
                trailing: trailing2,
              ),
          ],
        ),
      ),
    );
  }

  Widget dialogSuccess({
    required String text,
    required String assets,
    required Color textColor,
  }) {
    return AlertDialog(
      // contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 100,
              child: Lottie.asset(assets),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
