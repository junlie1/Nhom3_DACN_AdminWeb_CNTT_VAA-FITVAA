import 'package:flutter/cupertino.dart';

class ProductsScreen extends StatelessWidget {
  static const String id = 'products-screen';

  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
          "Product "
      ),
    );
  }
}
