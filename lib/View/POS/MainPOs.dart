import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/POS/InventoryProduct.dart';
import '../../Utils/colors.dart';
import 'Billing.dart';
import 'ClaimReturn.dart';
import 'Inventory.dart';
import 'SearchInvoice.dart';

class MainPos extends StatefulWidget {
  @override
  _MainPosState createState() => _MainPosState();
}

class _MainPosState extends State<MainPos> {
  String currentPage = 'Billing'; // Default page

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: grey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(height * 0.12), // Set preferred height here
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: width*0.01,vertical: height*0.01),
          //centerTitle: true,
          color: Colors.white,
          //elevation:0 , // Remove elevation
          child: Center(
            child: Column(
              children: [
                //CommonFunctions.commonSpace(height*0.05,0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('assets/images/B1.png'),
                        //CommonFunctions.commonSpace(0, width * 0.002),
                        Image.asset('assets/images/B2.png'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentPage = 'Billing';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: currentPage == 'Billing' ? primaryColor : grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 4, // Blur radius
                                  offset: Offset(0, 2), // Offset of the shadow
                                ),
                              ],// Add color to the container
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding for better visual appearance
                            child: Text('Billing', style: textTheme.bodyMedium!.copyWith(color: currentPage == 'Billing' ? white : Colors.black)),
                          ),
                        ),
                        CommonFunctions.commonSpace(0,width*0.08),
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentPage = 'Inventory';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                              color: currentPage == 'Inventory' ? primaryColor : grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 4, // Blur radius
                                  offset: Offset(0, 2), // Offset of the shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding for better visual appearance
                            child: Text('Inventory', style: textTheme.bodyMedium!.copyWith(color: currentPage == 'Inventory' ? white : Colors.black)),
                          ),
                        ),
                        CommonFunctions.commonSpace(0,width*0.08),
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentPage = 'Invoice';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                              color: currentPage == 'Invoice' ? primaryColor : grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 4, // Blur radius
                                  offset: Offset(0, 2), // Offset of the shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding for better visual appearance
                            child: Text('Invoice', style: textTheme.bodyMedium!.copyWith(color: currentPage == 'Invoice' ? white : Colors.black)),
                          ),
                        ),
                        CommonFunctions.commonSpace(0,width*0.08),
                        InkWell(
                          onTap: () {
                            setState(() {
                              currentPage = 'Returns';
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20), // Adjust the radius as needed
                              color: currentPage == 'Returns' ? primaryColor : grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3), // Shadow color
                                  spreadRadius: 2, // Spread radius
                                  blurRadius: 4, // Blur radius
                                  offset: Offset(0, 2), // Offset of the shadow
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Add padding for better visual appearance
                            child: Text('Returns', style: textTheme.bodyMedium!.copyWith(color: currentPage == 'Returns' ? white : Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    CommonFunctions.commonSpace(0,width*0.07),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: _buildPage(currentPage),
    );
  }

  Widget _buildPage(String page) {
    // Replace these with your actual page widgets
    switch (page) {
      case 'Billing':
        return BillingPage();
      case 'Inventory':
        return InventoryPro();
      case 'Invoice':
        return InvoicePage();
      case 'Returns':
        return ReturnPagePOS();
      default:
        return Container(); // Default empty page
    }
  }
}
