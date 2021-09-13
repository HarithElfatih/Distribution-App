import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:distribution/shared/constant.dart';

class GetCustomer extends StatefulWidget {
  @override
  _GetCustomerState createState() => _GetCustomerState();
}

class _GetCustomerState extends State<GetCustomer> {
  final _formkey = GlobalKey<FormState>();
  String phone_number = "";
  String error = "";
  String check_number = "";

  String validateMobile(String value) {
    String pattern = r'(^(?:[0]9)?[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0.0,
        title: Text(" Get Customer Information"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: _formkey,
          child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(
                  hintText: "Customer Phone Number"),
              validator: (val) =>
                  val.isEmpty ? "Enter Customer Phone Number" : null,
              onChanged: (val) {
                setState(() => phone_number = val);
                print("This phone number $phone_number");
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.pink,
              child: Text("Enter", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  check_number = validateMobile(phone_number);
                  print(check_number);
                  if (check_number != null) {
                    error = check_number;
                  } else {
                    error = "";
                    try {
                      FirebaseFirestore.instance
                          .collection('customers')
                          .where('phone_number', isEqualTo: phone_number)
                          .get()
                          .then((QuerySnapshot querySnapshot) {
                        if (querySnapshot.size == 0) {
                          print("There are No data ");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => register_customer(
                                      customer_phone_number: phone_number)));
                        } else {
                          querySnapshot.docs.forEach((doc) {
                            print(doc["phone_number"]);
                            print(doc["name"]);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => sell_customer()));
                          });
                        }
                      });
                    } catch (e) {
                      print("Can't fetch the data");
                    }
                  }
                }
              },
            ),
            SizedBox(height: 10),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14),
            )
          ]),
        ),
      ),
    );
  }
}

class sell_customer extends StatefulWidget {
  @override
  _sell_customerState createState() => _sell_customerState();
}

class _sell_customerState extends State<sell_customer> {
  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registering a sale operation"),
        centerTitle: true,
      ),
    );
  }
}

class register_customer extends StatefulWidget {
  var customer_phone_number;
  register_customer({Key mykey, this.customer_phone_number})
      : super(key: mykey);
  @override
  _register_customerState createState() =>
      _register_customerState(customer_phone_number);
}

class _register_customerState extends State<register_customer> {
  final _formkey = GlobalKey<FormState>();

  String customer_name;
  String store_name;
  String state;
  String location;

  _register_customerState(customer_phone_number);

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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("Phone Number:",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(widget.customer_phone_number,
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
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
                    TextFormField(
                      decoration:
                          textInputDecoration.copyWith(hintText: "State Name"),
                      validator: (val) =>
                          val.isEmpty ? "Please Enter State Name" : null,
                      onChanged: (val) {
                        setState(() => state = val);
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Enter Location By GPS"),
                      validator: (val) =>
                          val.isEmpty ? "Please Enter Location" : null,
                      onChanged: (val) {
                        setState(() => location = val);
                      },
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.pink,
                      child:
                          Text("Enter", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (_formkey.currentState.validate()) {}
                      },
                    ),
                  ]),
                ),
              ),
            )));
  }
}
