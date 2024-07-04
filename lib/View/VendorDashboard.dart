import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/View/Vendors/AcceptedOrders.dart';
import 'package:pharmasage/View/Vendors/PvendorsProduct.dart';
import 'package:pharmasage/View/Vendors/ReceivedOrders.dart';
import 'package:provider/provider.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/Drawer.dart';
import 'Maindashboard.dart';
import 'ShopSetting.dart';
CommonFunctions common=CommonFunctions();
class VendorDashboard extends StatefulWidget {
  @override
  State<VendorDashboard> createState() => _VendorDashboardState();
}
class _VendorDashboardState extends State<VendorDashboard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
  }
  @override
  var currentPage = DrawerSections.products;
  var appBarTitle = 'Products';
  @override
  Widget build(BuildContext context) {
    var container;
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    if (currentPage == DrawerSections.products) {
      container =  const vendorProducts();
    }
    else if (currentPage == DrawerSections.orders) {
      container = const ReceivedOrders();
    }
    else if (currentPage == DrawerSections.acceptedorders) {
      container = const AcceptedOrders();
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
                title:Text(appBarTitle, style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
                centerTitle: true,
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
                          backgroundImage: vendorProvider.vendorDetail.imagesURL != 'NULL'
                              ? NetworkImage( vendorProvider.vendorDetail.imagesURL!) as ImageProvider<Object>
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
          menuItem(context,1, "Products",Icons.shopping_bag_outlined,
              currentPage == DrawerSections.products ? true : false),
          menuItem(context,2, "New Orders", Icons.shopping_cart,
              currentPage == DrawerSections.orders ? true : false),
          menuItem(context,3, "Accepted Orders", Icons.check_circle,
              currentPage == DrawerSections.acceptedorders ? true : false),
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
            currentPage = DrawerSections.products;
            updateAppBarTitle();
          }  else if (id == 2) {
            currentPage = DrawerSections.orders;
            updateAppBarTitle();
          }
          else if (id == 3) {
            currentPage = DrawerSections.acceptedorders;
            updateAppBarTitle();
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
  void updateAppBarTitle() {
    // Update the title based on the current page
    setState(() {
      if (currentPage == DrawerSections.products) {
        appBarTitle = 'Products';
      } else if (currentPage == DrawerSections.orders) {
        appBarTitle = 'Received Orders';
      }
      else if (currentPage == DrawerSections.acceptedorders) {
        appBarTitle = 'Accepted Orders';
      }

      // Add more conditions for other pages as needed
    });
  }
}
enum DrawerSections {
  products,
  orders,
  acceptedorders;
}
