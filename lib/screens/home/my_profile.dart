import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class my_profile extends StatefulWidget {
  const my_profile({Key key}) : super(key: key);

  @override
  _my_profileState createState() => _my_profileState();
}

class _my_profileState extends State<my_profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser.email;

    return new FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(user).get(),
        builder:
            // ignore: missing_return
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data.exists == false) {
            return Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Your Profile is Not Available',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(height: 10),
                  Text("Please Contact Your Comapany")
                ],
              )),
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
                body: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    snapshot.data.get('user_name'),
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.blueGrey,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshot.data.get('user_address'),
                    style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Passport No.: ${snapshot.data.get('passport_number')}",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                      elevation: 2.0,
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 10),
                          child: Text(
                            "Current Saled Quantity: ${snapshot.data.get('total_quantity').toString()}",
                            style: TextStyle(
                                letterSpacing: 2.0,
                                fontWeight: FontWeight.bold),
                          ))),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "User Phone Number : ${snapshot.data.get('phone_number')}",
                    style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black45,
                        letterSpacing: 2.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Card(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Total Cash",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  '${snapshot.data.get('total_cash').toString()} SDG',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  "Total Bouns",
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  '${snapshot.data.get('total_bouns').toString()} SDG',
                                  style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  userProducts(),
                ],
              ),
            ));
          }
        });
  }
}

class userProducts extends StatefulWidget {
  const userProducts({Key key}) : super(key: key);

  @override
  _userProductsState createState() => _userProductsState();
}

class _userProductsState extends State<userProducts> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser.email;
    return new FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(user)
            .collection('Products')
            .get(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.data == null || snapshot.data.docs.length == 0) {
            return Center(child: Text('Your Stock of Products is Empty'));
          }
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;

            return Flexible(
                child: ListView(
                    children: documents
                        .map((doc) => Container(
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
                              child: Card(
                                  child: new ListTile(
                                title: new Text("${doc['product_name']}"),
                                subtitle:
                                    new Text("Stock: ${doc['product_stock']}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Price: ${doc['product_price']} \$ ",
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              )),
                            ))
                        .toList()));
          }
        });
  }
}
