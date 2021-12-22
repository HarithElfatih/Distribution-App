import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_cart/model/cart_model.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key key}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cart = FlutterCart();

    if (cart.cartItem.isEmpty) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Shopping Cart"),
          ),
          body: Center(
            child: Text("You Didn't Choose Any Items"),
          ));
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text("Shopping Cart"),
        ),
        body: ListView.builder(
            itemCount: cart.cartItem.length,
            itemBuilder: (context, int index) {
              cart.cartItem.forEach((element) {
                print(cart.cartItem.length);
              });

              return Container(
                  child: Card(
                child: ListTile(
                  tileColor: Colors.grey[300],
                  title: Text(cart.cartItem[index].productId),
                  subtitle: Text(cart.cartItem[index].unitPrice.toString()),
                ),
              ));
            }),
      );
    }
  }
}
