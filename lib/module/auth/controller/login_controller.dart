import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_parking/core.dart';

class LoginController extends State<LoginView> {
  static late LoginController instance;
  late LoginView view;

  bool obscureState = true;
  bool isLoading = false;

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
  String? email;
  String? password;

  doEmailLogin() async {
    try {
      setState(() {
        isLoading = true;
      });

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Navigasi ke MyTabBar jika login berhasil
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyTabBar(),
        ),
      );
    } on FirebaseAuthException catch (_) {
      await showDialog<void>(
        context: context,
        barrierDismissible: true,
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
                    'Maaf \nmasukan email dan password dengan benar :(',
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
                      builder: (context) => const LoginView(),
                    ),
                  );
                },
                child: Text(
                  "oke",
                  style: TextStyle(
                      color: myColor.black, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      );
      // );
    } catch (err) {
      print("Login error: $err");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
