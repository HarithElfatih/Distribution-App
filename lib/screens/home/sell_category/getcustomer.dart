import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:distribution/shared/constant.dart';
import 'package:distribution/screens/home/sell_category/register_customer.dart';

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
