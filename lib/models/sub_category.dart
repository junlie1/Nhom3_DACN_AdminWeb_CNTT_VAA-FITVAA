import 'dart:async';
import 'dart:convert';

class SubCategory {
  final String id;
  final String categoryId;
  final String categoryName;
  final String image;
  final String subCategoryName;

  SubCategory(
      {
        required this.id,
        required this.categoryId,
        required this.categoryName,
        required this.image,
        required this.subCategoryName
      }
      );
  Map<String, dynamic> toMap() {
    return <String,dynamic> {
      'id': id,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'image': image,
      'subCategoryName': subCategoryName,

    };
  }

  String toJson() => jsonEncode(toMap());

  
  factory SubCategory.fromJson(Map<String,dynamic> map) {
    return SubCategory(
        id: map['_id'] as String,
        categoryId: map['categoryId'] as String,
        categoryName: map['categoryName'] as String,
        image: map['image'] as String,
        subCategoryName: map['subCategoryName'] as String);
  }

}