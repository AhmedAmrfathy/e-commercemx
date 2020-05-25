import 'package:flutter/material.dart';
import '../providers/order.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItemdesign extends StatefulWidget {
  final OrderItem orderItem;

  OrderItemdesign({this.orderItem});

  @override
  _OrderItemdesignState createState() => _OrderItemdesignState();
}

class _OrderItemdesignState extends State<OrderItemdesign> {
  var isexpande = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd / MM / yyyy / hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(Icons.more),
              onPressed: () {
                setState(() {
                  isexpande = !isexpande;
                });
              },
            ),
          ),
          if (isexpande)
            Container(
              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 7),
              height: min(widget.orderItem.list.length * 20.0 + 10, 180),
              child: ListView(
                  children: widget.orderItem.list
                      .map((elemnt) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                elemnt.title,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${elemnt.quantaty}X \$${elemnt.price}',
                                style:
                                    TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList()),
            )
        ],
      ),
    );
  }
}
