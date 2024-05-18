import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider/Authprovider.dart';
import '../Model/BranchManager/BranchManager.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/Drawer.dart';
import 'BranchManagerPage.dart';
import 'Maindashboard.dart';
import 'ShopSetting.dart';
CommonFunctions common=CommonFunctions();
class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   //Provider.of<AdminProvider>(context).loadUserDataIntoMemory();
  }
  var currentPage = DrawerSections.dashboard;
  Widget build(BuildContext context) {
    var container;
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    if (currentPage == DrawerSections.dashboard) {
      container =  const MainDashboard();
    }
    else if (currentPage == DrawerSections.shopSetting) {
      container = const ShopSetting();
    }
    else if (currentPage == DrawerSections.branchManager) {
      container = BranchManager();
    }
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(height * 0.07),
          child: Builder(
            builder: (BuildContext context) {
              return AppBar(
                backgroundColor: primaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.menu),
                  iconSize: 25.0,
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
                actions: [
                  InkWell(
                    onTap: () {
                      common.showMainPopupMenu(context, height, width);
                    },
                    child: Consumer<AdminProvider>(
                      builder: (context, vendorProvider, child) {
                        return CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          backgroundImage: vendorProvider.currentUserImage != 'NULL'
                              ? NetworkImage( vendorProvider.currentUserImage!) as ImageProvider<Object>
                              : AssetImage('assets/images/farmer.png'),
                        );
                      },
                    ),
                  ),
                  CommonFunctions.commonSpace(0, width * 0.02)
                ],
              );
            },
          ),
        ),
        body: container,
        drawer: Drawer(
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: [
                  MyHeaderDrawer(),
                  myDrawerList(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget myDrawerList(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(context,1, "Dashboard",Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(context,2, "Shop Setting", Icons.settings,
              currentPage == DrawerSections.shopSetting ? true : false),
          menuItem(context,3, "Branch Managers", Icons.person_outline,
              currentPage == DrawerSections.branchManager ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context,int id, String title, IconData icon, bool selected) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          if (id == 1) {
            currentPage = DrawerSections.dashboard;
          }  else if (id == 2) {
            currentPage = DrawerSections.shopSetting;
          }else if(id == 3)
            {
              currentPage=DrawerSections.branchManager;
            }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: selected ? primaryColor: Colors.transparent,
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
  shopSetting,
  branchManager,
}
