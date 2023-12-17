
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';
import '../view/ewallet_view.dart';

class EwalletController extends State<EwalletView> {
    static late EwalletController instance;
    late EwalletView view;

    @override
    void initState() {
        instance = this;
        super.initState();
    }

    @override
    void dispose() => super.dispose();

    @override
    Widget build(BuildContext context) => widget.build(context, this);
}
        
    