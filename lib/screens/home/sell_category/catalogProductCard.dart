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
                                  (cart.cartItem.any((element) =>
                                          element.productId ==
                                              doc['product_name'] ||
                                          element.quantity == 0))
                                      ? IconButton(
                                          onPressed: () {
                                            setState(() {
                                              cart.deleteItemFromCart(cart
                                                  .cartItem
                                                  .indexWhere((element) =>
                                                      element.productId ==
                                                      doc['product_name']));
                                            });
                                          },
                                          icon: Icon(Icons.remove_circle,
                                              color: Colors.red))
                                      : IconButton(
                                          onPressed: () {
                                            setState(() {
                                              cart.addToCart(
                                                  productId:
                                                      doc["product_name"],
                                                  unitPrice:
                                                      doc["product_price"],
                                                  quantity: 1,
                                                  uniqueCheck:
                                                      doc["product_stock"]);
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
