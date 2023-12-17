import 'package:flutter/material.dart';

class HomeWidget {
  static Widget buildContainer(double radius, AnimationController controller) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red.withOpacity(1 - controller.value),
      ),
    );
  }

  static Widget buildBody(AnimationController controller) {
    return AnimatedBuilder(
      animation:
          CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            buildContainer(20 * controller.value, controller),
            buildContainer(40 * controller.value, controller),
            buildContainer(60 * controller.value, controller),
            buildContainer(80 * controller.value, controller),
            buildContainer(100 * controller.value, controller),
          ],
        );
      },
    );
  }
}
