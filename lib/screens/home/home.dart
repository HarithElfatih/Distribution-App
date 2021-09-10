import 'package:flutter/material.dart';
import 'package:distribution/services/auth.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class Home extends StatelessWidget {
  AuthService _auth = AuthService();

  Material MyItems(IconData icon, String title, int color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: InkWell(
        onTap: () {},
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
                            title,
                            style: TextStyle(
                              color: new Color(color),
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      Material(
                        color: new Color(color),
                        borderRadius: BorderRadius.circular(24),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              )),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.blue[200],
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
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 90),
        children: <Widget>[
          MyItems(Icons.done_all, "Sell A Product", 0xffed622b),
          MyItems(Icons.people_rounded, "My Customers", 0xff26cb3c),
          MyItems(Icons.account_circle_outlined, "My Profile", 0xffff3266),
          MyItems(Icons.money, "Sales Archive", 0xff4527a0),
        ],
        staggeredTiles: [
          StaggeredTile.extent(2, 130),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(1, 150),
          StaggeredTile.extent(2, 130)
        ],
      ),
    );
  }
}
