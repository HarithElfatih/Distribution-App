import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:distribution/shared/constant.dart';
import 'package:distribution/screens/home/sell_category/register_customer.dart';
import 'package:distribution/screens/home/sell_category/sell_product.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

class GetCustomer extends StatefulWidget {
  @override
  _GetCustomerState createState() => _GetCustomerState();
}

class _GetCustomerState extends State<GetCustomer> {
  @override
  void initState() {
    // Note that you cannot use `async await` in  initState
    fetchPosition().then((_) {
      print("loadedddd");
    });
    super.initState();
  }

  final _formkey = GlobalKey<FormState>();
  String phone_number = "";
  String error = "";
  String check_number = "";
  String state_name = '';
  String district_name = '';
  String customer_name = "";
  String store_name = "";
  Position position;

  String validateMobile(String value) {
    String pattern = r'(^(?:[0]9)?[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);

    if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  Future fetchPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position currentposition = await Geolocator.getCurrentPosition();
    setState(() async {
      position = currentposition;
      final coordinates =
          new Coordinates(currentposition.latitude, currentposition.longitude);
      var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
      var first = addresses.first;

      print('${first.adminArea}'); //stateName
      print(' ${first.locality}'); //district_Name
      print('${first.addressLine} '); //Full address
      print(position); // Latitude: & Longitude
      state_name = first.adminArea;
      district_name = first.locality;
    });
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
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Checking Customer Phone Number")));
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

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              register_customer(
                                                customer_phone_number:
                                                    phone_number,
                                                state_name: state_name,
                                                district_name: district_name,
                                              )));
                                } else {
                                  querySnapshot.docs.forEach((doc) {
                                    customer_name = doc["customer_name"];
                                    phone_number = doc['phone_number'];
                                    store_name = doc['store_name'];
                                    district_name = doc['district_name'];
                                    state_name = doc['state_name'];
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
