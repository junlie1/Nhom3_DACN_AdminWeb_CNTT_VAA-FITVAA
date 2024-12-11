import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/category_controllers.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/subcategory_controller.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/widgets/subcategory_widget.dart';

import '../../models/category.dart';

class SubcategoryScreen extends StatefulWidget {
  static const String id = 'subcategory-screen';
  const SubcategoryScreen({super.key});

  @override
  State<SubcategoryScreen> createState() => _SubcategoryScreenState();
}

class _SubcategoryScreenState extends State<SubcategoryScreen> {
  //Khai báo biến
  late Future<List<Category>> futureCategories;
  Category? selectedCategory;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  dynamic _image;
  late String name;
  SubcategoryController subcategoryController = SubcategoryController();

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if(result != null) {
      setState(() {
        _image = result.files.first.bytes;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureCategories = CategoryControllers().loadCategories();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //Subcategories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Sub Categories",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold //Tô đậm,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
          //Xử lý việc
          //Đợi kết qả hiển thị danh sách Categories
            Padding(
              padding: const EdgeInsets.fromLTRB(20,8,10,20),
              child: FutureBuilder(future: futureCategories, builder: (context,snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                else if(!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text("Không có dữ liệu của Categories trong DB"),
                  );
                }
                else if(snapshot.hasError) {
                  return Center(
                    child: Text("Error: ${snapshot.error}"),
                  );
                }
                else {
                  return DropdownButton<Category>(
                      value: selectedCategory,
                      hint: Text("Chọn Category"),
                      items: snapshot.data!.map((Category category){
                        return DropdownMenuItem(
                            value: category,
                            child: Text(category.name)
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                          print("Selected Category: ${selectedCategory?.name}");
                        });
                      }
                  );
                }
              }),
            ),
          //Form thêm Sub
            Row(
              children: [
         //Khung box chứa ảnh
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 100, 10),
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: _image != null ? Image.memory(_image) : Text("SubCategory Image"),
                    ),
                  ),
                ),
        //Input Sub
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (value) {
                      name = value;
                    },
                    validator: (value) {
                      if(value!.isNotEmpty) {
                        return null;
                      }
                      else {
                        return "Hãy nhập tên sản phẩm con";
                      }
                    },
                    decoration: InputDecoration(
                        labelText: "Nhập sản phẩm",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)
                        )
                    ),
                  ),
                ),
                //Button Save
                Padding(
                  padding: const EdgeInsets.fromLTRB(100, 10, 20, 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue
                      ),
                      onPressed:() async {
                        if(_formKey.currentState!.validate()) {
                          await subcategoryController.uploadSubcategory(
                              context: context,
                              categoryId: selectedCategory!.id,
                              categoryName: selectedCategory!.name,
                              pickedImage: _image,
                              subCategoryName: name)
                          .then((_) {
                            setState(() {
                              _image = null;
                              name = '';
                              _formKey.currentState!.reset();
                            });
                          });
                          print(selectedCategory!.name);
                          print(selectedCategory!.image);
                        }
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      )
                  ),
                ),
                //Button Cancel
                TextButton(
                    onPressed: () {},
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.red
                      ),
                    )
                ),
              ],
            ),
            //Pick Image
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 8, 100, 10),
              child: ElevatedButton(
                onPressed: () {
                  pickImage();
                },
                child: Text(
                    "Chọn ảnh"
                ),
              ),
            ),
      
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
      
            SubcategoryWidget(selectedCategory: selectedCategory)
          ],
        ),
      ),
    );
  }
}
