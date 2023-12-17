import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:smart_parking/core.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  Widget build(context, LoginController controller) {
    controller.view = this;
    return Scaffold(
      backgroundColor: myColor.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
            image: DecorationImage(
          image: AssetImage(
            "assets/images/im.jpg",
          ),
        )),
        child: Stack(
          children: [
            GestureDetector(
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                    child: GlassmorphicContainer(
                      height: MediaQuery.sizeOf(context).height / 2,
                      width: MediaQuery.of(context).size.width,
                      borderRadius: 20,
                      blur: 0.2,
                      padding: const EdgeInsets.all(40),
                      alignment: Alignment.bottomCenter,
                      border: 1,
                      linearGradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color.fromARGB(255, 165, 182, 184)
                                .withOpacity(1),
                            const Color(0xFFFFFFFF).withOpacity(0.10),
                          ],
                          stops: const [
                            0.1,
                            1,
                          ]),
                      borderGradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFffffff).withOpacity(1),
                          const Color(0xFFFFFFFF).withOpacity(0.10),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(
                                  color: myColor.black,
                                ),
                                suffixIcon: Icon(
                                  Icons.email_outlined,
                                  color: myColor.black,
                                  size: 20,
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                helperText: 'Enter your email address',
                              ),
                              onChanged: (value) {
                                controller.email = value;
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(),
                            child: TextFormField(
                              obscureText: controller.obscureState,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                labelStyle: TextStyle(
                                  color: myColor.black,
                                ),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    controller.visibilitySt();
                                  },
                                  icon: Icon(
                                    controller.obscureState
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: myColor.black,
                                    size: 20,
                                  ),
                                ),
                                enabledBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blueGrey,
                                  ),
                                ),
                                helperText: 'Enter your password',
                              ),
                              onChanged: (value) {
                                controller.password = value;
                              },
                            ),
                          ),
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.login,
                              color: myColor.white,
                            ),
                            label: Text(
                              "LOGIN",
                              style: TextStyle(color: myColor.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: myColor.black,
                            ),
                            onPressed: () {
                              controller.doEmailLogin();
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "belum punya akun?",
                                style: TextStyle(
                                  fontSize: 14.0,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterView(),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: myColor.blue,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  State<LoginView> createState() => LoginController();
}
