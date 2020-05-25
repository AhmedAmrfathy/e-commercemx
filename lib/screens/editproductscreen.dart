import 'package:flutter/material.dart';
import '../providers/product.dart';
import '../providers/product_provider.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const editproductscreenroute = 'editproductscreeroute';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final titlenode = FocusNode();
  final descriptionnode = FocusNode();
  final geturltext = TextEditingController();
  final imageurlnode = FocusNode();
  final _formstate = GlobalKey<FormState>();
  var initvalue = {'title': '', 'description': '', 'price': '', 'imageurl': ''};
  var isloading = false;
  var checker = true;
  var product =
      Product(title: '', price: null, id: null, description: '', imageUrl: '');

  Future<void> save() async {
    final x = _formstate.currentState.validate();
    if (x) {
      _formstate.currentState.save();
      setState(() {
        isloading = true;
      });

      if (product.id != null) {
        await Provider.of<ProductProvider>(context, listen: false)
            .updateproduct(product.id, product);
        setState(() {
          isloading = false;
        });

        Navigator.of(context).pop();
      } else {
//        Provider.of<ProductProvider>(context, listen: false)
//            .addproduct(product)
//            .catchError((error) {
//          // this is method execute only if the method throw an error and it return future object and if it take value then method executed
//          return showDialog(
//              context: context,
//              builder: (ctx) => AlertDialog(
//                    title: Text('an error occured'),
//                    content: Text('an error was thrown by the way'),
//                    actions: <Widget>[
//                      FlatButton(
//                          child: Text('ok'),
//                          onPressed: () {
//                            Navigator.of(ctx).pop();
//                            Navigator.of(ctx).pop();
//                          })
//                    ],
//                  ));
//        }).then((_) {
//          setState(() {
//            isloading = false;
//          });
//          Navigator.of(context).pop();
//        });
        try {
          await Provider.of<ProductProvider>(context, listen: false)
              .addproduct(product);
        } catch (error) {
        await  showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                    title: Text('an error occured'),
                    content: Text('an error was thrown by the way'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('ok'),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          })
                    ],
                  ));
        } finally {
          setState(() {
            isloading = false;
          });
          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  void dispose() {
    // titlenode.dispose();
    // descriptionnode.dispose();
    geturltext.dispose();
    // imageurlnode.dispose();
    imageurlnode.removeListener(imageurllistener);
    super.dispose();
  }

  @override
  void initState() {
    imageurlnode.addListener(imageurllistener);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (checker) {
      final id = ModalRoute.of(context).settings.arguments as String;
      if (id != null) {
        // 3lshan lw gay a3ml new product menfzsh el klam da
        product = Provider.of<ProductProvider>(context).getFirstwhere(id);
        initvalue = {
          'title': product.title,
          'description': product.description,
          'price': product.price.toString(),
          // 'imageurl': product.imageUrl
        };
        geturltext.text = product.imageUrl;
      }
    }
    checker = false;
    super.didChangeDependencies();
  }

  void imageurllistener() {
    if (!imageurlnode.hasFocus) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: save,
          )
        ],
        title: Text('Edit product'),
      ),
      body: isloading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(bottom: mediaquery.viewInsets.bottom),
                child: Form(
                  key: _formstate,
                  child: Container(
                    width: 400,
                    height: 700,
                    padding: EdgeInsets.only(
                        left: 16, right: 16, top: 16, bottom: 16),
                    child: ListView(
                      children: <Widget>[
                        TextFormField(
                          initialValue: initvalue['title'],
                          decoration: InputDecoration(
                              labelText: 'title',
                              errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)))),
                          textInputAction: TextInputAction.next,
                          // to move to next textinputactions in form after pressing ok buttomm
                          onFieldSubmitted: (ctx) {
                            FocusScope.of(context).requestFocus(titlenode);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter the title';
                            }
                          },
                          onSaved: (value) {
                            product = Product(
                                id: product.id,
                                isfavourite: product.isfavourite,
                                title: value,
                                description: product.description,
                                imageUrl: product.imageUrl,
                                price: product.price);
                          },
                        ),
                        TextFormField(
                          initialValue: initvalue['price'],
                          decoration: InputDecoration(labelText: 'price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          focusNode: titlenode,
                          onFieldSubmitted: (c) {
                            FocusScope.of(context)
                                .requestFocus(descriptionnode);
                          },
                          onSaved: (value) {
                            product = Product(
                                id: product.id,
                                isfavourite: product.isfavourite,
                                title: product.title,
                                description: product.description,
                                imageUrl: product.imageUrl,
                                price: double.parse(value));
                          },
                          //
                          // to move to next textinputactions in form after pressing ok buttomm
                        ),
                        TextFormField(
                          initialValue: initvalue['description'],
                          decoration: InputDecoration(labelText: 'description'),
                          keyboardType: TextInputType.multiline,
                          //to show keyboard with bottom allaow us to move manually to next line
                          maxLines: 3,
                          focusNode: descriptionnode,
                          onSaved: (value) {
                            product = Product(
                                id: product.id,
                                isfavourite: product.isfavourite,
                                title: product.title,
                                description: value,
                                imageUrl: product.imageUrl,
                                price: product.price);
                          }, //
                          // to move to next textinputactions in form after pressing ok buttomm
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Container(
                              width: 100,
                              height: 100,
                              margin: EdgeInsets.only(top: 8, right: 8),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: geturltext.text.isEmpty
                                  ? Text('enter url')
                                  : FittedBox(
                                      child: Image.network(
                                      geturltext.text,
                                      fit: BoxFit.cover,
                                    )),
                            ),
                            Expanded(
                              child: TextFormField(
                                //it take as much it can take from width and height
                                decoration: InputDecoration(labelText: 'url'),
                                focusNode: imageurlnode,
                                keyboardType: TextInputType.url,
                                textInputAction: TextInputAction.done,
                                controller: geturltext,
                                onSaved: (value) {
                                  product = Product(
                                      id: product.id,
                                      isfavourite: product.isfavourite,
                                      title: product.title,
                                      description: product.description,
                                      imageUrl: value,
                                      price: product.price);
                                },
                                onFieldSubmitted: (cn) => save(),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
