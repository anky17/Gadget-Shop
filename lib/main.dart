import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/firebase_options.dart';
import 'package:get/get.dart';
import 'screens/user/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gadget Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      builder: EasyLoading.init(),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'json_to_firestore_uploader.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: const MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final uploader = JsonToFirestoreUploader();

//     return Scaffold(
//       appBar: AppBar(title: const Text('JSON to Firestore')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await uploader.uploadCategoriesFromAssets();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Categories uploaded')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error uploading categories: $e')),
//                   );
//                 }
//               },
//               child: const Text('Upload Categories'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await uploader.uploadProductsFromAssets();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Products uploaded')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error uploading products: $e')),
//                   );
//                 }
//               },
//               child: const Text('Upload Products'),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   await uploader.uploadAllFromAssets();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('All data uploaded')),
//                   );
//                 } catch (e) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Error uploading all data: $e')),
//                   );
//                 }
//               },
//               child: const Text('Upload All'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
