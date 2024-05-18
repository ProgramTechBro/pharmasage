import 'package:flutter/material.dart';

import 'Drawer.dart';
class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: [
            MyHeaderDrawer(),
            menuItem(context, 1, 'My Profile', Icons.person_2_outlined,
                currentPage == DrawerSections.myProfile ? true : false),
            menuItem(context, 2, 'Shop Setting', Icons.settings,
                currentPage == DrawerSections.shopSetting ? true : false),
          ],
        ),
      ),
    );
  }

  Widget menuItem(
      BuildContext context, int id, String title, IconData icon, bool selected) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop(); // Close the drawer
        setState(() {
          if (id == 1) {
            currentPage = DrawerSections.myProfile;
          } else if (id == 2) {
            currentPage = DrawerSections.shopSetting;
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? Colors.blue : Colors.transparent, // Change color logic here
        ),
        height: 50,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
              child: Icon(
                icon,
                size: 25,
                color: Colors.black,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum DrawerSections {
  dashboard,
  myProfile,
  shopSetting,
}
