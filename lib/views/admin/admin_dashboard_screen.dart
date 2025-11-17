import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/controllers/admin_order_controller.dart';
import 'package:gadgetshop/controllers/admin_product_controller.dart';
import 'package:gadgetshop/controllers/admin_category_controller.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/views/admin/manage_categories_screen.dart';
import 'package:gadgetshop/views/admin/manage_orders_screen.dart';
import 'package:gadgetshop/views/admin/manage_products_screen.dart';
import 'package:gadgetshop/views/auth/welcome_screen.dart';
import 'package:get/get.dart';

class AdminDashboardScreen extends StatelessWidget {
  AdminDashboardScreen({super.key});

  final AdminOrderController orderController = Get.put(AdminOrderController());
  final AdminProductController productController =
      Get.put(AdminProductController());
  final AdminCategoryController categoryController =
      Get.put(AdminCategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppConstant.appTextColor,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: AppConstant.appSecondaryColor,
          statusBarBrightness: Brightness.light,
        ),
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              // Show confirmation dialog
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
                await FirebaseAuth.instance.signOut();
                EasyLoading.dismiss();
                Get.offAll(() => WelcomeScreen());
              }
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstant.appMainColor,
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final stats = orderController.getOrderStatistics();
              final revenue = orderController.getTotalRevenue();

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard(
                    'Total Orders',
                    stats['total'].toString(),
                    Icons.shopping_bag,
                    Colors.blue,
                  ),
                  _buildStatCard(
                    'Pending Orders',
                    stats['pending'].toString(),
                    Icons.pending_actions,
                    Colors.orange,
                  ),
                  _buildStatCard(
                    'Total Products',
                    productController.products.length.toString(),
                    Icons.inventory,
                    Colors.green,
                  ),
                  _buildStatCard(
                    'Total Revenue',
                    '\$${revenue.toStringAsFixed(2)}',
                    Icons.attach_money,
                    Colors.purple,
                  ),
                ],
              );
            }),
            const SizedBox(height: 32),

            // Management Options
            Text(
              'Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstant.appMainColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildManagementTile(
              'Manage Orders',
              'View and update order statuses',
              Icons.list_alt,
              Colors.blue,
              () => Get.to(() => ManageOrdersScreen()),
            ),
            const SizedBox(height: 12),
            _buildManagementTile(
              'Manage Products',
              'Add, edit, or delete products',
              Icons.shopping_cart,
              Colors.green,
              () => Get.to(() => ManageProductsScreen()),
            ),
            const SizedBox(height: 12),
            _buildManagementTile(
              'Manage Categories',
              'Add, edit, or delete categories',
              Icons.category,
              Colors.orange,
              () => Get.to(() => ManageCategoriesScreen()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [color.withValues(alpha: 0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: Colors.white),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildManagementTile(
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
