import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/category_controllers.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/category.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {

  late Future<List<Category>> futureCategories;
  @override
  //initState sử dụng để thiết lập trạng thái ban đầu của widget hoặc khởi tạo các tác vụ bất đồng bộ
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryControllers().loadCategories();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(future: futureCategories, builder: (context,snapshot) {
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
              "Không có Categories nào trong database"
          ),
        );
      }
      else {
        final categories = snapshot.data!; //Data vẫn là Json q
        return GridView.builder(
            shrinkWrap: true,
            itemCount: categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context,index) {
              final banner = categories[index];
              return Column(
                children: [
                  Image.network(
                      width: 100,
                      height: 100,
                      banner.image
                  ),
                  Text(banner.name)
                ]
              );
            }
        );
      }
    });
  }
}
