import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:get/get.dart';

class DeviceTokenController extends GetxController {
  String? deviceToken;

  @override
  void onInit() {
    super.onInit();
    getDeviceToken();
  }

  Future<void> getDeviceToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        deviceToken = token;
        update();
      }
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: "Error", message: "$e");
    }
  }
}
