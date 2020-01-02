import 'package:flutter/material.dart';
import 'package:hello_world/Pages/auth.dart';
import 'package:hello_world/Pages/products.dart';
import 'package:hello_world/Pages/products_admin.dart';
import 'package:hello_world/scoped-models/main.dart';
import 'package:hello_world/widgets/helper/custom_route.dart';
import 'package:scoped_model/scoped_model.dart';

import 'Pages/product.dart';
import 'models/product.dart';
//import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.deepOrange,
              accentColor: Colors.deepPurple,
              buttonColor: Colors.deepPurple),
          //home: AuthPage(),
          routes: {
            '/': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsPage(_model),
            '/admin': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : ProductsAdminPage(_model)
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => AuthPage());
            }
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'product') {
              final String productId = pathElements[2];
              final Product product =
                  _model.allProducts.firstWhere((Product product) {
                return product.id == productId;
              });
              //Custom route animation
              return CustomRoute<bool>(
                  builder: (BuildContext context) =>
                      !_isAuthenticated ? AuthPage() : ProductPage(product));
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : ProductsPage(_model));
          },
        ));
  }
}
