import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/category_controllers.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/subcategory_controller.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/category.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/models/sub_category.dart';

class SubcategoryWidget extends StatelessWidget {
  final Category? selectedCategory;
  const SubcategoryWidget({Key? key, this.selectedCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void _deleteSubcategory(BuildContext context, SubCategory subcategory) {
      // Hiển thị hộp thoại xác nhận
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
                  // Gọi hàm xóa trong controller
                  await SubcategoryController().deleteSubcategory(subcategoryId: subcategory.id, context: context);
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
    Future<List<Category>> futureCategories = CategoryControllers().loadCategories();

    void _updateSubcategory(BuildContext context, SubCategory subcategory) {
      final TextEditingController nameController =
      TextEditingController(text: subcategory.subCategoryName);
      Category? selectedCategory;
      dynamic _imageFile;

      Future<void> pickImage() async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
        );
        if (result != null) {
          _imageFile = result.files.first.bytes;
        }
      }

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Cập nhật SubCategory'),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      // DropdownButton for categoryName
                      FutureBuilder<List<Category>>(
                        future: futureCategories,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Lỗi: ${snapshot.error}');
                          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return Text('Không có danh mục để chọn');
                          } else {
                            // Gán danh mục hiện tại nếu chưa được chọn
                            if (selectedCategory == null) {
                              selectedCategory = snapshot.data!.firstWhere(
                                    (category) =>
                                category.name == subcategory.categoryName,
                                orElse: () => snapshot.data!.first,
                              );
                            }
                            return DropdownButton<Category>(
                              value: snapshot.data!.contains(selectedCategory)
                                  ? selectedCategory
                                  : snapshot.data!.first,
                              hint: Text('Chọn Category'),
                              items: snapshot.data!.map((Category category) {
                                return DropdownMenuItem<Category>(
                                  value: category,
                                  child: Text(category.name),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value!;
                                });
                              },
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      // Display current image
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: _imageFile != null
                            ? Image.memory(_imageFile)
                            : Image.network(subcategory.image),
                      ),
                      SizedBox(height: 10),
                      // Button to pick a new image
                      ElevatedButton(
                        onPressed: () async {
                          await pickImage();
                          setState(() {});
                        },
                        child: Text('Chọn ảnh mới'),
                      ),
                      SizedBox(height: 10),
                      // Input for subCategoryName
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Tên SubCategory',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
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

                      // Gọi API cập nhật SubCategory
                      await SubcategoryController().updateSubcategory(
                        subcategoryId: subcategory.id,
                        updateData: {
                          'subCategoryName': nameController.text,
                          'image': _imageFile ?? subcategory.image,
                          'categoryName': selectedCategory?.name ??
                              subcategory.categoryName,
                        },
                        context: context,
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Đã cập nhật SubCategory: ${nameController.text}'),
                        ),
                      );
                    },
                    child: Text(
                      'Cập nhật',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              );
            },
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
              return Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  width: 150,
                  height: 150,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                                  _updateSubcategory(context, subcategory);
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
                      Text(subcategory.subCategoryName)
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
