import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './product_griditem.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';

class ProductGridviewBody extends StatefulWidget {
  final bool isfavourite;
  final Size abarsize;

  ProductGridviewBody(this.isfavourite, this.abarsize);

  @override
  _ProductGridviewBodyState createState() => _ProductGridviewBodyState();
}

class _ProductGridviewBodyState extends State<ProductGridviewBody> {
  @override
  Widget build(BuildContext context) {
    final obj = Provider.of<ProductProvider>(context, listen: true);
    final List<Product> list =
        widget.isfavourite ? obj.favouriteitems : obj.items;
    final devicesize = MediaQuery.of(context).size;
    final avialablesize = devicesize.height - widget.abarsize.height;
    print(list.length);
    return SingleChildScrollView(
      child: Container(
        height: avialablesize,
        width: devicesize.width,
        child: Column(children: [
          Flexible(
            flex: 1,
            child: Container(
              width: devicesize.width,
              child: Carousel(
                images: [
                  NetworkImage('https://images.pexels.com/photos/291762/pexels-photo-291762.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'),
                  NetworkImage('https://hobe.cc/wp-content/uploads/2019/03/1967-1.jpg'),
                  NetworkImage('https://images.tesetturisland.com/neva-style-terra-cotta-hijab-tunic-1215krmt-tunic-neva-style-60973-22-O.jpg'),
                  NetworkImage('https://static.ounousa.com/Content/ResizedImages/638/654/inside/190621070506456.jpg'),
                  NetworkImage('https://media.linkonlineworld.com/img/large/2019/4/2/2019_4_2_19_8_8_474.jpg'),
                  NetworkImage('https://www.elbalad.news/upload/photo/news/338/1/600x338o/354.jpg'),
                  NetworkImage('https://lovee.cc/wp-content/uploads/2019/05/4034.jpg')

                ],
                radius: Radius.circular(3),
                borderRadius: true,
                boxFit: BoxFit.fill,
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Container(
              width: devicesize.width,
              child: GridView.builder(
                padding: EdgeInsets.all(10),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 5,
                    childAspectRatio: 3 / 4),
                itemBuilder: (ctx, index) {
                  return ChangeNotifierProvider.value(
                    value: list[index],
                    child: ProductGridItem(),
                  );
                },
                itemCount: list.length,
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
