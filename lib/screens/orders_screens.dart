import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order.dart';
import '../widgets/drawer.dart';
import '../widgets/orderitem.dart';

class OrderScreen extends StatefulWidget {
  static const orderscreenroute='orderscreenroute';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var check=true;
  @override
  void didChangeDependencies() {
    if(check){
      Provider.of<Order>(context,listen: false).getorderfromserverandset();
    }
    check=false;
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    final orderobj = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('your Orders'),
      ),
      drawer: Drawerr(context),
      body: ListView.builder(
        itemCount: orderobj.orderitems.length,
        itemBuilder: (ctx, index) => OrderItemdesign(orderItem: orderobj.orderitems[index],),
      ),
    );
  }
}
