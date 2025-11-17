import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/cart_model.dart';
import 'package:gadgetshop/models/products_model.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RxList<CartModel> cartItems = <CartModel>[].obs;
  RxBool isLoading = false.obs;
  RxDouble totalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  // Get current user ID
  String? get userId => _auth.currentUser?.uid;

  // Fetch cart items from Firebase
  Future<void> fetchCartItems() async {
    if (userId == null) {
      showCustomSnackbar(title: 'Error', message: 'Please login to view cart');
      return;
    }

    try {
      isLoading.value = true;
      QuerySnapshot querySnapshot = await _firestore
          .collection('cart')
          .doc(userId)
          .collection('cartOrders')
          .get();

      cartItems.value = querySnapshot.docs
          .map((doc) => CartModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      calculateTotalPrice();
    } catch (e) {
      showCustomSnackbar(
          title: 'Error', message: 'Failed to fetch cart items: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add product to cart
  Future<void> addToCart(ProductModel product) async {
    if (userId == null) {
      showCustomSnackbar(
          title: 'Error', message: 'Please login to add items to cart');
      return;
    }

    try {
      EasyLoading.show(status: 'Adding to cart...');

      // Check if product already exists in cart
      DocumentSnapshot existingItem = await _firestore
          .collection('cart')
          .doc(userId)
          .collection('cartOrders')
          .doc(product.productId)
          .get();

      if (existingItem.exists) {
        // Update quantity
        CartModel existingCart =
            CartModel.fromMap(existingItem.data() as Map<String, dynamic>);
        int newQuantity = existingCart.productQuantity + 1;
        double price = double.parse(
            product.isSale ? product.salePrice : product.fullPrice);

        await _firestore
            .collection('cart')
            .doc(userId)
            .collection('cartOrders')
            .doc(product.productId)
            .update({
          'productQuantity': newQuantity,
          'productTotalPrice': price * newQuantity,
        });
      } else {
        // Add new item
        double price = double.parse(
            product.isSale ? product.salePrice : product.fullPrice);

        CartModel cartItem = CartModel(
          productId: product.productId,
          categoryId: product.categoryId,
          productName: product.productName,
          categoryName: product.categoryName,
          salePrice: product.salePrice,
          fullPrice: product.fullPrice,
          productImages: product.productImages,
          deliveryTime: product.deliveryTime,
          isSale: product.isSale,
          productDescription: product.productDescription,
          createdAt: product.createdAt,
          updatedAt: product.updatedAt,
          productQuantity: 1,
          productTotalPrice: price,
        );

        await _firestore
            .collection('cart')
            .doc(userId)
            .collection('cartOrders')
            .doc(product.productId)
            .set(cartItem.toMap());
      }

      await fetchCartItems();
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Success', message: 'Product added to cart');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Error', message: 'Failed to add to cart: $e');
    }
  }

  // Update cart item quantity
  Future<void> updateQuantity(CartModel cartItem, int newQuantity) async {
    if (userId == null || newQuantity < 1) return;

    try {
      double price = double.parse(
          cartItem.isSale ? cartItem.salePrice : cartItem.fullPrice);

      await _firestore
          .collection('cart')
          .doc(userId)
          .collection('cartOrders')
          .doc(cartItem.productId)
          .update({
        'productQuantity': newQuantity,
        'productTotalPrice': price * newQuantity,
      });

      await fetchCartItems();
    } catch (e) {
      showCustomSnackbar(
          title: 'Error', message: 'Failed to update quantity: $e');
    }
  }

  // Remove item from cart
  Future<void> removeFromCart(String productId) async {
    if (userId == null) return;

    try {
      EasyLoading.show(status: 'Removing item...');

      await _firestore
          .collection('cart')
          .doc(userId)
          .collection('cartOrders')
          .doc(productId)
          .delete();

      await fetchCartItems();
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Success', message: 'Item removed from cart');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Error', message: 'Failed to remove item: $e');
    }
  }

  // Clear entire cart
  Future<void> clearCart() async {
    if (userId == null) return;

    try {
      EasyLoading.show(status: 'Clearing cart...');

      QuerySnapshot snapshot = await _firestore
          .collection('cart')
          .doc(userId)
          .collection('cartOrders')
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      cartItems.clear();
      totalPrice.value = 0.0;
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Success', message: 'Cart cleared');
    } catch (e) {
      EasyLoading.dismiss();
      showCustomSnackbar(title: 'Error', message: 'Failed to clear cart: $e');
    }
  }

  // Calculate total price
  void calculateTotalPrice() {
    totalPrice.value = cartItems.fold(
      0.0,
      (total, item) => total + item.productTotalPrice,
    );
  }

  // Check if product is in cart
  bool isProductInCart(String productId) {
    return cartItems.any((item) => item.productId == productId);
  }

  // Get cart item count
  int get cartItemCount => cartItems.length;

  // Get total items quantity
  int get totalItemsQuantity {
    return cartItems.fold(0, (total, item) => total + item.productQuantity);
  }
}
