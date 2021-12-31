import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_cart/model/cart_model.dart';

class Product {
  final dynamic id;
  final dynamic product_name;
  final dynamic price;
  dynamic qty;

  Product(QueryDocumentSnapshot<Object> element,
      {this.id, this.product_name, this.price, this.qty});
}

class catalogProducts extends StatefulWidget {
  const catalogProducts({Key key}) : super(key: key);

  @override
  _catalogProductsState createState() => _catalogProductsState();
}

class _catalogProductsState extends State<catalogProducts> {
  bool showTextForm = false;
  var cart = FlutterCart();

  @override
  Widget build(BuildContext context) {
    final user_email = FirebaseAuth.instance.currentUser.email;

    return new FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user_email)
            .collection('Products')
            .where("product_stock", isGreaterThanOrEqualTo: 1)
            .get(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data == null || snapshot.data.docs.length == 0) {
            return Center(child: Text('Your Stock of Products is Empty'));
          }
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;

            return Flexible(
                child: ListView(
                    children: documents
                        .map((doc) => Card(
                                child: new ListTile(
                              title: new Text("${doc['product_name']}"),
                              subtitle:
                                  new Text("Stock: ${doc['product_stock']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("\$ ${doc['product_price']}",
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          cart.deleteItemFromCart(cart.cartItem
                                              .indexWhere((element) =>
                                                  element.productId ==
                                                  doc['product_name']));
                                        });
                                      },
                                      icon: Icon(Icons.remove_circle,
                                          color: Colors.red)),
                                  if (cart.cartItem.any((element) =>
                                      element.productId == doc['product_name']))
                                    Container(
                                        color: Colors.blue.shade100,
                                        height: 50.0,
                                        width: 50.0,
                                        child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          autofocus: false,
                                          initialValue: '0',
                                          textAlign: TextAlign.center,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.normal,
                                              color: Colors.black,
                                              fontSize: 15),
                                        ))
                                  else
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            cart.addToCart(
                                                productId: doc["product_name"],
                                                unitPrice: doc["product_price"],
                                                quantity: doc["product_stock"]);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.add_circle,
                                          color: Colors.green,
                                        )),
                                ],
                              ),
                            )))
                        .toList()));
          }
        });
  }
}
