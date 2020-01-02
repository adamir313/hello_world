import 'package:flutter/material.dart';
import 'package:hello_world/models/product.dart';
import 'package:hello_world/widgets/products/product_fab.dart';
import 'package:hello_world/widgets/ui_elements/title_default.dart';

class ProductPage extends StatelessWidget {
  final Product product;

  ProductPage(this.product);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text(product.title),
        // ),
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              expandedHeight: 256.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Hero(
                  tag: product.id,
                  child: FadeInImage(
                    image: NetworkImage(product.image),
                    height: 300.0,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/food.jpg'),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: TitleDefault(product.title)),
                _buildAddressPriceRow(product.location.address, product.price),
                Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      product.description,
                      textAlign: TextAlign.center,
                    ))
              ]),
            )
          ],
        ),
        floatingActionButton: ProductFAB(product),
      ),
    );
  }

  Widget _buildAddressPriceRow(String address, double price) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      GestureDetector(
        child: Text(
          address,
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        onTap: _showMap,
      ),
      Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          )),
      Text(
        '\$' + price.toString(),
        style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
      ),
    ]);
  }

  void _showMap() {}

  _showWarningDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Are you sure?'),
            content: Text('This action cannot be undone!'),
            actions: <Widget>[
              FlatButton(
                child: Text('Discard'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('Continue'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context, true);
                },
              )
            ],
          );
        });
  }
}
