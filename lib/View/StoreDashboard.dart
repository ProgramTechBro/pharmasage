import 'package:flutter/material.dart';
import 'package:pharmasage/View/BranchManagerPage.dart';
import 'package:pharmasage/View/EmployeesPage.dart';
import 'package:pharmasage/View/InventoryPage.dart';
import 'package:pharmasage/View/OrdersDetails.dart';
import 'package:pharmasage/View/PurchasePage.dart';
import 'package:pharmasage/View/ReturnsPage.dart';
import 'package:pharmasage/View/SalesPage.dart';
import 'package:pharmasage/View/Satistics.dart';
import 'package:pharmasage/View/Vendors/ProductExpiryReport.dart';
import 'package:pharmasage/View/VendorsPage.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/Authprovider.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/Drawer.dart';
CommonFunctions common=CommonFunctions();
class storeDashboard extends StatefulWidget {
  final String branchID;
  const storeDashboard({super.key,required this.branchID});

  @override
  State<storeDashboard> createState() => _storeDashboardState();
}

class _storeDashboardState extends State<storeDashboard> {
  @override
  var currentPage = DrawerSections.statistics;
  var appBarTitle = 'Statistics';
  Widget build(BuildContext context) {
    var container;
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;
    final textTheme=Theme.of(context).textTheme;
    if (currentPage == DrawerSections.statistics) {
      container =  const SatisticsPage();
    } else if (currentPage == DrawerSections.sales) {
      container = SalesPage(branchId: widget.branchID,);
    }
    else if (currentPage == DrawerSections.purchase) {
      container = OrdersDetails(storeId: widget.branchID,);
    }
    else if (currentPage == DrawerSections.inventory) {
      container = InventoryPage(storeId: widget.branchID,);
    }
    else if (currentPage == DrawerSections.employees) {
      container =  EmployeePage(branchId: widget.branchID,);
    }
    else if (currentPage == DrawerSections.expiryReport) {
      container = ExpiryReportPage(branchID: widget.branchID,);
    }
    else if (currentPage == DrawerSections.vendors) {
      container = const VendorPage();
    }
    else if (currentPage == DrawerSections.returns) {
      container =  ReturnPage(branchId: widget.branchID,);
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
                title:Text(appBarTitle, style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
                centerTitle: true,
                actions: [
                  IconButton(onPressed: (){}, icon: const Icon(Icons.notifications,color: Colors.white,)),
                  CommonFunctions.commonSpace(0, width * 0.02),
                  InkWell(
                    onTap: () {
                      common.showMainPopupMenu(context,height,width);
                    },
                    child:  CircleAvatar(
                      // radius: 16,
                      backgroundColor: Colors.white,
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
                  myDrawerList(context,height,width),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  Widget myDrawerList(BuildContext context,double height,double width) {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(context,1, "Statistics",'assets/Icons/stat.png',
              currentPage == DrawerSections.statistics ? true : false,height,width),
          menuItem(context,2, "Sales", 'assets/Icons/Sales.png',
              currentPage == DrawerSections.sales ? true : false,height,width),
          menuItem(context,3, "Purchase", 'assets/Icons/purchase.png',
              currentPage == DrawerSections.purchase ? true : false,height,width),
          menuItem(context,4, "Inventory", 'assets/Icons/inventory.png',
              currentPage == DrawerSections.inventory ? true : false,height,width),
          menuItem(context,5, "Employees",'assets/Icons/employees.png',
              currentPage == DrawerSections.employees ? true : false,height,width),
          menuItem(context,6, "Expiry Report", 'assets/Icons/end.png',
              currentPage == DrawerSections.expiryReport ? true : false,height,width),
          menuItem(context,7, "Vendors", 'assets/Icons/vendor.png',
              currentPage == DrawerSections.vendors ? true : false,height,width),
          menuItem(context,8, "Returns", 'assets/Icons/return.png',
              currentPage == DrawerSections.returns ? true : false,height,width),
          //CommonFunctions.commonSpace(height*0.6,0),
        ],
      ),
    );
  }

  Widget menuItem(BuildContext context,int id, String title, String icon, bool selected,double height,double width) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        setState(() {
          if (id == 1) {
            currentPage = DrawerSections.statistics;
            updateAppBarTitle();
          } else if (id == 2) {
            currentPage = DrawerSections.sales;
            updateAppBarTitle();
          } else if (id == 3) {
            currentPage = DrawerSections.purchase;
            updateAppBarTitle();
          }
          else if (id == 4) {
            currentPage = DrawerSections.inventory;
            updateAppBarTitle();
          }
          else if (id == 5) {
            currentPage = DrawerSections.employees;
            updateAppBarTitle();
          }
          else if (id == 6) {
            currentPage = DrawerSections.expiryReport;
            updateAppBarTitle();
          }
          else if (id == 7) {
            currentPage = DrawerSections.vendors;
            updateAppBarTitle();
          }
          else if (id == 8) {
            currentPage = DrawerSections.returns;
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
              child: Image.asset(
                icon,
                height: height*0.08,
                width: width*0.3,
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
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
      if (currentPage == DrawerSections.statistics) {
        appBarTitle = 'Statistics';
      } else if (currentPage == DrawerSections.sales) {
        appBarTitle = 'Sales';
      }
      else if (currentPage == DrawerSections.purchase) {
        appBarTitle = 'Orders';
      }
      else if (currentPage == DrawerSections.inventory) {
        appBarTitle = 'Inventory';
      }
      else if (currentPage == DrawerSections.employees) {
        appBarTitle = 'Employees';
      }
      else if (currentPage == DrawerSections.expiryReport) {
        appBarTitle = 'Expiry Report';
      }
      else if (currentPage == DrawerSections.vendors) {
        appBarTitle = 'Vendors';
      }
      else if (currentPage == DrawerSections.returns) {
        appBarTitle = 'Returns';
      }
      // Add more conditions for other pages as needed
    });
  }
}
enum DrawerSections {
  statistics,
  sales,
  purchase,
  inventory,
  employees,
  expiryReport,
  vendors,
  returns,
}