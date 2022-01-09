import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';

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
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: <Widget>[
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: cart.cartItem.length,
                itemBuilder: (context, int index) {
                  /*  cart.cartItem.forEach((element) {
                    print(cart.cartItem.length);
                  }); */
                  return Card(
                    child: ListTile(
                      tileColor: Colors.grey[300],
                      title: Text(cart.cartItem[index].productId),
                      subtitle: Text(
                          "Price: ${cart.cartItem[index].unitPrice.toString()}"),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(
                            onPressed: () {
                              if (cart.cartItem[index].quantity <= 1) {
                                cart.cartItem[index].quantity == 1;
                              } else {
                                setState(() {
                                  cart.decrementItemFromCart(index);
                                });
                              }
                            },
                            icon: Icon(Icons.remove_circle, color: Colors.red)),
                        Text(cart.cartItem[index].quantity.toString()),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                if (cart.cartItem[index].quantity <
                                    cart.cartItem[index].uniqueCheck)
                                  cart.incrementItemToCart(index);
                                else
                                  cart.cartItem[index].quantity =
                                      cart.cartItem[index].quantity;
                              });
                            },
                            icon: Icon(Icons.add_circle, color: Colors.green)),
                        SizedBox(width: 10),
                        Text("\$ ${cart.cartItem[index].subTotal.toString()}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ]),
                    ),
                  );
                }),
            SizedBox(height: 20),
            Text("Total Cash is ${cart.getTotalAmount()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red))
          ]),
        ),
      );
    }
  }
}
