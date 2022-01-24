import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class my_customers extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user_email = FirebaseAuth.instance.currentUser.email;
    return Container(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("customers")
            .where("created_by", isEqualTo: user_email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.connectionState == ConnectionState.done ||
              !snapshot.hasData) {
            return Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("You Don't Have Customers",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(height: 10),
                  Text("Try Adding New Customers")
                ],
              )),
            );
          } else {
            // ignore: missing_return
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return Scaffold(
                appBar: AppBar(title: Text("My Customers List")),
                body: Container(
                    padding: EdgeInsets.only(top: 30),
                    child: ListView(
                        children: documents
                            .map((doc) => Card(
                                  child: ListTile(
                                    tileColor: Colors.grey[300],
                                    title: Text(doc['customer_name'],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text(doc['store_name']),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  customer_details(
                                                    doc['customer_name'],
                                                    doc['phone_number'],
                                                    doc['store_name'],
                                                    doc['state_name'],
                                                    doc['district_name'],
                                                    doc['Creation_date'],
                                                    doc['last_purchase_date'],
                                                  )));
                                    },
                                  ),
                                ))
                            .toList())));
          }
        },
      ),
    );
  }
}

class customer_details extends StatelessWidget {
  String customer_name;
  String customer_phone_number;
  String Store_name;
  String state_name;
  String district_name;
  dynamic creation_date;
  dynamic last_purchase_date;

  customer_details(
      this.customer_name,
      this.customer_phone_number,
      this.Store_name,
      this.state_name,
      this.district_name,
      this.creation_date,
      this.last_purchase_date);

  @override
  Widget build(BuildContext context) {
    final date1 = creation_date.toString();
    final date2 = last_purchase_date.toString();

    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Form(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Text("Customer Details",
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
                            Text(customer_name,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Phone Number:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(customer_phone_number,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Creation Date:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(date1,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Store Name:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(Store_name,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('District Name:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(district_name,
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("State Name:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(state_name,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Last Purchase Date:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(date2,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                      color: Colors.amber,
                      child:
                          Text("Back", style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                    ),
                  ]),
                ),
              ),
            )));
  }
}
