import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribution/screens/home/sell_category/catalogProductCard.dart';
import 'package:distribution/shared/constant.dart';
import 'package:distribution/screens/home/sell_category/cartpage.dart';

class sell_product extends StatefulWidget {
  var customer_name;
  var customer_phone_number;
  var store_name;
  var district_name;
  var state_name;

  sell_product(
      {Key mykey,
      this.customer_name,
      this.customer_phone_number,
      this.store_name,
      this.district_name,
      this.state_name})
      : super(key: mykey);

  @override
  _sell_productState createState() => _sell_productState(customer_name,
      customer_phone_number, store_name, district_name, state_name);
}

class _sell_productState extends State<sell_product> {
  _sell_productState(customer_name, customer_phone_number, store_name,
      district_name, state_name);

  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Form(
        child: Container(
          alignment: Alignment.center,
          child: Column(children: <Widget>[
            Text("Please Complete Sale Information",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.purple,
                    fontSize: 17,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Customer Name:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.customer_name,
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Phone Number:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.customer_phone_number,
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Store Name:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.store_name,
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('District Name:',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.district_name,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("State Name:",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(widget.state_name,
                        style: TextStyle(fontWeight: FontWeight.bold))
                  ],
                ),
              ],
            ),
            catalogProducts(),
            SizedBox(height: 20),
            RaisedButton(
                color: Colors.pink,
                child: Text("Check Out", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CartPage(
                                customer_name: widget.customer_name,
                                customer_phone_number:
                                    widget.customer_phone_number,
                                state_name: widget.state_name,
                              )));
                }),
          ]),
        ),
      ),
    ));
  }
}
