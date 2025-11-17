import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gadgetshop/models/user_model.dart';
import 'package:gadgetshop/views/admin/admin_dashboard_screen.dart';
import 'package:gadgetshop/views/user/home_screen.dart';
import 'package:gadgetshop/views/auth/welcome_screen.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      loggedIn(context);
    });
  }

  Future<void> loggedIn(BuildContext context) async {
    if (user != null) {
      // Check if user is admin
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .get();

        if (userDoc.exists) {
          UserModel userData =
              UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

          if (userData.isAdmin) {
            Get.offAll(() => AdminDashboardScreen());
          } else {
            Get.offAll(() => const HomeScreen());
          }
        } else {
          Get.offAll(() => const HomeScreen());
        }
      } catch (e) {
        Get.offAll(() => const HomeScreen());
      }
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstant.appSecondaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/icons/splash-icon.json'),
            const Text(
              'Gadget Shop',
              style: TextStyle(
                color: AppConstant.appTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
