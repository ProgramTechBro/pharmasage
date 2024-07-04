import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Model/OrderModel/Order.dart';
import 'package:pharmasage/Utils/colors.dart';
import '../Constants/CommonFunctions.dart';
import '../Model/MonthlyCatgeorysale/MonthlyCategorysale.dart';
import '../Model/POS/POSProduct.dart';
import '../Model/Product/Productdetails.dart';
import '../Model/Transaction/TransactionDetails.dart';

class StatisticsPage extends StatefulWidget {
  final String storeId;
  const StatisticsPage({super.key, required this.storeId});

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  bool hasData=false;
  int withinWeek = 0;
  int withinMonth = 0;
  int withinYear = 0;
  double medicineSale=0.0;
  double cosmeticsSale=0.0;
  double babyCareSale=0.0;
  double petCareSale=0.0;
  List<String> monthNames = [];
  List<MonthlyCategorySale> monthlyData = [];
  List<InventoryProduct> lowStockProducts = [];
  List<InventoryProduct> outOfStockProducts = [];
  List<Product> arrivingStockProducts = [];
  List<InventoryProduct> allProducts=[];
  List<TransactionModel> transactions = [];
  String transactionMonth='';
  bool isLoading = true;
  int touchedIndex = -1;
  int touchedIndex2=-1;


  @override
  void initState() {
    super.initState();
    populateMonthNames();
    fetchData();
  }
  populateMonthNames() {
    final now = DateTime.now();
    final previousMonth = DateTime(now.year, now.month - 1, 1);
    monthNames.add(DateFormat('MMM').format(previousMonth)); // Add previous month first
    monthNames.add(DateFormat('MMM').format(now)); // Add current month next
  }
  Future<void> fetchData() async {
    try {
      final inventorySnapshot = await FirebaseFirestore.instance
          .collection('Inventory')
          .doc(widget.storeId)
          .collection('Products')
          .get();
      final ordersSnapshot =
      await FirebaseFirestore.instance.collection('Orders').get();

      allProducts = inventorySnapshot.docs
          .map((doc) => InventoryProduct.fromSnapshot(doc))
          .toList();
      final allOrders = ordersSnapshot.docs
          .map((doc) => OrderModel.fromSnapshot(doc))
          .toList();

      // Calculate low stock and out of stock
      for (var product in allProducts) {
        if (product.productQuantity! <= product.lowStockWarning! &&
            product.productQuantity! > 0) {
          lowStockProducts.add(product);
        }
        if (product.productQuantity! == 0) {
          outOfStockProducts.add(product);
        }
      }

      // Calculate arriving stock
      for (var order in allOrders) {
        if (order.orderStatus == 'Accepted' && order.orderedProducts != null) {
          arrivingStockProducts.addAll(order.orderedProducts!);
        }
      }

      calculateExpiryData();
      await fetchTransactionData();

      setState(() {
        if(allProducts.isNotEmpty && allOrders.isNotEmpty && transactions.isNotEmpty){
          hasData=true;
        }
        else{
          hasData=false;
        }
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        print('Yaha bhi ho');
        isLoading = false;
        hasData = false;
      });
      // Handle error appropriately
      print("Error fetching data: $e");
    }
  }

  double calculatePercentage(int part, int total) {
    if (total == 0) return 0;
    return (part / total) * 100;
  }
   calculateExpiryData() {
    DateTime now = DateTime.now();
    DateTime oneWeekLater = now.add(const Duration(days: 7));
    DateTime oneMonthLater = now.add(const Duration(days: 30));
    DateTime oneYearLater = now.add(const Duration(days: 365));
    for (InventoryProduct product in allProducts) {
      String dateString = product.productExpiry!;
      DateTime expiryDate = DateFormat('dd MMM, yyyy').parse(dateString);
      print(expiryDate);
      if (expiryDate.isBefore(oneWeekLater)) {
        withinWeek++;
      } else if (expiryDate.isBefore(oneMonthLater)) {
        withinMonth++;
      } else if (expiryDate.isBefore(oneYearLater)) {
        withinYear++;
      }
    }
  }
  Future<void> fetchTransactionData() async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(widget.storeId)
        .collection('TransactionID')
        .get();

