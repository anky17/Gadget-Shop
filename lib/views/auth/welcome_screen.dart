import 'package:flutter/material.dart';
import 'package:gadgetshop/controllers/google_sign_in_controller.dart';
import 'package:gadgetshop/views/auth/sign_in_screen.dart';
import 'package:gadgetshop/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  final GoogleSignInController _googleSignInController =
      GoogleSignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstant.appSecondaryColor,
        elevation: 0,
        title: Text(
          "Welcome to Gadget Shop",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: AppConstant.appTextColor),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Lottie.asset('assets/icons/splash-icon.json'),
          ),
          Container(
            margin: EdgeInsets.only(top: 10),
            child: Text(
              'Welcome! Please Sign in to Continue.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: Get.height / 12),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white70,
              ),
              child: TextButton(
                onPressed: () {
                  _googleSignInController.signInWithGoogle();
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/google.png',
                      width: Get.width / 12,
                      height: Get.height / 12,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Sign in with Google',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: Get.height / 25),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white70,
              ),
              child: TextButton(
                onPressed: () {
                  Get.to(() => SignInScreen());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.email_rounded,
                      color: Colors.green,
                      size: 35,
                    ),
                    SizedBox(width: 20),
                    Text(
                      'Sign in with Email',
                      style: TextStyle(fontSize: 19),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
