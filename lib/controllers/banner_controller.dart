import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BannerController extends GetxController {
  RxList<String> bannerUrls = RxList<String>([]);

  @override
  void onInit() {
    super.onInit();
    fetchBannersUrls();
  }

  Future<void> fetchBannersUrls() async {
    try {
      QuerySnapshot bannerSnapshots =
          await FirebaseFirestore.instance.collection("banners").get();

      if (bannerSnapshots.docs.isNotEmpty) {
        bannerUrls.value = bannerSnapshots.docs
            .map((doc) => doc['imageUrl'] as String)
            .toList();
      }
    } catch (e) {
      debugPrint("Error fetching banners: $e");
    }
  }
}
