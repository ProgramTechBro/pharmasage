import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/View/ExpiryReportDetails.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Model/POS/POSProduct.dart';
import '../../Utils/colors.dart';

class ExpiryReportPage extends StatefulWidget {
  final String branchID;

  const ExpiryReportPage({Key? key, required this.branchID}) : super(key: key);

  @override
  _ExpiryReportPageState createState() => _ExpiryReportPageState();
}

class _ExpiryReportPageState extends State<ExpiryReportPage> {
  int withinWeek = 0;
  int withinMonth = 0;
  int withinYear = 0;
  List<InventoryProduct> withinWeekProducts = [];
  List<InventoryProduct> withinMonthProducts = [];
  List<InventoryProduct> withinYearProducts = [];

  late Future<List<QueryDocumentSnapshot>> _fetchProducts;

  @override
  void initState() {
    super.initState();
    _fetchProducts = fetchData();
  }

  Future<List<QueryDocumentSnapshot>> fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Inventory')
        .doc(widget.branchID)
        .collection('Products')
        .get();
    print(querySnapshot);
    return querySnapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
            child: FutureBuilder(
              //Fetching Products from Firebase
              future: _fetchProducts,
              builder: (context, AsyncSnapshot<List<QueryDocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator(color: primaryColor));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  //Adding all Products into list
                  final List<QueryDocumentSnapshot> productsData = snapshot.data ?? [];
                  DateTime now = DateTime.now();
                  DateTime oneWeekLater = now.add(const Duration(days: 7));
                  DateTime oneMonthLater = now.add(const Duration(days: 30));
                  DateTime oneYearLater = now.add(const Duration(days: 365));
                  for (QueryDocumentSnapshot productSnapshot in productsData) {
                    //Checking when they will expire(Within Week,Month,Year)
                    InventoryProduct product = InventoryProduct.fromMap(productSnapshot.data() as Map<String, dynamic>);
                    String dateString = product.productExpiry!;
                    DateTime expiryDate = DateFormat('dd MMM, yyyy').parse(dateString);
                    if (expiryDate.isBefore(oneWeekLater)) {
                      withinWeek++;                    //Set value of no.of Product will expire within week
                      withinWeekProducts.add(product); //adding them to list of Within a week
                    } else if (expiryDate.isBefore(oneMonthLater)) {
                      withinMonth++;
                      withinMonthProducts.add(product);
                    } else if (expiryDate.isBefore(oneYearLater)) {
                      withinYear++;
                      withinYearProducts.add(product);
                    }
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExpiryReportDetails(products: withinWeekProducts,storeId: widget.branchID,)),
                          );
                        },
                        child: Container(
                          height: height * 0.35,
                          width: width * 0.8,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Card(
                            color: grey,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              height: height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      color: primaryColor,
                                    ),
                                    child: Center(child: Text('Within a Week', style: textTheme.labelLarge!.copyWith(color: Colors.white))),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.04, 0),
                                  Center(
                                    child: Container(
                                      height: height * 0.1,
                                      width: width * 0.22,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                      child: ClipOval(
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.transparent,
                                          child: Image.asset(
                                            'assets/Icons/cl.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.02, 0),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                      child: Text(withinWeek.toString(), style: textTheme.displayMedium),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      CommonFunctions.commonSpace(height*0.01,0),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExpiryReportDetails(products: withinMonthProducts,storeId: widget.branchID,)),
                          );
                        },
                        child: Container(
                          height: height * 0.35,
                          width: width * 0.8,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Card(
                            color: grey,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              height: height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      color: primaryColor,
                                    ),
                                    child: Center(child: Text('Within a Month', style: textTheme.labelLarge!.copyWith(color: Colors.white))),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.04, 0),
                                  Center(
                                    child: Container(
                                      height: height * 0.1,
                                      width: width * 0.22,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                      child: ClipOval(
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.transparent,
                                          child: Image.asset(
                                            'assets/Icons/cl.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.02, 0),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                      child: Text(withinMonth.toString(), style: textTheme.displayMedium),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      CommonFunctions.commonSpace(height*0.01,0),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ExpiryReportDetails(products: withinYearProducts,storeId: widget.branchID,)),
                          );
                        },
                        child: Container(
                          height: height * 0.35,
                          width: width * 0.8,
                          padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                          child: Card(
                            color: grey,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              height: height * 0.3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      color: primaryColor,
                                    ),
                                    child: Center(child: Text('Within a Year', style: textTheme.labelLarge!.copyWith(color: Colors.white))),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.04, 0),
                                  Center(
                                    child: Container(
                                      height: height * 0.1,
                                      width: width * 0.22,
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white,
                                      ),
                                      child: ClipOval(
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          color: Colors.transparent,
                                          child: Image.asset(
                                            'assets/Icons/cl.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.02, 0),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.03),
                                      child: Text(withinYear.toString(), style: textTheme.displayMedium),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
