import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribution/shared/constant.dart';
import 'package:intl/intl.dart';

class register_customer extends StatefulWidget {
  var customer_phone_number;
  var state_name = '';
  var district_name = '';

  register_customer({
    Key mykey,
    this.customer_phone_number,
    this.state_name,
    this.district_name,
  }) : super(key: mykey);
  @override
  _register_customerState createState() =>
      _register_customerState(customer_phone_number, state_name, district_name);
}

class _register_customerState extends State<register_customer> {
  _register_customerState(customer_phone_number, state_name, district_name);

  final _formkey = GlobalKey<FormState>();
  String customer_name;
  String store_name;

  @override
  Widget build(BuildContext context) {
    print(widget.customer_phone_number);
    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Form(
              key: _formkey,
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    SizedBox(height: 20.0),
                    Text("Please Enter Customer Information",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.purple,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Customer Name"),
                      validator: (val) =>
                          val.isEmpty ? "Enter Customer Name" : null,
                      onChanged: (val) {
                        setState(() => customer_name = val);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "Store Name"),
                      validator: (val) =>
                          val.isEmpty ? "Please Enter Store Name" : null,
                      onChanged: (val) {
                        setState(() => store_name = val);
                      },
                    ),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
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
                            Text("State Name:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget.state_name,
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
                      ],
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pink,
                      child: Text("Register",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        DateTime now = new DateTime.now();
                        var formatter = new DateFormat('dd-MM-yyyy hh:mm a');
                        String formattedDate = formatter.format(now);
                        final user = FirebaseAuth.instance.currentUser.email;
                        if (_formkey.currentState.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Saving Customer Information")));
                          FirebaseFirestore.instance
                              .collection('customers')
                              .add({
                                "Creation_date": formattedDate,
                                "customer_name": customer_name,
                                "store_name": store_name,
                                "phone_number": widget.customer_phone_number,
                                "district_name": widget.district_name,
                                "state_name": widget.state_name,
                                "created_by": user,
                                "last_purchase_date": "New customer",
                              })
                              .then((value) => Navigator.pop(context))
                              .catchError((error) => print(
                                  "Faild in adding customer because of $error"));
                        }
                      },
                    ),
                  ]),
                ),
              ),
            )));
  }
}
