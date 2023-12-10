import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_pro/webview_flutter.dart';
import 'package:smart_parking/common/color/my_colors.dart';
import 'package:smart_parking/module/home/view/home_view.dart';

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
      onMessageReceived: (JavascriptMessage message) {
        // Using Builder to get the right context
        // Scaffold.of(context).scaffoldKey(
        //   SnackBar(content: Text(message.message)),
        // );
      },
    );
  }

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  Widget _buildHome() {
    return const HomeView();
  }

  // Widget untuk halaman About
  Widget _buildMaps() {
    return WebView(
      initialUrl: 'https://www.google.com/maps/',
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

  // Widget untuk halaman TOS (Terms of Service)
  Widget _buildTOS() {
    return Center(
      child: Text(
        'Ini adalah halaman Terms of Service',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  // Widget untuk halaman Privacy Policy
  Widget _buildPrivacyPolicy() {
    return Center(
      child: Text(
        'Ini adalah halaman Privacy Policy',
        style: TextStyle(fontSize: 24.0),
      ),
    );
  }

  Widget _getSelectedScreen(int index) {
    switch (index) {
      case 0:
        return _buildHome();
      case 1:
        return _buildMaps();
      case 2:
        return _buildTOS();
      case 3:
        return _buildPrivacyPolicy();
      default:
        return _buildHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SMART PARKING",
              style: TextStyle(
                color: myColor().black,
                fontSize: 18,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                wordSpacing: 2.0,
              ),
            ),
            const SizedBox(
              width: 5.0,
            ),
            const Icon(
              Icons.car_crash_rounded,
              size: 25.0,
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Andrew Garfield"),
              accountEmail: const Text("capek@ngoding.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1600486913747-55e5470d6f40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
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
                _selectedIndex = 2;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.wallet),
              title: Text(
                "E-wallet",
                style: TextStyle(
                  fontWeight:
                      _selectedIndex == 3 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                _selectedIndex = 3;
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: myColor().red,
              ),
              title: Text(
                "Logout",
                style: TextStyle(
                  color: myColor().red,
                  fontWeight:
                      _selectedIndex == 4 ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              onTap: () {
                _selectedIndex = 4;
                Navigator.pop(context);
                setState(() {});
              },
            )
          ],
        ),
      ),
      body: _getSelectedScreen(_selectedIndex),
    );
  }
}
