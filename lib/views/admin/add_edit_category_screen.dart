import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gadgetshop/controllers/admin_category_controller.dart';
import 'package:gadgetshop/core/utils/app_constant.dart';
import 'package:gadgetshop/models/category_model.dart';
import 'package:get/get.dart';

class AddEditCategoryScreen extends StatefulWidget {
  final CategoryModel? category;

  const AddEditCategoryScreen({super.key, this.category});

  @override
  State<AddEditCategoryScreen> createState() => _AddEditCategoryScreenState();
}

class _AddEditCategoryScreenState extends State<AddEditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final AdminCategoryController controller =
      Get.find<AdminCategoryController>();

  late TextEditingController nameController;
  late TextEditingController imageUrlController;

  @override
  void initState() {
    super.initState();
    nameController =
        TextEditingController(text: widget.category?.categoryName ?? '');
    imageUrlController =
        TextEditingController(text: widget.category?.categoryImg ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
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
          widget.category == null ? 'Add Category' : 'Edit Category',
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
              // Category Name
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter category name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image URL
              TextFormField(
                controller: imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.image),
                  hintText: 'Enter image URL',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Image Preview
              if (imageUrlController.text.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: imageUrlController.text,
                      fit: BoxFit.cover,
                      placeholder: (context, url) {
                        return const Center(
                          child: Text('Invalid image URL'),
                        );
                      },
                    ),
                  ),
                ),
              const SizedBox(height: 24),

              // Save Button
              ElevatedButton(
                onPressed: _saveCategory,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstant.appMainColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.category == null ? 'Add Category' : 'Update Category',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCategory() async {
    if (_formKey.currentState!.validate()) {
      final categoryId = widget.category?.categoryId ??
          FirebaseFirestore.instance.collection('categories').doc().id;

      final category = CategoryModel(
        categoryId: categoryId,
        categoryName: nameController.text,
        categoryImg: imageUrlController.text,
        createdAt: widget.category?.createdAt ?? FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      );

      if (widget.category == null) {
        await controller.addCategory(category);
      } else {
        await controller.updateCategory(category);
      }

      Get.back();
    }
  }
}
