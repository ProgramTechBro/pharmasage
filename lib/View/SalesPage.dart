import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart'; // Import fl_chart
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/Service/apptrsnactioninvoicepdf.dart';
import 'package:pharmasage/Utils/colors.dart';
import '../Controller/Service/Invoicepdf.dart';
import '../Controller/Service/pdfApi.dart';
import '../Model/MonthlySale/MonthlySale.dart';
import '../Model/POS/POSProduct.dart';
import '../Model/Transaction/TransactionDetails.dart';
import '../Model/TransactionInvoice/TransactionInvoice.dart';
import '../Model/TransactionInvoice/TransactionStore.dart';

class SalesPage extends StatefulWidget {
  final String branchId;
  const SalesPage({Key? key, required this.branchId}) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  List<TransactionModel> transactions = [];
  List<MonthlyData> monthlyData = [];
  List<String> monthNames = []; // List to store month names
  late Future<void> dataFetchFuture;
  bool isInvoiceOpening = false;

  @override
  void initState() {
    super.initState();
    // Populate month names list
    populateMonthNames();
    // Assign the future returned by fetchData to dataFetchFuture
    dataFetchFuture = fetchData();
  }

  void populateMonthNames() {
    //Setting the current month and the previous three months for the bar chart
    final now = DateTime.now();
    for (int i = 0; i < 4; i++) {
      final date = DateTime(now.year, now.month - i, 1);
      monthNames.add(DateFormat('MMM').format(date));
    }
    monthNames = monthNames.reversed.toList();
    print(monthNames);
  }

  Future<void> fetchData() async {
    // Fetching all transactions
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Transactions')
        .doc(widget.branchId)
        .collection('TransactionID')
        .get();

    transactions = querySnapshot.docs.map((doc) => TransactionModel.fromSnapshot(doc)).toList();
    print(transactions);
    calculateMonthlyData();
  }

  void calculateMonthlyData() {
    final now = DateTime.now();
    final List<int> months = [];
    for (int i = 0; i < 4; i++) {
      final date = DateTime(now.year, now.month - (3 - i), 1);
      months.add(date.month);
    }

    print(months);
    monthlyData = months.map((month) {
      final monthlyTransactions = transactions.where((transaction) {
        final transactionDateParts = transaction.transactionDate!.split(' ');
        final transactionMonth = DateFormat.MMM().parse(transactionDateParts[1]).month;
        return transactionMonth == month;
      }).toList();
      print(monthlyTransactions.length);

      final monthlySale = monthlyTransactions.fold<double>(
          0, (previousValue, transaction) => previousValue + transaction.totalAmount!);
      final monthlyProfit = monthlyTransactions.fold<double>(
          0, (previousValue, transaction) => previousValue + (transaction.totalAmount! - calculateTotalCost(transaction)));

      return MonthlyData(
        month: DateFormat('MMM').format(DateTime(DateTime.now().year, month)),
        sale: monthlySale,
        profit: monthlyProfit,
      );
    }).toList();
  }


