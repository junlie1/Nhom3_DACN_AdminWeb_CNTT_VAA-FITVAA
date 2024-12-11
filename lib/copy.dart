import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/subcategory_controller.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/category.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/sub_category.dart';

class SubcategoryWidget extends StatelessWidget {
  final Category? selectedCategory;
  const SubcategoryWidget({Key? key, this.selectedCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _deleteSubcategory(BuildContext context, SubCategory subcategory) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Xóa SubCategory'),
            content: Text('Bạn có chắc chắn muốn xóa "${subcategory.subCategoryName}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  await SubcategoryController().deleteSubcategory(subcategoryId: subcategory.id, context: context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã xóa "${subcategory.subCategoryName}".')),
                  );
                },
                child: Text(
                  'Xóa',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    final futureSubcategories = selectedCategory != null
        ? SubcategoryController().loadsubcategoriesByCategory(selectedCategory!.name)
        : SubcategoryController().loadsubcategories();

    return FutureBuilder<List<SubCategory>>(
      future: futureSubcategories,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Text("Không có Subcategories nào trong database"),
          );
        } else {
          final subcategories = snapshot.data!;
          return GridView.builder(
            shrinkWrap: true,
            itemCount: subcategories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              crossAxisSpacing: 6,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final subcategory = subcategories[index];
              return SizedBox(
                width: 150,
                height: 150,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Hình ảnh
                    Image.network(
                      subcategory.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                    // Các biểu tượng
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.update,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            // Thêm logic cập nhật tại đây
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _deleteSubcategory(context, subcategory);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}
