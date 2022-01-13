import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribution/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter_cart/model/cart_model.dart';
import 'package:intl/intl.dart';

class CartPage extends StatefulWidget {
  var customer_name;
  var customer_phone_number;
  var state_name;

  CartPage(
      {Key mykey,
      this.customer_name,
      this.customer_phone_number,
      this.state_name})
      : super(key: mykey);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    var cart = FlutterCart();
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('dd-MM-yyyy hh:mm a');
    String formattedDate = formatter.format(now);
    final user = FirebaseAuth.instance.currentUser.email;
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
            Text("Total Cash : ${cart.getTotalAmount()}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.red)),
            SizedBox(height: 10),
            RaisedButton(
                onPressed: () async {
                  List products_List = [];

                  for (int i = 0; i < cart.cartItem.length; i++)
                    products_List.add({
                      "product_name": cart.cartItem.elementAt(i).productId,
                      "price": cart.cartItem.elementAt(i).unitPrice,
                      "quantity": cart.cartItem.elementAt(i).quantity,
                      "sub total": cart.cartItem.elementAt(i).subTotal
                    });

                  /* Adding the operation Details to DB */
                  FirebaseFirestore.instance.collection('sales').add({
                    "Creation_date": formattedDate,
                    "customer_name": widget.customer_name,
                    "phone_number": widget.customer_phone_number,
                    "state_name": widget.state_name,
                    "created_by": user,
                    "Sale Details": FieldValue.arrayUnion(products_List),
                    "Total Amount": cart.getTotalAmount()
                  }).then((value) {
                    cart.cartItem.forEach((element) {
                      element.uniqueCheck =
                          element.uniqueCheck - element.quantity;
                    });
                    /* Deducting the quantity of the product from the DB */
                    FirebaseFirestore.instance
                        .collection('users')
                        .doc(user)
                        .collection('Products')
                        .get()
                        .then((documents) {
                      documents.docs.forEach((element) {
                        cart.cartItem.forEach((item) {
                          if (item.productId ==
                              element.data()['product_name']) {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(user)
                                .collection('Products')
                                .doc(element.id)
                                .update({'product_stock': item.uniqueCheck});
                          }
                        });
                      });
                    }).then((value) {
                      /* adding the total amount of the operation to user total cash */
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(user)
                          .get()
                          .then((result) {
                        var x =
                            result.data()["total_cash"] + cart.getTotalAmount();
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user)
                            .update({'total_cash': x});
                      }).then((value) {
                        /* updating the last date of purchase in customer profile in the DB */
                        FirebaseFirestore.instance
                            .collection('customers')
                            .where('phone_number',
                                isEqualTo: widget.customer_phone_number)
                            .get()
                            .then((value) {
                          value.docs.forEach((element) {
                            FirebaseFirestore.instance
                                .collection("customers")
                                .doc(element.id)
                                .update({"last_purchase_date": formattedDate});
                          });
                        }).then((value) {
                          cart.deleteAllCart();
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/', (Route<dynamic> route) => false);
                        }); // fourth query //
                      }); // third query
                    }); // second query //
                  }); // first query//
                },
                color: Colors.pink,
                child: Text("Complete", style: TextStyle(color: Colors.white))),
          ]),
        ),
      );
    }
  }
}
