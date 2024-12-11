import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/buyers_screen.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/category_screen.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/orders_screen.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/products_screen.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/subcategory_screen.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/upload_banner_screen.dart';
import 'package:web_do_an_chuyen_nganh_nhom3/views/side_bar_screens/vendors_screen.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget _selectedScreen = VendorsScreen();

  //Tạo hàm chuyển đổi trang
  screenSelector(item) {
    // print(item.route);
    switch(item.route){
      case VendorsScreen.id:
        setState(() {
          _selectedScreen = VendorsScreen();
        });
      case BuyersScreen.id:
        setState(() {
          _selectedScreen = BuyersScreen();
        });
        break;
      case OrdersScreen.id:
        setState(() {
          _selectedScreen = OrdersScreen();
        });
        break;
      case CategoryScreen.id:
        setState(() {
          _selectedScreen = CategoryScreen();
        });
        break;
      case SubcategoryScreen.id:
        setState(() {
          _selectedScreen = SubcategoryScreen();
        });
        break;
      case UploadBannerScreen.id:
        setState(() {
          _selectedScreen = UploadBannerScreen();
        });
        break;
      case ProductsScreen.id:
        setState(() {
          _selectedScreen = ProductsScreen();
        });
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        title: Text("Nhóm 3 - Admin"),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: _selectedScreen,
      sideBar: SideBar(
        items: [
          AdminMenuItem(title: "Vendors",route: VendorsScreen.id, icon: CupertinoIcons.person_3,),
          AdminMenuItem(title: "Buyers",route: BuyersScreen.id, icon: CupertinoIcons.person),
          AdminMenuItem(title: "Orders",route: OrdersScreen.id, icon: CupertinoIcons.shopping_cart),
          AdminMenuItem(title: "Categories",route: CategoryScreen.id, icon: Icons.category),
          AdminMenuItem(title: "Subcategories",route: SubcategoryScreen.id, icon: Icons.category_outlined),
          AdminMenuItem(title: "Upload Banner",route: UploadBannerScreen.id, icon: Icons.upload),
          AdminMenuItem(title: "Products",route: ProductsScreen.id, icon: Icons.store),
        ],
        selectedRoute: '',
        onSelected: (item) {
          screenSelector(item);
        },
      ),
    );
  }
}
