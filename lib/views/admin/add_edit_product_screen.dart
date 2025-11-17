import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadgetshop/controllers/admin_product_controller.dart';
import 'package:gadgetshop/controllers/admin_category_controller.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/core/utils/snackbar_utils.dart';
import 'package:gadgetshop/models/products_model.dart';
import 'package:get/get.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;

  const AddEditProductScreen({super.key, this.product});

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminProductController productController =
      Get.find<AdminProductController>();
  final AdminCategoryController categoryController =
      Get.find<AdminCategoryController>();

  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController salePriceController;
  late TextEditingController fullPriceController;
  late TextEditingController deliveryTimeController;
  late TextEditingController imageUrlController;

  String? selectedCategoryId;
  String? selectedCategoryName;
  bool isSale = false;
  List<String> productImages = [];

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.product?.productName ?? '');
    descriptionController =
        TextEditingController(text: widget.product?.productDescription ?? '');
    salePriceController =
        TextEditingController(text: widget.product?.salePrice ?? '');
    fullPriceController =
        TextEditingController(text: widget.product?.fullPrice ?? '');
    deliveryTimeController =
        TextEditingController(text: widget.product?.deliveryTime ?? '1-3 days');
    imageUrlController = TextEditingController();

    if (widget.product != null) {
      selectedCategoryId = widget.product!.categoryId;
      selectedCategoryName = widget.product!.categoryName;
      isSale = widget.product!.isSale;
      productImages = List<String>.from(widget.product!.productImages);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    salePriceController.dispose();
    fullPriceController.dispose();
    deliveryTimeController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: AppConstant.appTextColor,
        backgroundColor: AppConstant.appMainColor,
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstant.appTextColor,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Product Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              Obx(() {
                if (categoryController.categories.isEmpty) {
                  return const Text(
                      'No categories available. Please add categories first.');
                }

                return DropdownButtonFormField<String>(
                  initialValue: selectedCategoryId,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.category),
                  ),
                  items: categoryController.categories.map((category) {
                    return DropdownMenuItem(
                      value: category.categoryId,
                      child: Text(category.categoryName),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategoryId = value;
                      selectedCategoryName = categoryController.categories
                          .firstWhere((cat) => cat.categoryId == value)
                          .categoryName;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                );
              }),
              const SizedBox(height: 16),

              // Sale Price
              TextFormField(
                controller: salePriceController,
                decoration: const InputDecoration(
                  labelText: 'Sale Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter sale price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Full Price
              TextFormField(
                controller: fullPriceController,
                decoration: const InputDecoration(
                  labelText: 'Full Price',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money_off),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter full price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Delivery Time
              TextFormField(
                controller: deliveryTimeController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Time',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping),
                  hintText: 'e.g., 1-3 days',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter delivery time';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Flash Sale Toggle
              SwitchListTile(
                title: const Text('Flash Sale'),
                subtitle: const Text('Enable this product for flash sale'),
                value: isSale,
                onChanged: (value) {
                  setState(() {
                    isSale = value;
                  });
                },
                activeTrackColor: AppConstant.appMainColor,
              ),
              const SizedBox(height: 16),

              // Product Images Section
              const Text(
                'Product Images',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Add Image URL
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: imageUrlController,
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                        border: OutlineInputBorder(),
                        hintText: 'Enter image URL',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      if (imageUrlController.text.isNotEmpty) {
                        setState(() {
                          productImages.add(imageUrlController.text);
                          imageUrlController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppConstant.appTextColor,
                      backgroundColor: AppConstant.appMainColor,
                      padding: const EdgeInsets.all(16),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Display Added Images
              if (productImages.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(productImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.cancel, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  productImages.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  foregroundColor: AppConstant.appTextColor,
                  backgroundColor: AppConstant.appMainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.product == null ? 'Add Product' : 'Update Product',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (selectedCategoryId == null) {
        showCustomSnackbar(title: 'Error', message: 'Please select a category');
        return;
      }

      if (productImages.isEmpty) {
        showCustomSnackbar(
            title: 'Error', message: 'Please add at least one product image');
        return;
      }

      final productId = widget.product?.productId ??
          FirebaseFirestore.instance.collection('products').doc().id;

      final product = ProductModel(
        productId: productId,
        categoryId: selectedCategoryId!,
        productName: nameController.text,
        categoryName: selectedCategoryName!,
        salePrice: salePriceController.text,
        fullPrice: fullPriceController.text,
        productImages: productImages,
        deliveryTime: deliveryTimeController.text,
        isSale: isSale,
        productDescription: descriptionController.text,
        createdAt: widget.product?.createdAt ?? FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      );

      if (widget.product == null) {
        await productController.addProduct(product);
      } else {
        await productController.updateProduct(product);
      }

      Get.back();
    }
  }
}