    transactions = querySnapshot.docs.map((doc) => TransactionModel.fromSnapshot(doc)).toList();
    print(transactions);
    calculateMonthlySale();
  }

  void calculateMonthlySale() {
    final now = DateTime.now();
    final List<int> months = [];
    monthNames.clear(); // Clear previous month names

    for (int i = 0; i < 2; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      months.add(date.month);
      monthNames.insert(0, DateFormat('MMM').format(date)); // Insert month name at the beginning
    }

    monthlyData = months.reversed.map((month) {
      // Reset sales data for each month
      double medicineSale = 0.0;
      double cosmeticsSale = 0.0;
      double babyCareSale = 0.0;
      double petCareSale = 0.0;

      final monthlyTransactions = transactions.where((transaction) {
        final transactionDateParts = transaction.transactionDate!.split(' ');
        final transactionMonth = DateFormat.MMM().parse(transactionDateParts[1]).month;
        return transactionMonth == month;
      }).toList();

      for (final transaction in monthlyTransactions) {
        for (final product in transaction.selectedProducts!) {
          final category = product.productCategory;
          final sale = product.sellingPrice! * product.productQuantity!.toDouble();
          if (category == 'Medicine') {
            medicineSale += sale;
          } else if (category == 'Cosmetics') {
            cosmeticsSale += sale;
          } else if (category == 'Baby Care') {
            babyCareSale += sale;
          } else if (category == 'Pet Care') {
            petCareSale += sale;
          }
        }
      }

      return MonthlyCategorySale(
        month: DateFormat('MMM').format(DateTime(DateTime.now().year, month)),
        medicineSale: medicineSale,
        cosmeticsSale: cosmeticsSale,
        babyCareSale: babyCareSale,
        petCareSale: petCareSale,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final int totalProducts = lowStockProducts.length +
        outOfStockProducts.length +
        arrivingStockProducts.length;
    final int totalExpiryProducts=withinWeek+withinMonth+withinYear;
    print(totalExpiryProducts);
    final double lowStockPercentage =
    calculatePercentage(lowStockProducts.length, totalProducts);
    final double outOfStockPercentage =
    calculatePercentage(outOfStockProducts.length, totalProducts);
    final double arrivingStockPercentage =
    calculatePercentage(arrivingStockProducts.length, totalProducts);
    final double withInWeekPercentage=calculatePercentage(withinWeek,totalExpiryProducts);
    final double withInMonthPercentage=calculatePercentage(withinMonth,totalExpiryProducts);
    final double withInYearPercentage=calculatePercentage(withinYear,totalExpiryProducts);
    print(withInWeekPercentage);
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: primaryColor,))
          : hasData?SingleChildScrollView(
            child: Container(
                width:width,
              //height: height*0.9,
              padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                   height: height * 0.41,
                    width: width * 0.99,
                   decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: grey,),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonFunctions.commonSpace(height * 0.02, 0),
                        Container(
                          height: height * 0.06,
                          width: width * 0.55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'Inventory Status',
                              style: textTheme.bodySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        CommonFunctions.commonSpace(height * 0.01, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.3,
                              width: width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                //color: Colors.blue// Add a rounded corner
                                //border: Border.all(color: Colors.grey.withOpacity(0.2)), // Add a subtle border
                              ),
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (PieTouchResponse? pieTouchResponse) {
                                      setState(() {
                                        if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                          touchedIndex = -1;
                                         return;
                                        }
                                        touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  sectionsSpace: 2, // Space between sections
                                  centerSpaceRadius: 50, // Radius of the center space to create a donut effect
                                  sections: showingSections(lowStockPercentage,outOfStockPercentage,arrivingStockPercentage),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonFunctions.commonSpace(height * 0.1, 0),
                                  Row(
                                    children: [
                                      Container(
                                        height: height*0.02,
                                        width: width*0.04,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.orange,
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.02),
                                      Text('Low Stock',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  CommonFunctions.commonSpace(height * 0.01, 0),
                                  Row(
                                    children: [
                                      Container(
                                        height: height*0.02,
                                        width: width*0.04,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.02),
                                      Text('Out of Stock',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  CommonFunctions.commonSpace(height * 0.01, 0),
                                  Row(
                                    children: [
                                      Container(
                                        height: height*0.02,
                                        width: width*0.04,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.green,
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.02),
                                      Text('Arriving Stock',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold),)
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  Container(
                    height: height * 0.41,
                    width: width * 0.99,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: grey,),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonFunctions.commonSpace(height * 0.02, 0),
                        Container(
                          height: height * 0.06,
                          width: width * 0.75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: primaryColor,
                          ),
                          child: Center(
                            child: Text(
                              'Product Expiry Status',
                              style: textTheme.bodySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        CommonFunctions.commonSpace(height * 0.01, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: height * 0.3,
                              width: width * 0.6,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                //color: Colors.blue// Add a rounded corner
                                //border: Border.all(color: Colors.grey.withOpacity(0.2)), // Add a subtle border
                              ),
                              child: PieChart(
                                PieChartData(
                                  pieTouchData: PieTouchData(
                                    touchCallback: (PieTouchResponse? pieTouchResponse) {
                                      setState(() {
                                        if (pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                                          touchedIndex2 = -1;
                                          return;
                                        }
                                        touchedIndex2 = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                      });
                                    },
                                  ),
                                  sectionsSpace: 2,
                                  centerSpaceRadius: 5,// Space between sections
                                  sections: showingPieChartSections(withInWeekPercentage,withInMonthPercentage,withInYearPercentage),
                                ),
                              ),
                            ),
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CommonFunctions.commonSpace(height * 0.1, 0),
                                  Row(
                                    children: [
                                      Container(
                                        height: height*0.02,
                                        width: width*0.04,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.red,
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.02),
                                      Text('Within week',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  CommonFunctions.commonSpace(height * 0.01, 0),
                                  Row(
                                    children: [
                                      Container(
                                        height: height*0.02,
                                        width: width*0.04,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.orange,
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.02),
                                      Text('Within Month',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold),)
                                    ],
                                  ),
                                  CommonFunctions.commonSpace(height * 0.01, 0),
                                  Row(
                                    children: [
                                      Container(
                                        height: height*0.02,
                                        width: width*0.04,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.green,
                                        ),
                                      ),
                                      CommonFunctions.commonSpace(0, width*0.02),
                                      Text('Within Year',style:TextStyle(fontSize:10,fontWeight: FontWeight.bold),)
                                    ],
                                  ),

                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  CommonFunctions.commonSpace(height * 0.02, 0),
                  if(monthlyData.isNotEmpty)
                    Container(
                      height: height * 0.62,
                      width: width * 0.98,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: grey,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CommonFunctions.commonSpace(height * 0.02, 0),
                          Container(
                            height: height * 0.06,
                            width: width * 0.75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: primaryColor,
                            ),
                            child: Center(
                              child: Text(
                                'Product Category Sale',
                                style: textTheme.bodySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          CommonFunctions.commonSpace(height * 0.02, 0),
                          Container(
                            height: height * 0.4,
                            width: width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10), // Add a rounded corner
                              border: Border.all(color: Colors.grey.withOpacity(0.2)), // Add a subtle border
                            ),
                            child: BarChart(
                              BarChartData(
                                borderData: FlBorderData(
                                  show: true,
                                  border: Border(
                                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                                  ),
                                ),
                                barGroups: List.generate(monthlyData.length, (index) {
                                  final data = monthlyData[index];
                                  return BarChartGroupData(
                                    x: index, // Use index as x value
                                    barsSpace: 5, // Increase the space between bars
                                    barRods: [
                                      BarChartRodData(
                                        width: 30,
                                        y: data.medicineSale, // Sale data for y value
                                        colors: [Colors.pink.withOpacity(0.8)], // Customize bar color with opacity
                                        borderRadius: BorderRadius.circular(5), // Add a rounded corner to the bar
                                      ),
                                      BarChartRodData(
                                        width: 30,
                                        y: data.cosmeticsSale, // Profit data for y value
                                        colors: [Colors.red.withOpacity(0.8)], // Customize bar color with opacity
                                        borderRadius: BorderRadius.circular(5), // Add a rounded corner to the bar
                                      ),
                                      BarChartRodData(
                                        width: 30,
                                        y: data.babyCareSale, // Profit data for y value
                                        colors: [Colors.orange.withOpacity(0.8)], // Customize bar color with opacity
                                        borderRadius: BorderRadius.circular(5), // Add a rounded corner to the bar
                                      ),
                                      BarChartRodData(
                                        width: 30,
                                        y: data.petCareSale, // Profit data for y value
                                        colors: [Colors.green.withOpacity(0.8)], // Customize bar color with opacity
                                        borderRadius: BorderRadius.circular(5), // Add a rounded corner to the bar
                                      ),
                                    ],
                                  );
                                }),
                                titlesData: FlTitlesData(
                                  bottomTitles: SideTitles(
                                    showTitles: true,
                                    getTextStyles: (value, _) => TextStyle(
                                      color: Colors.black.withOpacity(0.7), // Customize text color with opacity
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500, // Add a bit of boldness to the text
                                    ),
                                    margin: 10,
                                    getTitles: (value) {
                                      // Convert index to month name from the list
                                      return monthNames[value.toInt()];
                                    },
                                  ),
                                  leftTitles: SideTitles(
                                    showTitles: false, // Show y-axis titles
                                    getTextStyles: (value, _) => TextStyle(
                                      color: Colors.black.withOpacity(0.7), // Customize text color with opacity
                                      fontSize: 12,
                                    ),
                                    margin: 10,
                                  ),
                                ),
                                gridData: FlGridData(
                                  show: true, // Show grid lines
                                  getDrawingHorizontalLine: (value) {
                                    return FlLine(
                                      color: Colors.grey.withOpacity(0.2), // Customize grid line color with opacity
                                      strokeWidth: 0.5,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          CommonFunctions.commonSpace(height*0.02,0),
                          Container(
                            height: height * 0.1,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: height * 0.01),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonFunctions.commonSpace(height * 0.01, 0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.02,
                                                    width: width * 0.04,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.pink,
                                                    ),
                                                  ),
                                                  CommonFunctions.commonSpace(0, width * 0.02),
                                                  Text(
                                                    'Medicine',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              CommonFunctions.commonSpace(height * 0.01, 0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.02,
                                                    width: width * 0.04,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.orange,
                                                    ),
                                                  ),
                                                  CommonFunctions.commonSpace(0, width * 0.02),
                                                  Text(
                                                    'Cosmetics',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        CommonFunctions.commonSpace(0, width * 0.08),
                                        Container(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              CommonFunctions.commonSpace(height * 0.01, 0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.02,
                                                    width: width * 0.04,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.yellow,
                                                    ),
                                                  ),
                                                  CommonFunctions.commonSpace(0, width * 0.02),
                                                  Text(
                                                    'Baby Care',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                              CommonFunctions.commonSpace(height * 0.01, 0),
                                              Row(
                                                children: [
                                                  Container(
                                                    height: height * 0.02,
                                                    width: width * 0.04,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(10),
                                                      color: Colors.green,
                                                    ),
                                                  ),
                                                  CommonFunctions.commonSpace(0, width * 0.02),
                                                  Text(
                                                    'Pet Care',
                                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ):Center(child: Text('No Data for this Store',style:textTheme.labelLarge,)),
    );
  }
  List<PieChartSectionData> showingSections(double lowStock, double arrivingStock, double outOfStock) {
    final double touchedRadius = 60.0;
    final double untouchedRadius = 50.0;

    return [
      PieChartSectionData(
        value: lowStock,
        title: '${lowStock.toStringAsFixed(0)}%',
        color: Colors.orange,
        radius: touchedIndex == 0 ? touchedRadius : untouchedRadius,
        titleStyle: TextStyle(fontSize: touchedIndex == 0 ? 25.0 : 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        value: outOfStock,
        title: '${outOfStock.toStringAsFixed(0)}%',
        color: Colors.red,
        radius: touchedIndex == 1 ? touchedRadius : untouchedRadius,
        titleStyle: TextStyle(fontSize: touchedIndex == 1 ? 25.0 : 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        value: arrivingStock,
        title: '${arrivingStock.toStringAsFixed(0)}%',
        color: Colors.green,
        radius: touchedIndex == 2 ? touchedRadius : untouchedRadius,
        titleStyle: TextStyle(fontSize: touchedIndex == 2 ? 25.0 : 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }
  List<PieChartSectionData> showingPieChartSections(double week, double month, double year) {
    final double touchedRadius = 110.0;
    final double untouchedRadius = 90.0;

    return [
      PieChartSectionData(
        value: week,
        title: '${week.toStringAsFixed(0)}%',
        color: Colors.red,
        radius: touchedIndex2 == 0 ? touchedRadius : untouchedRadius,
        titleStyle: TextStyle(fontSize: touchedIndex2 == 0 ? 25.0 : 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        value: month,
        title: '${month.toStringAsFixed(0)}%',
        color: Colors.orange,
        radius: touchedIndex2 == 1 ? touchedRadius : untouchedRadius,
        titleStyle: TextStyle(fontSize: touchedIndex2 == 1 ? 25.0 : 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
      PieChartSectionData(
        value: year,
        title: '${year.toStringAsFixed(0)}%',
        color: Colors.green,
        radius: touchedIndex2 == 2 ? touchedRadius : untouchedRadius,
        titleStyle: TextStyle(fontSize: touchedIndex2 == 2 ? 25.0 : 14.0, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    ];
  }

}
