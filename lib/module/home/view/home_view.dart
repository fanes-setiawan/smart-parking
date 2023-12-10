import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/common/color/my_colors.dart';
import 'package:smart_parking/core.dart';
import '../controller/home_controller.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  Widget build(context, HomeController controller) {
    controller.view = this;

    String inp = "MASUK";
    String out = "KELUAR";
    return Scaffold(
      backgroundColor: myColor().grey,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FDottedLine(
                  color: myColor().yellow,
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
                        color: myColor().yellow,
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            const SizedBox(
              height: 10.0,
            ),
            GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2.0,
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 45,
              ),
              itemCount: 8,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  decoration: BoxDecoration(
                    color: myColor().black,
                    image: const DecorationImage(
                      image: AssetImage(
                        "assets/images/car.png",
                      ),
                    ),
                    border: Border.all(
                      width: 2,
                      color: myColor().yellow,
                    ),
                  ),
                  child: const Column(
                    children: [],
                  ),
                );
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FDottedLine(
                  color: myColor().yellow,
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
                        color: myColor().yellow,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  width: 20.0,
                ),
                _buildBody(
                    controller.animationController), // Use the controller here
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

Widget _buildContainer(double radius, AnimationController controller) {
  return Container(
    width: radius,
    height: radius,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.red.withOpacity(1 - controller.value),
    ),
  );
}

Widget _buildBody(AnimationController controller) {
  return AnimatedBuilder(
    animation: CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
    builder: (context, child) {
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _buildContainer(20 * controller.value, controller),
          _buildContainer(40 * controller.value, controller),
          _buildContainer(60 * controller.value, controller),
          _buildContainer(80 * controller.value, controller),
          _buildContainer(100 * controller.value, controller),
        ],
      );
    },
  );
}
