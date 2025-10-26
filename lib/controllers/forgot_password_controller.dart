import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/views/auth/sign_in_screen.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> forgotPasswordMethod(String userEmail) async {
    try {
      EasyLoading.show(status: "Please Wait");
      await _auth.sendPasswordResetEmail(email: userEmail);

      showCustomSnackbar(
          title: "Request Sent Success",
          message: "Password reset link sent to $userEmail");
      Get.offAll(() => SignInScreen());
      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      throw ("error $e");
    }
  }
}
