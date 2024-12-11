import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/controllers/banner_controller.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/widgets/banner_widget.dart';

class UploadBannerScreen extends StatefulWidget {
  static const String id = 'banner-screen';

  const UploadBannerScreen({super.key});

  @override
  State<UploadBannerScreen> createState() => _UploadBannerScreenState();
}

class _UploadBannerScreenState extends State<UploadBannerScreen> {

  BannerController _bannerController = BannerController();
  dynamic _image;

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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
  //Chữ Banners
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.topLeft,
            child: Text(
              "Banners",
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
  //Thêm Banners
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
                  child: _image != null ? Image.memory(_image) : Text("Banner Image"),
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
                  onPressed: () async{
                    await _bannerController.uploadBanner(pickedImage: _image, context: context);
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

        BannerWidget()
      ],
    );
  }
}
