import 'package:flutter/material.dart';
import 'package:distribution/shared/constant.dart';

class GetCustomer extends StatefulWidget {
  @override
  _GetCustomerState createState() => _GetCustomerState();
}

class _GetCustomerState extends State<GetCustomer> {
  final _formkey = GlobalKey<FormState>();
  String phone_number = "";
  String error = "null";

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
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.pink,
              child: Text("Enter", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  if (error == "") {
                    setState(() => error = "هناك خطاْ في طلبك");
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