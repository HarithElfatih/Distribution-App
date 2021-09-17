import 'package:distribution/screens/home/my_customers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:distribution/services/auth.dart';
import 'package:distribution/screens/home/sell_category/getcustomer.dart';

List<StaggeredTile> _staggeredTiles = const <StaggeredTile>[
  StaggeredTile.extent(2, 150),
  StaggeredTile.extent(1, 170),
  StaggeredTile.extent(1, 170),
  StaggeredTile.extent(2, 150)
];

List<Widget> _tiles = const <Widget>[
  const MyItems(Icons.done_all, "Sell A Product", 0xffed622b, "/sellproduct"),
  const MyItems(Icons.people_rounded, "My Customers", 0xff26cb3c, "/second"),
  const MyItems(
      Icons.account_circle_outlined, "My Profile", 0xffff3266, "Third"),
  const MyItems(Icons.money, "Sales Archive", 0xff4527a0, "Fourth"),
];

class DashboardItems extends StatelessWidget {
  AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          actions: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.person),
              label: Text("Logout"),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          staggeredTiles: _staggeredTiles,
          children: _tiles,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 90),
        ));
  }
}

class MyItems extends StatelessWidget {
  const MyItems(this.icon, this.heading, this.color, this.routeName);

  final int color;
  final IconData icon;
  final String heading;
  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(9),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Padding(
                                padding: EdgeInsets.all(9),
                                child: Text(
                                  heading,
                                  style: TextStyle(
                                    color: new Color(color),
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),

                            //icon
                            Material(
                              color: new Color(color),
                              borderRadius: BorderRadius.circular(24.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Icon(
                                  icon,
                                  size: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ])))),
    );
  }
}

class Home extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => DashboardItems(),
        '/sellproduct': (context) => GetCustomer(),
        '/second': (context) => my_customers(),
      },
    );
  }
}
