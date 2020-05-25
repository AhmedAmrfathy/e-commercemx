import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product_provider.dart';
import '../screens/editproductscreen.dart';

class UserProductScreenItm extends StatelessWidget {
  final String title;
  final String imgurl;
  final String id;

  UserProductScreenItm(this.title, this.imgurl, this.id);

  @override
  Widget build(BuildContext context) {
    final producs = Provider.of<ProductProvider>(context);
    final scafold = Scaffold.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgurl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(
                    EditProductScreen.editproductscreenroute,
                    arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme
                    .of(context)
                    .errorColor,
              ),
              onPressed: () async {
                try {
                 await producs.removeproduct(id);
                } catch (error) {
                  scafold.showSnackBar(
                      SnackBar(content: Text('deleting item was failed'),));
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
