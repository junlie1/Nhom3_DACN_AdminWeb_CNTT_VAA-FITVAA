import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/sub_category.dart';
import 'package:http/http.dart' as http;
import 'package:web_do_an_chuyen_nganh_nhom3/service/manager_http_response.dart';

import '../global_variable.dart';



class SubcategoryController {
  uploadSubcategory({required context, required String categoryId, required String categoryName, required dynamic pickedImage,  required String subCategoryName,
  }) async{
    try{
      final _cloudinary = CloudinaryPublic("dotszztq0", 'upload_nhom3');

      //Upload Image
      CloudinaryResponse imageResponse = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(pickedImage, identifier: 'pickedImage', folder: 'subCategoryImage')
      );
      String image = imageResponse.secureUrl;
      
      SubCategory subCategory = SubCategory(
          id: '',
          categoryId: categoryId,
          categoryName: categoryName,
          image: image,
          subCategoryName: subCategoryName
      );
      http.Response response = await http.post(
          Uri.parse("$uri/api/subcategories"),
          body: subCategory.toJson(),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      managerHttpResponse(
          response: response,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Thêm sản phẩm con thành công");
          }
      );
    }
    catch(e) {
      print("Upload failed: $e");
      showSnackBar(context, "Không thể thêm sản phẩm con. Vui lòng thử lại.");
    }
  }

  Future<List<SubCategory>> loadsubcategories() async{
    try{
      http.Response response = await http.get(
          Uri.parse("$uri/api/subcategories"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<SubCategory> subcategories = data.map((subcategory) => SubCategory.fromJson(subcategory)).toList();
        return subcategories;
      }
      else {
        throw Exception("Không nhận đc phản hồi từ DB");
      }
    }
    catch(e) {
      throw Exception("Lỗi kết nối loadsubcategories");
    }
  }

  Future<List<SubCategory>> loadsubcategoriesByCategory(String categoryName) async{
    try{
      http.Response response = await http.get(
          Uri.parse("$uri/api/category/$categoryName/subcategories"),
          headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<SubCategory> subcategoriesByCategory = data.map((subcategory) => SubCategory.fromJson(subcategory)).toList();
        return subcategoriesByCategory;
      }
      else {
        throw Exception("Không nhận đc phản hồi từ DB");
      }
    }
    catch(e) {
      throw Exception("Lỗi kết nối loadsubcategoriesByCategory");
    }
  }

  Future<void> deleteSubcategory({required String subcategoryId, required context}) async {
    try {
      http.Response response = await http.delete(
        Uri.parse("$uri/api/subcategories/delete-subcategories/$subcategoryId"),
        headers: <String,String> {
          "Content-Type": 'application/json; charset=UTF-8'
        }
      );
      managerHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, "Bạn đã xóa subcategoy thành công");
      });
    }
    catch(e) {
      
    }
  }

  Future<void> updateSubcategory({
    required String subcategoryId,
    required Map<String, dynamic> updateData,
    required context,
  }) async  {
    try {
      http.Response response = await http.put(
        Uri.parse("$uri/api/subcategory/update/$subcategoryId"),
        headers: <String,String> {
          "Content-Type": 'application/json; charset=UTF-8'
        },
        body: jsonEncode(updateData),
      );
      if(response.statusCode == 200) {
        managerHttpResponse(response: response, context: context, onSuccess: () {
          showSnackBar(context, "Update sản phẩm thành công");
        });
      }
      else {
        showSnackBar(context, "Lỗi khi update");
      }
    }
    catch(e) {
      showSnackBar(context, "Lỗi $e");
    }
  }
}