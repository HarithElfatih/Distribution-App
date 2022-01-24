import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class sales_archive extends StatelessWidget {
  const sales_archive({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user_email = FirebaseAuth.instance.currentUser.email;

    return Container(
      child: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection("sales")
            .where("created_by", isEqualTo: user_email)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (!snapshot.hasData) {
            return Scaffold(
              body: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("There is No Sale Operation",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  SizedBox(height: 10),
                  Text("Try To Sale Some Products")
                ],
              )),
            );
          } else {
            // ignore: missing_return
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return Scaffold(
                appBar: AppBar(title: Text("My Sales Archive")),
                body: Container(
                    padding: EdgeInsets.only(top: 30),
                    child: ListView(
                        children: documents
                            .map((doc) => Card(
                                  child: ListTile(
                                    tileColor: Colors.grey[300],
                                    title: Text(doc['customer_name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                    subtitle: Text(
                                        doc['Creation_date']
                                            .toString()
                                            .substring(0, 10),
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14)),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          " Cash:${doc['total_amount'].toString()}",
                                          style: TextStyle(
                                              color: Colors.yellow[900],
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                            "Bouns:${doc['operation_bouns'].toString()}",
                                            style: TextStyle(
                                                color: Colors.green[900],
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Sale_details(
                                                    doc['Creation_date'],
                                                    doc['created_by'],
                                                    doc['customer_name'],
                                                    doc['operation_bouns'],
                                                    doc['phone_number'],
                                                    doc['sale_details'],
                                                    doc['state_name'],
                                                    doc['total_amount'],
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

class Sale_details extends StatelessWidget {
  dynamic creation_date;
  String created_by;
  String customer_name;
  dynamic operation_bouns;
  String customer_phone_number;
  List sale_details;
  String state_name;
  dynamic total_amount;

  dynamic last_purchase_date;

  Sale_details(
    this.creation_date,
    this.created_by,
    this.customer_name,
    this.operation_bouns,
    this.customer_phone_number,
    this.sale_details,
    this.state_name,
    this.total_amount,
  );

  @override
  Widget build(BuildContext context) {
    final date1 = creation_date.toString();

    return Scaffold(
        body: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Form(
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(children: <Widget>[
                    Text("Sale Operation Details",
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
                            Text("Date of Sale Operation:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(date1,
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Total Cash:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(total_amount.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Earned Bouns:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(operation_bouns.toString(),
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
                            Text("Created By:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(created_by,
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
