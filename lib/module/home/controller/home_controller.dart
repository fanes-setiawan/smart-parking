import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';
import '../view/home_view.dart';

class HomeController extends State<HomeView>
    with SingleTickerProviderStateMixin {
  static late HomeController instance;
  late HomeView view;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    instance = this;
    super.initState();
    controller = AnimationController(
      vsync: this,
      lowerBound: 0.1,
      duration: Duration(seconds: 5),
    )..repeat();
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
