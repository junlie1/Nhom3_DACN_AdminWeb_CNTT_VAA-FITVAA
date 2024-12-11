import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/category_controllers.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/widgets/category_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = '\categoryScreen';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  //import controllers
  CategoryControllers _categoryControllers = CategoryControllers();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  dynamic _image;
  dynamic _bannerImage;
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
  pickBannerImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if(result != null) {
      setState(() {
        _bannerImage = result.files.first.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          //Chữ Categories
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Categories",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold //Tô đậm,
                  ),
                ),
              ),
            ),
        //Divide
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
        
          //Form thêm Categories
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
                      child: _image != null ? Image.memory(_image) : Text("Category Image"),
                    ),
                  ),
                ),
        //Input categories
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
                        return "Hãy nhập loại sản phẩm";
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Nhập loại sản phẩm",
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
                      onPressed: () {
                        if(_formKey.currentState!.validate()) {
                          _categoryControllers.uploadCategory(
                              name: name,
                              pickedImage: _image,
                              pickedBanner: _bannerImage,
                              context: context
                          ).then((_) {
                            setState(() {
                              _image = null;
                              _bannerImage = null;
                              name = '';
                              _formKey.currentState!.reset();
                            });
                          });
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
        //Devide
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
        
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
                  child: _bannerImage != null ? Image.memory(_bannerImage) : Text("Category Banner"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 8, 100, 10),
              child: ElevatedButton(
                onPressed: () {
                  pickBannerImage();
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
        
            CategoryWidget()
          ],
        ),
      ),
    );
  }
}
