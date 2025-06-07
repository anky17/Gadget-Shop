class CategoryModel {
  final String categoryId;
  final String categoryName;
  final String categoryImg;
  final dynamic createdAt;
  final dynamic updatedAt;

  CategoryModel(
      {required this.categoryId,
      required this.categoryName,
      required this.categoryImg,
      required this.createdAt,
      required this.updatedAt});

// CategoryModel to Json object
  Map<String, dynamic> toMap() {
    return {
      'categoryId': categoryId,
      'categoryName': categoryName,
      'categoryImg': categoryImg,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

// Json to CategoryModel object
  factory CategoryModel.fromMap(Map<String, dynamic> json) {
    return CategoryModel(
        categoryId: json['categoryId'],
        categoryName: json['categoryName'],
        categoryImg: json['categoryImg'],
        createdAt: json['createdAt'],
        updatedAt: json['updatedAt']);
  }
}
