import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';

class RegisterController extends State<RegisterView> {
  static late RegisterController instance;
  late RegisterView view;

  bool obscureState = true;
  bool isLoading = false;

  final FirebaseAuth auth = FirebaseAuth.instance;

  visibilitySt() {
    obscureState = !obscureState;
    setState(() {});
  }

  @override
  void initState() {
    instance = this;
    super.initState();
  }

  @override
  void dispose() => super.dispose();

  @override
  Widget build(BuildContext context) => widget.build(context, this);
  String name = '';
  String email = '';
  String password = '';

  register() async {
    try {
      setState(() {
        isLoading = true;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final User? user = auth.currentUser;
      if (user != null) {
        final FirebaseFirestore db = FirebaseFirestore.instance;
        try {
          await db.collection('users').doc(user.uid).set({
            'name': name,
            'email': email,
            'password': password,
          });
        } on Exception catch (err) {
          print(err);
        }
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyTabBar(),
        ),
      );
      setState(() {
        isLoading = false;
      });
    } on Exception catch (_) {
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: myColor.white,
            title: const Row(
              children: [
                Icon(
                  Icons.notification_important_rounded,
                  size: 20.0,
                ),
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  'Invalid!!!',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Anda Gagal Melakukan Register',
                    style: TextStyle(color: myColor.grey),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: myColor.white,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegisterView(),
                    ),
                  );
                },
                child: Text(
                  "yes",
                  style: TextStyle(
                      color: myColor.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
    }
  }
}
