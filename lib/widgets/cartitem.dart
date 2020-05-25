import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantaty;
  final String title;
  final String productitem;

  CartItem({this.id, this.price, this.quantaty, this.title, this.productitem});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {// this method return future object and check ir it is value true will do on dismissed function
        return showDialog(context: context,// this method return future object
            builder: (ctx) =>
                AlertDialog(title: Text('Are You sure sure?'),
                  content: Text('are you sure to remove this item ?'),actions: <Widget>[
                    FlatButton(child: Text('yes'),onPressed: (){
                      Navigator.of(context).pop(true);//here we give a value to the furure object of show dialig
                    },),
                    FlatButton(child: Text('no'),onPressed: (){
                      Navigator.of(context).pop(false);
                    },)
                  ],));
      },
      key: ValueKey(id),
      background: Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          color: Theme
              .of(context)
              .errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
          )),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteitem(productitem);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: Padding(
                      padding: EdgeInsets.all(4), child: Text('\$${price}'))),
            ),
            title: Text(title),
            subtitle: Text('Total : \$${price * quantaty}'),
            trailing: Text('${quantaty} X'),
          ),
        ),
      ),
    );
  }
}
