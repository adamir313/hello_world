import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/scoped-models/main.dart';
import 'package:hello_world/widgets/products/product_card.dart';
import 'package:scoped_model/scoped_model.dart';

class Products extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }

  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index]),
        itemCount: products.length,
      );
    } else {
      productCards = Center(
        child: Text('No product found. add!'),
      );
    }
    return productCards;
  }
}
