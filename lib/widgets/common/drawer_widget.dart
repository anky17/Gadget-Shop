import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/models/user_model.dart';
import 'package:gadgetshop/views/user/contact_screen.dart';
import 'package:gadgetshop/views/user/home_screen.dart';
import 'package:gadgetshop/views/auth/welcome_screen.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/views/user/products/all_products_screen.dart';
import 'package:gadgetshop/views/user/orders/my_orders_screen.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  UserModel? currentUser;
  final User? firebaseUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (firebaseUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser!.uid)
            .get();

        if (userDoc.exists) {
          setState(() {
            currentUser =
                UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
          });
        }
      } catch (e) {
        if (kDebugMode) {
          print('Error loading user data: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Get.height / 20),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        backgroundColor: AppConstant.appSecondaryColor,
        child: Wrap(
          runSpacing: 20,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: currentUser != null
                  ? ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        currentUser!.username,
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        currentUser!.email,
                        style: TextStyle(
                          color: AppConstant.appTextColor,
                          fontSize: 12,
                        ),
                      ),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: AppConstant.appStatusBarColor,
                        backgroundImage: currentUser!.userImg.isNotEmpty &&
                                currentUser!.userImg != 'null'
                            ? NetworkImage(currentUser!.userImg)
                            : null,
                        child: currentUser!.userImg.isEmpty ||
                                currentUser!.userImg == 'null'
                            ? Text(
                                currentUser!.username[0].toUpperCase(),
                                style: TextStyle(
                                  color: AppConstant.appSecondaryColor,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    )
                  : ListTile(
                      titleAlignment: ListTileTitleAlignment.center,
                      title: Text(
                        "Gadget Shop",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      subtitle: Text(
                        "Version 1.0.0",
                        style: TextStyle(color: AppConstant.appTextColor),
                      ),
                      leading: CircleAvatar(
                        radius: 22,
                        backgroundColor: AppConstant.appStatusBarColor,
                        child: Text(
                          "G",
                          style:
                              TextStyle(color: AppConstant.appSecondaryColor),
                        ),
                      ),
                    ),
            ),
            Divider(
              indent: 10,
              endIndent: 10,
              thickness: 1.5,
              color: Colors.grey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => HomeScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Home",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.home,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => AllProductsScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Products",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.production_quantity_limits,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => MyOrdersScreen());
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Orders",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                titleAlignment: ListTileTitleAlignment.center,
                onTap: () {
                  Navigator.pop(context);
                  Get.to(() => ContactScreen());
                },
                title: Text(
                  "Contacts",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.help,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: ListTile(
                onTap: () async {
                  final shouldLogout = await Get.dialog<bool>(
                    AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Get.back(result: true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  );

                  if (shouldLogout == true) {
                    EasyLoading.show(status: 'Logging out...');
                    GoogleSignIn googleSignIn = GoogleSignIn();
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signOut();
                    await googleSignIn.signOut();
                    EasyLoading.dismiss();
                    Get.offAll(() => WelcomeScreen());
                  }
                },
                titleAlignment: ListTileTitleAlignment.center,
                title: Text(
                  "Logout",
                  style: TextStyle(color: AppConstant.appTextColor),
                ),
                leading: Icon(
                  Icons.logout,
                  color: AppConstant.appTextColor,
                ),
                trailing: Icon(
                  Icons.arrow_forward,
                  color: AppConstant.appTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
