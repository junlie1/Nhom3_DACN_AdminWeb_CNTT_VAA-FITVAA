import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/global_variable.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:web_do_an_chuyen_nganh_nhom3/service/manager_http_response.dart';

class CategoryControllers {
  uploadCategory({required dynamic pickedImage, required dynamic pickedBanner, required String name,required context}) async{
    try {
      final _cloudinary = CloudinaryPublic("dotszztq0", 'upload_nhom3');

      //Upload Image
      CloudinaryResponse imageResponse = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage, identifier: 'pickedImage', folder: 'categoryImages')
      );
      String image = imageResponse.secureUrl;

      //Upload Banner
      CloudinaryResponse bannerResponse = await _cloudinary.uploadFile(
          CloudinaryFile.fromBytesData(pickedBanner, identifier: 'pickedBanner', folder: 'categoryImages')
      );
      String banner = bannerResponse.secureUrl;

      //Gọi models Category, dùng toJson để gửi đi DB
      Category category = Category(
          id: "",
          name: name,
          image: image,
          banner: banner
      );
      http.Response response = await http.post(
        Uri.parse("$uri/api/categories"),
        body: category.toJson(),
        headers: <String,String> {
          "Content-Type": 'application/json; charset=UTF-8'
        }
      );
      print(response.statusCode);
      managerHttpResponse(response: response, context: context, onSuccess: () {
        showSnackBar(context, "Upload thành công");
      });
    }
    catch(e) {
      print("Upload failed: $e");
    }
  }

  Future<List<Category>> loadCategories() async{
    try{
      http.Response response = await http.get(
        Uri.parse("$uri/api/categories"),
        headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      if(response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        List<Category> categories = data.map((category) => Category.fromJson(category)).toList();
        return categories;
      }
      else {
        throw Exception("Không nhận đc phản hồi từ DB");
      }
    }
    catch(e) {
      throw Exception("Lỗi kết nối");
    }
  }
}