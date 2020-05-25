import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/order.dart';
import '../widgets/cartitem.dart' as e;

class CartScreen extends StatefulWidget {
  static const cartscreen = 'cartscreen';

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var isloading = false;

  @override
  Widget build(BuildContext context) {
    final card = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Card'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$${card.total}',
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  isloading
                      ? CircularProgressIndicator()
                      : FlatButton(
                          child: Text(
                            'Order Now',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 17,
                            ),
                          ),
                          onPressed: () async {
                            setState(() {
                              isloading = true;
                            });
                            await Provider.of<Order>(context, listen: false)
                                .addOrder(
                                    card.items.values.toList(), card.total)
                                .then((value) {
                              setState(() {
                                isloading = false;
                                card.clear();
                              });
                            });
                          },
                        )
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemBuilder: (ctx, index) => e.CartItem(
                      id: card.items.values.toList()[index].id,
                      title: card.items.values.toList()[index].title,
                      price: card.items.values.toList()[index].price,
                      quantaty: card.items.values.toList()[index].quantaty,
                      productitem: card.items.keys.toList()[index],
                    ),
                itemCount: card.items.length),
          )
        ],
      ),
    );
  }
}
