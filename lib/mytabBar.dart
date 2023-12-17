import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:smart_parking/core.dart';

class MyTabBar extends StatefulWidget {
  const MyTabBar({super.key});

  @override
  State<MyTabBar> createState() => _MyTabBarState();
}

class _MyTabBarState extends State<MyTabBar> {
  final Completer<WebViewController> controller =
      Completer<WebViewController>();

  JavascriptChannel toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
      name: 'Toaster',
      onMessageReceived: (JavascriptMessage message) {},
    );
  }

  @override
  void initState() {
    super.initState();
  }

  doLogout() async {
    try {
      FirebaseAuth.instance.signOut();
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Info'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(
                    'Anda berhasil logout!!!',
                    style: TextStyle(color: myColor.red),
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
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
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
    } catch (_) {}
  }

  int _selectedIndex = 0;

  Widget _buildHome() {
    return const HomeView();
  }

  Widget _buildMaps() {
    return WebView(
      initialUrl: 'https://www.google.com/maps/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        controller.complete(webViewController);
      },
      onProgress: (int progress) {
        print("WebView is loading (progress : $progress%)");
      },
      javascriptChannels: <JavascriptChannel>{
        toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://www.google.com/maps/')) {
          ('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }

        ('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        ('Page started loading: $url');
      },
      onPageFinished: (String url) {
        ('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
      geolocationEnabled: true, //support geolocation or not
    );
  }

  Widget _buildCctv() {
    return WebView(
      initialUrl: 'https://cctv.jogjakota.go.id/',
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        controller.complete(webViewController);
      },
      onProgress: (int progress) {
        ("WebView is loading (progress : $progress%)");
      },
      javascriptChannels: <JavascriptChannel>{
        toasterJavascriptChannel(context),
      },
      navigationDelegate: (NavigationRequest request) {
        if (request.url.startsWith('https://cctv.jogjakota.go.id/')) {
          ('blocking navigation to $request}');
          return NavigationDecision.prevent;
        }

        ('allowing navigation to $request');
        return NavigationDecision.navigate;
      },
      onPageStarted: (String url) {
        ('Page started loading: $url');
      },
      onPageFinished: (String url) {
        ('Page finished loading: $url');
      },
      gestureNavigationEnabled: true,
      geolocationEnabled: true, //support geolocation or not
    );
  }

  // Widget _eWallet() {
  //   return const EwalletView();
  // }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return _buildHome();
      case 1:
        return _buildMaps();
      case 2:
        return _buildCctv();
      // case 3:
      //   return _eWallet();
      // case 4:
      //   return _eWallet();
      default:
        return _buildHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: myColor.white,
        backgroundColor: myColor.blueGrey,
        centerTitle: true,
        title: Text(
          "SMART PARKING",
          style: TextStyle(
            color: myColor.white,
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            wordSpacing: 2.0,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            StreamBuilder<DocumentSnapshot<Object?>>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) return const Text("Error");
                if (!snapshot.hasData) return const Text("No Data");
                Map<String, dynamic> item =
                    (snapshot.data!.data() as Map<String, dynamic>);
                item["id"] = snapshot.data!.id;
                return UserAccountsDrawerHeader(
                  accountName: Text(
                    item["name"],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  accountEmail: Text(
                    "${item['email']}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: NetworkImage(
                      item["urlImage"] ??
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRdcH0qkZOx5IaqQ9sUcnT8tJ6NmIvj7darDA&usqp=CAU',
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: myColor.blueGrey,
                  ),
                  otherAccountsPictures: const [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://play-lh.googleusercontent.com/Kf8WTct65hFJxBUDm5E-EpYsiDoLQiGGbnuyP6HBNax43YShXti9THPon1YKB6zPYpA"),
                    ),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                          "https://media.istockphoto.com/id/1058712430/id/vektor/ikon-sederhana-untuk-mewakili-konsep-internet-of-things-gigi-pengaturan-dan-jaringan-iot.jpg?s=612x612&w=0&k=20&c=gPiFhGEVZwTDTdnLsvWm1gBgazsbge2OjGwZpShngmM="),
                    ),
                  ],
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(
                "Home",
                style: TextStyle(
                  fontWeight:
                      _selectedIndex == 0 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(
                "Maps",
                style: TextStyle(
                  fontWeight:
                      _selectedIndex == 1 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.traffic_outlined),
              title: Text(
                "CCTV",
                style: TextStyle(
                  fontWeight:
                      _selectedIndex == 2 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                  Navigator.pop(context);
                });
              },
            ),
            // ListTile(
            //   leading: const Icon(Icons.wallet),
            //   title: Text(
            //     "E-wallet",
            //     style: TextStyle(
            //       fontWeight:
            //           _selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
            //     ),
            //   ),
            //   onTap: () {
            //     setState(() {
            //       _selectedIndex = 3;
            //       Navigator.pop(context);
            //     });
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: myColor.red,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: myColor.red,
                  fontWeight:
                      _selectedIndex == 4 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 4; // Pastikan perubahan nilai _selectedIndex
                  Navigator.pop(context);
                  doLogout();
                });
              },
            )
          ],
        ),
      ),
      body: _getSelectedScreen(_selectedIndex),
    );
  }
}
