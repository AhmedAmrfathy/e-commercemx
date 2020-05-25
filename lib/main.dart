import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/order.dart';
import 'package:shop_app/screens/auth_screen.dart';
import './screens/product_ovverview_screens.dart';
import './screens/product_details_screens.dart';
import './providers/product_provider.dart';
import 'package:provider/provider.dart';
import './screens/cart_screens.dart';
import './screens/orders_screens.dart';
import './screens/userproductscreen.dart';
import './screens/editproductscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, ProductProvider>(
          update: (ctx, auth, previousproduct) => ProductProvider(
              auth.token, previousproduct == null ? [] : previousproduct.items,auth.userid),
        ),
        ChangeNotifierProvider.value(value: Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (ctx, auth, previosorders) => Order(auth.token,previosorders==null?[]:previosorders.orderitems,auth.userid),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, authdata, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primaryColor: Colors.amberAccent,
            accentColor: Colors.deepOrange,
          ),
          home: AuthScreen(),//authdata.isauth ? ProductOvverViewScreen() : AuthScreen(),
          routes: {
            AuthScreen.routeName:(ctx)=>AuthScreen(),
            ProductOvverViewScreen.route: (ctx) => ProductOvverViewScreen(),
            ProductDetails.productdetilsroute: (ctx) => ProductDetails(),
            CartScreen.cartscreen: (ctx) => CartScreen(),
            OrderScreen.orderscreenroute: (ctx) => OrderScreen(),
            UserProductScreen.userproductrte: (ctx) => UserProductScreen(),
            EditProductScreen.editproductscreenroute: (CTX) =>
                EditProductScreen()
          },
        ),
      ),
    );
  }
}
