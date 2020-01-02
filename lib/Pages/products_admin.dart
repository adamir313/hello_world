import 'package:flutter/material.dart';
import 'package:hello_world/Pages/product_edit.dart';
import 'package:hello_world/Pages/product_list.dart';
import 'package:hello_world/scoped-models/main.dart';
import 'package:hello_world/widgets/ui_elements/logout_list_tile.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;

  ProductsAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          drawer: _buildSideDrawer(context),
          appBar: AppBar(
            title: Text('Manage Products'),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: 'Create Product',
                ),
                Tab(text: 'My Products')
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[ProductEditPage(), ProductListPage(model)],
          ),
        ));
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Choose'),
            elevation:
                Theme.of(context).platform == TargetPlatform.iOS ? 0.0 : 4.0,
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('All Products'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
}
