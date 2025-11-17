import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/controllers/get_device_token_controller.dart';
import 'package:gadgetshop/models/user_model.dart';
import 'package:gadgetshop/views/admin/admin_dashboard_screen.dart';
import 'package:gadgetshop/views/user/home_screen.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInController extends GetxController {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DeviceTokenController getDeviceController =
      Get.put(DeviceTokenController());

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        EasyLoading.show(status: 'Please wait!');
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential authCredential = GoogleAuthProvider.credential(
            accessToken: googleSignInAuthentication.accessToken,
            idToken: googleSignInAuthentication.idToken);

        final UserCredential userCredential =
            await _auth.signInWithCredential(authCredential);

        final User? user = userCredential.user;

        if (user != null) {
          // Check if user already exists
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

          if (userDoc.exists) {
            // User exists, check if admin
            UserModel existingUser =
                UserModel.fromMap(userDoc.data() as Map<String, dynamic>);

            if (existingUser.isAdmin) {
              Get.offAll(() => AdminDashboardScreen());
            } else {
              Get.offAll(() => const HomeScreen());
            }
          } else {
            // New user, create account
            UserModel userModel = UserModel(
              uId: user.uid,
              username: user.displayName.toString(),
              email: user.email.toString(),
              phone: user.phoneNumber.toString(),
              userImg: user.photoURL.toString(),
              userDeviceToken: getDeviceController.deviceToken.toString(),
              country: '',
              userAddress: '',
              street: '',
              isAdmin: false,
              isActive: true,
              createdOn: DateTime.now(),
            );

            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .set(userModel.toMap());
            Get.offAll(() => const HomeScreen());
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("error $e");
      }
    } finally {
      EasyLoading.dismiss();
    }
  }
}
