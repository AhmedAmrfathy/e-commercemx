import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_ovverview_screens.dart';
import 'package:shop_app/screens/userproductscreen.dart';
import '../screens/orders_screens.dart';

class Drawerr extends StatelessWidget {
  BuildContext cont;


  Drawerr(this.cont);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Jumia Store !',style: TextStyle(fontSize: 25),),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop,color: Colors.black,),
            title: Text('Shop',style: TextStyle(color: Colors.black),),
            onTap: () {
              Navigator.pushReplacementNamed(context,ProductOvverViewScreen.route);
            },
          ),
          ListTile(
            leading: Icon(Icons.payment,color: Colors.black),
            title: Text('Orders',style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushReplacementNamed(context,OrderScreen.orderscreenroute);
            },
          ),
          ListTile(
            leading: Icon(Icons.edit,color: Colors.black),
            title: Text('Manage Products',style: TextStyle(color: Colors.black)),
            onTap: () {
              Navigator.pushReplacementNamed(context,UserProductScreen.userproductrte);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app,color: Colors.black),
            title: Text('Log Out',style: TextStyle(color: Colors.black)),
            onTap: () {
             Navigator.of(context).pop();
             Provider.of<Auth>(context,listen: false).logout();
             Navigator.pushReplacementNamed(cont,AuthScreen.routeName);

            },
          ),
        ],
      ),
    );
  }
}
