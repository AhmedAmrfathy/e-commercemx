import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screens.dart';
import '../widgets/productgridviewbody.dart';
import '../widgets/badge.dart';
import '../widgets/drawer.dart';
import '../providers/product_provider.dart';

class ProductOvverViewScreen extends StatefulWidget {
  static const route = 'baseroute';

  @override
  _ProductOvverViewScreenState createState() => _ProductOvverViewScreenState();
}

class _ProductOvverViewScreenState extends State<ProductOvverViewScreen> {
  var _isfavourite = false;

//  @override
//  void initState() {
//    Provider.of<ProductProvider>(context,listen: false).fetchdatafromserverandset();
//    super.initState();
//  }
  var _isinit = true;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<ProductProvider>(context, listen: false)
          .fetchdatafromserverandset();
    }
    _isinit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredSizeWidget abar=AppBar(
      title: Text('Jumia',
          style: TextStyle(
            fontSize: 30,
          )),
      actions: <Widget>[
        FlatButton.icon(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed(AuthScreen.routeName),
          icon: Icon(
            Icons.supervised_user_circle,
            color: Colors.black,
          ),
          label: Text(
            'log out',
            style: TextStyle(color: Colors.black),
          ),
        ),
        PopupMenuButton(
          elevation: 8,
          color: Colors.amberAccent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          onSelected: (int selecteditem) {
            setState(() {
              if (selecteditem == 0) {
                _isfavourite = true;
              } else {
                _isfavourite = false;
              }
            });
          },
          icon: Icon(Icons.more_vert),
          itemBuilder: (ctx) {
            return [
              PopupMenuItem(
                child: Text('only favourit'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('all items'),
                value: 1,
              )
            ];
          },
        ),
        Consumer<Cart>(
          builder: (c, cartt, cc) => Badge(
            child: cc,
            value: cartt.itemcount.toString(),
          ),
          child: IconButton(
            icon: Icon(
              Icons.shopping_cart,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.cartscreen);
            },
          ),
        ),
      ],
    );
    print('product ovverview');
    return Scaffold(
        appBar: abar,
        drawer: Drawerr(context),
        body: ProductGridviewBody(_isfavourite,abar.preferredSize));
  }
}
