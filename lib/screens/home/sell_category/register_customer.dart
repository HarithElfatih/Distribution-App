import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribution/shared/constant.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';

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
  Position position;
  _register_customerState(customer_phone_number);

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
      print(
          ' ${first.locality}, ${first.adminArea},${first.subLocality}, ${first.subAdminArea},${first.addressLine}, ${first.featureName},${first.thoroughfare}, ${first.subThoroughfare}');
      //return first;
    });
  }

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
                    Text(position == null ? 'Location' : position.toString()),
                    ElevatedButton(
                        onPressed: () => fetchPosition(),
                        child: Text('Find Location')),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Enter Location By GPS"),
                      validator: (val) =>
                          val.isEmpty ? "Please Enter Location" : null,
                      onChanged: (val) {
                        setState(
                          () => location = val,
                        );
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
