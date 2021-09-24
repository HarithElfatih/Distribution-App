import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribution/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_cart/flutter_cart.dart';

class Product {
  final int id;
  final String product_name;
  final double price;
  int qty;

  Product({this.id, this.product_name, this.price, this.qty});

  static Product fromSnapshot(DocumentSnapshot snap) {
    Product product = Product(
        product_name: snap['product_name'],
        price: snap['product_price'],
        qty: snap['user_stock']);
    return product;
  }

  static List<Product> _products = [
    Product(id: 1, product_name: "Product 1", price: 20.0, qty: 100),
    Product(id: 2, product_name: "Product 2", price: 40.0, qty: 120),
    Product(id: 3, product_name: "Product 3", price: 20.0, qty: 130),
    Product(id: 4, product_name: "Product 4", price: 40.0, qty: 150),
  ];
}

class catalogProducts extends StatelessWidget {
  const catalogProducts({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.builder(
            itemCount: Product._products.length,
            itemBuilder: (BuildContext context, int index) {
              return CatalogProductCard(index: index);
            }));
  }
}

class CatalogProductCard extends StatelessWidget {
  final int index;
  CatalogProductCard({Key key, this.index}) : super(key: key);
  var cart = FlutterCart();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(Product._products[index].product_name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          Text("${Product._products[index].price} SDG",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          OutlineButton(
              child: Text("Add"),
              onPressed: () {
                cart.addToCart(
                    productId: Product._products[index].product_name,
                    unitPrice: Product._products[index].price,
                    quantity: Product._products[index].qty);
                print(cart.cartItem.isEmpty);
              }),
          OutlineButton(
              child: Text("Remove"),
              onPressed: () {
                print(cart.cartItem.length);
                cart.deleteAllCart();
              })
        ],
      ),
    );
  }
}
