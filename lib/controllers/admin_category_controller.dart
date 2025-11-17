import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/category_model.dart';
import 'package:get/get.dart';

class AdminCategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await _firestore
          .collection('categories')
          .orderBy('createdAt', descending: true)
          .get();

      categories.value = querySnapshot.docs
          .map((doc) =>
              CategoryModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      showCustomSnackbar(
          title: 'Error', message: 'Failed to fetch categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add new category
  Future<void> addCategory(CategoryModel category) async {
    try {
      EasyLoading.show(status: 'Adding category...');
      await _firestore
          .collection('categories')
          .doc(category.categoryId)
          .set(category.toMap());
      await fetchCategories();
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Category added successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Error', message: 'Failed to add category: $e');
    }
  }

  // Update category
  Future<void> updateCategory(CategoryModel category) async {
    try {
      EasyLoading.show(status: 'Updating category...');
      await _firestore
          .collection('categories')
          .doc(category.categoryId)
          .update(category.toMap());
      await fetchCategories();
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Category updated successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Failed to update category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(String categoryId) async {
    try {
      EasyLoading.show(status: 'Deleting category...');
      await _firestore.collection('categories').doc(categoryId).delete();
      await fetchCategories();
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Category deleted successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Failed to delete category: $e');
    }
  }
}
