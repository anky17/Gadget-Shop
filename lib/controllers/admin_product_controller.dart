import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/products_model.dart';
import 'package:get/get.dart';

class AdminProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<ProductModel> products = <ProductModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  // Fetch all products
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await _firestore
          .collection('products')
          .orderBy('createdAt', descending: true)
          .get();

      products.value = querySnapshot.docs
          .map(
              (doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      showCustomSnackbar(
          title: 'Error', message: 'Failed to fetch products: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add new product
  Future<void> addProduct(ProductModel product) async {
    try {
      EasyLoading.show(status: 'Adding product...');
      await _firestore
          .collection('products')
          .doc(product.productId)
          .set(product.toMap());
      await fetchProducts();
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Product added successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Error', message: 'Failed to add product: $e');
    }
  }

  // Update product
  Future<void> updateProduct(ProductModel product) async {
    try {
      EasyLoading.show(status: 'Updating product...');
      await _firestore
          .collection('products')
          .doc(product.productId)
          .update(product.toMap());
      await fetchProducts();
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Product updated successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Failed to update product: $e');
    }
  }

  // Delete product
  Future<void> deleteProduct(String productId) async {
    try {
      EasyLoading.show(status: 'Deleting product...');
      await _firestore.collection('products').doc(productId).delete();
      await fetchProducts();
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Success', message: 'Product deleted successfully');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(
          title: 'Error', message: 'Failed to delete product: $e');
    }
  }

  // Toggle flash sale status
  Future<void> toggleFlashSale(String productId, bool isSale) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .update({'isSale': isSale});
      await fetchProducts();
      showCustomSnackbar(
          title: 'Success', message: 'Flash sale status updated');
    } catch (e) {
      showCustomSnackbar(
          title: 'Error', message: 'Failed to update flash sale: $e');
    }
  }
}
