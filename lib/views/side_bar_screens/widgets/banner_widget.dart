import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/banner_controller.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/banner.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late Future<List<BannerModel>> futureBanner;

  @override
  void initState() {
    super.initState();
    futureBanner = BannerController().loadBanners();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureBanner,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          else if(snapshot.hasError) {
            return Center(
              child: Text(
                "Error: ${snapshot.error}"
              ),
            );
          }
    //Không có dữ liệu
          else if(!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                  "Không có Banners trong database"
              ),
            );
          }
          else {
            final banners = snapshot.data!; //Data vẫn là Json
            return GridView.builder(
              shrinkWrap: true,
              itemCount: banners.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
              ),
              itemBuilder: (context,index) {
                final banner = banners[index];
                return Image.network(
                    width: 50,
                    height: 50,
                    banner.image
                );
              }
            );
          }
        }
    );
  }
}
