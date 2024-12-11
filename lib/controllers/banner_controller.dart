import 'dart:convert';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:http/http.dart' as http;
import 'package:web_do_an_chuyen_nganh_nhom3/global_variable.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/banner.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/service/manager_http_response.dart';

class BannerController {
  uploadBanner({required dynamic pickedImage, required context}) async {
    try{
      final _cloudinary = CloudinaryPublic("dotszztq0", 'upload_nhom3');
      CloudinaryResponse imageResponse = await _cloudinary.uploadFile(
        CloudinaryFile.fromBytesData(pickedImage, identifier: 'pickedImage', folder: "Banners")
      );
      String image = imageResponse.secureUrl;

      //Gửi data cho db xử lý
      BannerModel bannerModel = BannerModel(id: "", image: image);
      http.Response response = await http.post(
        Uri.parse("$uri/api/banner"),
        body: bannerModel.toJson(),
        headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
       managerHttpResponse(response: response, context: context, onSuccess: () {
         showSnackBar(context, "Upload Banner thành công");
       });
    }
    catch(e) {
      print("Upload failed: $e");
    }
  }

  //Lấy Banners
  Future<List<BannerModel>> loadBanners() async {
    try {
      http.Response response = await http.get(
        Uri.parse("$uri/api/banner"),
        headers: <String,String> {
            "Content-Type": 'application/json; charset=UTF-8'
          }
      );
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200) {
         List<dynamic> data = jsonDecode(response.body);
         List<BannerModel> banners = data.map(
          (banner) {
           return BannerModel.fromJson(banner);
         }
         ).toList();

      return banners;
      }
      else{
        print("Failed to load banners: ${response.statusCode}");
        return [];
      }
    }
    catch(e) {
      // Bắt lỗi và trả về danh sách rỗng nếu có lỗi
      print("Error loading banners: $e");
      return [];
    }
  }
}