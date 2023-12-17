import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';
import '../controller/ewallet_controller.dart';

class EwalletView extends StatefulWidget {
  const EwalletView({Key? key}) : super(key: key);

  Widget build(context, EwalletController controller) {
    controller.view = this;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: myColor.blue,
                ),
                child: Column(
                  children: [
                    Text(
                      "DANA",
                      style: TextStyle(
                        fontSize: 25.0,
                        color: myColor.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  State<EwalletView> createState() => EwalletController();
}
