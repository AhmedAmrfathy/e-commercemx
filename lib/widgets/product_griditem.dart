import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import '../providers/product.dart';
import '../providers/cart.dart';
import '../screens/product_details_screens.dart';

class ProductGridItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imgurl;
//
//  ProductGridItem(
//      {@required this.id, @required this.imgurl, @required this.title});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authdata = Provider.of<Auth>(context);
    return LayoutBuilder(
      builder: (ctx, constraint) {
        return Container(
          width: constraint.maxWidth,
          height: constraint.maxHeight,
          child: Column(
            children: <Widget>[
              Container(
                width: constraint.maxWidth,
                height: constraint.maxHeight * .7,
                child: Stack(
                  children: <Widget>[
                    GridTile(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              ProductDetails.productdetilsroute,
                              arguments: product.id);
                        },
                        child: Hero(
                          tag: DateTime.now(),
                          child: Image.network(
                            product.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      footer: GridTileBar(
                        backgroundColor: Color.fromRGBO(242, 242, 242, .3),
                        leading:
                            Consumer<Product>(builder: (ctx, product, child) {
                          // to rebuild this widget
                          return IconButton(
                            color: Theme.of(context).accentColor,
                            icon: Icon(product.isfavourite
                                ? Icons.favorite
                                : Icons.favorite_border),
                            onPressed: () {
                              product.toogle(
                                  product, authdata.token, authdata.userid);
                            },
                          );
                        }),
                        title: Text(
                          product.title,
                          textAlign: TextAlign.center,
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.shopping_cart),
                          onPressed: () {
                            cart.addItems(
                                product.id, product.title, product.price);
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text('successfully added'),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              action: SnackBarAction(
                                label: 'undon',
                                onPressed: () {
                                  cart.deletesingleitem(product.id);
                                },
                              ),
                            ));
                          },
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 1,
                      right: 1,
                      child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          color: Color.fromRGBO(255, 255, 202, .5),
                          elevation: 8,
                          child: Text(
                            '23' + '%',
                            style: TextStyle(
                                color: Theme.of(context).accentColor,
                                fontSize: 20),
                          )),
                    )
                  ],
                ),
              ),
              InkWell(
                hoverColor: Colors.deepOrange,
                splashColor: Colors.purple,
                onTap: (){
                  Navigator.of(context).pushNamed(
                      ProductDetails.productdetilsroute,
                      arguments: product.id);
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            '${product.description}''... ',
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          'EGP ${product.price}' '                   ',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          'EGP ${product.price+20}',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
//
            ],
          ),
        );
      },
    );
  }
}
