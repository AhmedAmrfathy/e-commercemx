import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/order.dart';
import '../providers/product_provider.dart';
import '../widgets/userproductscreen.dart';
import '../widgets/drawer.dart';
import '../screens/editproductscreen.dart';

class UserProductScreen extends StatefulWidget {
  static const userproductrte = 'UserProductScreenroute';

  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  var isloading=true;
  Future<void>onpull()async{
    await Provider.of<ProductProvider>(context,listen: false).fetchdatafromserverandset(true);

  }
//  @override
//  void initState() {
//    Provider.of<ProductProvider>(context,listen: false).fetchdatafromserverandset();
//    super.initState();
//  }
//  var _isinit=true;
//  void didChangeDependencies() {
//    if (_isinit) {
//      Provider.of<ProductProvider>(context,listen: false).fetchdatafromserverandset(true).then((val)=>isloading=false);
//
//    }
//    _isinit=false;
//
//    super.didChangeDependencies();
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.editproductscreenroute);
            },
          )
        ],
      ),
      drawer: Drawerr(context),
      body: FutureBuilder(future: Provider.of<ProductProvider>(context,listen: false).fetchdatafromserverandset(true),builder: (ctx,futurestate){
        if(futurestate.connectionState==ConnectionState.waiting){return Center(child:CircularProgressIndicator()) ;}
        else{
          if(futurestate.error!=null){return Center(child: Text('ann error occured '),);}
          else{
            return  RefreshIndicator(
          onRefresh: onpull,
          child: Padding(padding: EdgeInsets.all(8),
            child: Consumer<ProductProvider>(builder: (ctx,object,ch)=>ListView.builder(
              padding: EdgeInsets.all(8),
              itemBuilder: (ctx, index) {
                return Column(
                  children: <Widget>[
                    UserProductScreenItm(object.items[index].title,
                        object.items[index].imageUrl,object.items[index].id),
                    Divider()
                  ],
                );
              },
              itemCount: object.items.length,
            ),
            ),
          ),
        );
          }

        }

      },
      ),
    );
  }
}