  double calculateTotalCost(TransactionModel transaction) {
    // Calculating Purchase
    return transaction.selectedProducts!.fold<double>(
      0,
          (previousValue, product) => previousValue + product.costPrice!,
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<void>(
            future: dataFetchFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // While fetching data, show a CircularProgressIndicator
                return Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: primaryColor),
                  ],
                ));
              }
              else if(transactions.isEmpty){
                return Center(child: Text('No Data for this store',style: textTheme.labelLarge,),);
              }
              else {
                // Once data is fetched, display the chart and transaction list
                return Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Chart showing sales and profit
                      if (monthlyData.isNotEmpty)
                        Container(
                          height: height * 0.54,
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
                                width: width * 0.55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: Text(
                                    'Sales and Profit',
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
                                            width: 20,
                                            y: data.sale, // Sale data for y value
                                            colors: [Colors.pink.withOpacity(0.8)], // Customize bar color with opacity
                                            borderRadius: BorderRadius.circular(5), // Add a rounded corner to the bar
                                          ),
                                          BarChartRodData(
                                            width: 20,
                                            y: data.profit, // Profit data for y value
                                            colors: [Colors.red.withOpacity(0.8)], // Customize bar color with opacity
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
                              )
                            ],
                          ),
                        ),
                      CommonFunctions.commonSpace(height * 0.03, 0),
                      // List of transactions
                      if (transactions.isNotEmpty)
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: transactions.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return SizedBox(height: height * 0.01);
                          },
                          itemBuilder: (context, index) {
                            final transaction = transactions[index];
                            return Container(
                              padding: EdgeInsets.symmetric(vertical: height * 0.02),
                              child: Card(
                                color: grey,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: height * 0.02, horizontal: width * 0.03),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(transaction.transactionID!, style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w700)),
                                      Row(
                                        children: [
                                          Text(transaction.transactionDate.toString(), style: textTheme.labelSmall),
                                          CommonFunctions.commonSpace(0, width * 0.05),
                                          Text(transaction.transactionTime.toString(), style: textTheme.labelSmall),
                                        ],
                                      ),
                                      //CommonFunctions.commonSpace(height * 0.01, 0),
                                      Center(
                                        child: const Text(
                                          '- - - - - - - - - - - - - - - - - - - - -',
                                          style: TextStyle(fontSize: 20),
                                        ),
                                      ),
                                      //CommonFunctions.commonSpace(height * 0.01, 0),
                                      Text('Transaction Summary', style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w700)),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Sub Total: ',
                                            style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(text: transaction.subTotalAmount.toString(), style: textTheme.bodySmall),
                                        ]),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Tax: ',
                                            style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(text: transaction.tax.toString(), style: textTheme.bodySmall),
                                        ]),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Total: ',
                                            style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(text: transaction.totalAmount.toString(), style: textTheme.bodySmall),
                                        ]),
                                      ),
                                      CommonFunctions.commonSpace(height * 0.01, 0),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              setState(() {
                                                isInvoiceOpening = true;
                                              });
                                              String storeName = transaction.storeName!;
                                              String storeLocation = transaction.storeLocation!;
                                              String tId = transaction.transactionID!;
                                              String tDate = transaction.transactionDate!;
                                              String tTime = transaction.transactionTime!;
                                              double tax = transaction.tax!;
                                              final List<InventoryProduct> selectedProducts = transaction.selectedProducts!;

                                              // Create InvoiceItem list from selected products
                                              final List<TransactionInvoiceItem> items = selectedProducts.map<TransactionInvoiceItem>((product) {
                                                return TransactionInvoiceItem(
                                                  description: product.productName!,
                                                  quantity: product.productQuantity!,
                                                  unitPrice: product.sellingPrice!,
                                                );
                                              }).toList();
                                              final invoice = TransactionInvoice(
                                                store: TransactionStore(
                                                  name: storeName,
                                                  address: storeLocation,
                                                  licenseNo: '3OB8-87654332',
                                                  contact: '0321-7655433',
                                                ),
                                                info: TransactionInvoiceInfo(
                                                  transactionId: tId,
                                                  transactionDate: tDate,
                                                  transactionTime: tTime,
                                                  tax: tax,
                                                ),
                                                items: items,
                                              );
                                              setState(() {
                                                isInvoiceOpening = false;
                                              });
                                              final pdfFile = await AppTransactionPdfInvoiceApi.generate(invoice);
                                              print('hello');
                                              FileHandleApi.openFile(pdfFile);
                                            },
                                            child: Container(
                                              height: height * 0.06,
                                              width: width * 0.3,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                color: Colors.white,
                                              ),
                                              child: isInvoiceOpening
                                                  ? CircularProgressIndicator(color: Colors.black)
                                                  : Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  //Image.asset('assets/Icons/in.jpeg'),
                                                  Icon(Icons.print, size: 20),
                                                  Text('Invoice', style: textTheme.labelLarge!.copyWith(fontWeight: FontWeight.w500)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      if (transactions.isEmpty)
                        Center(
                          child: Text(
                            'No transaction.',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                    ],
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
