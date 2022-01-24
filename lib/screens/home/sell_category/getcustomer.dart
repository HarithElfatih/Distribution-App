import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:distribution/shared/constant.dart';
import 'package:distribution/screens/home/sell_category/register_customer.dart';
import 'package:distribution/screens/home/sell_category/sell_product.dart';

class GetCustomer extends StatefulWidget {
  @override
  _GetCustomerState createState() => _GetCustomerState();
}

class _GetCustomerState extends State<GetCustomer> {
  @override
  final _formkey = GlobalKey<FormState>();

  String phone_number = "";
  String error = "";
  String check_number = "";
  String customer_name = "";
  String store_name = "";
  String district_name = "";
  String state_name = "";

  String validateMobile(String value) {
    String pattern = r'(([0]+[19])([0-9]{8})$)';
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
        title: Text(" Get Customer Profile"),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Form(
              key: _formkey,
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
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
                      child:
                          Text("Enter", style: TextStyle(color: Colors.white)),
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
                                  .where('phone_number',
                                      isEqualTo: phone_number)
                                  .get()
                                  .then((QuerySnapshot querySnapshot) {
                                if (querySnapshot.size == 0) {
                                  print("There are No data ");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "Currently your Location is being processed")));
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              register_customer(
                                                customer_phone_number:
                                                    phone_number,
                                              )));
                                } else {
                                  querySnapshot.docs.forEach((doc) {
                                    customer_name = doc["customer_name"];
                                    phone_number = doc['phone_number'];
                                    store_name = doc['store_name'];
                                    district_name = doc['district_name'];
                                    state_name = doc['state_name'];
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Getting Customer Information")));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => sell_product(
                                                  customer_name: customer_name,
                                                  customer_phone_number:
                                                      phone_number,
                                                  store_name: store_name,
                                                  district_name: district_name,
                                                  state_name: state_name,
                                                )));
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
              ))),
    );
  }
}
