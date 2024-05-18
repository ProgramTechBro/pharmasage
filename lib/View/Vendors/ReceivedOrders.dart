import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:provider/provider.dart';

import '../../Constants/CommonFunctions.dart';
import '../vendorOrderDetails.dart';

class ReceivedOrders extends StatefulWidget {
  const ReceivedOrders({Key? key}) : super(key: key);

  @override
  _ReceivedOrdersState createState() => _ReceivedOrdersState();
}

class _ReceivedOrdersState extends State<ReceivedOrders> {
  Future<Map<String, dynamic>> fetchStoreData(String storeId) async {
    try {
      final DocumentSnapshot storeSnapshot = await FirebaseFirestore.instance
          .collection('Medical Stores')
          .doc(storeId)
          .get();

      if (storeSnapshot.exists) {
        final storeData = storeSnapshot.data() as Map<String, dynamic>;
        return storeData;
      } else {
        throw Exception('Store not found');
      }
    } catch (e) {
      throw Exception('Error fetching store data: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Stream<QuerySnapshot> orderStream = FirebaseFirestore.instance
        .collection('ReceivedOrders')
        .snapshots();

    return  Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: orderStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final List<DocumentSnapshot> orders = snapshot.data!.docs;

          // Filter orders based on vendorEmail
          final List<DocumentSnapshot> filteredOrders = orders.where((order) {
            final vendorEmail = order['vendorEmail'];
            return vendorEmail == auth.currentUser!.email;
          }).toList();

          return ListView.builder(
            itemCount: filteredOrders.length,
            itemBuilder: (context, index)  {
              final orderData = filteredOrders[index].data() as Map<String, dynamic>;

              return FutureBuilder<Map<String, dynamic>>(
                future: fetchStoreData(orderData['storeId']),
                builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> storeSnapshot) {
                  if (storeSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: primaryColor));
                  }

                  if (storeSnapshot.hasError) {
                    return Center(child: Text('Error: ${storeSnapshot.error}'));
                  }

                  final store = storeSnapshot.data!;

                  return InkWell(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(orderData: orderData,store: store,),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                      child: Card(
                        color: grey,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Container(
                          height: height*0.3,
                          //padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: height * 0.05,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                                  color: primaryColor,
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(text: 'Status : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500,color: white)),
                                      TextSpan(text: orderData['orderStatus'], style: textTheme.bodySmall!.copyWith(color: white),),
                                    ]),
                                  ),
                                ),
                              ),
                              CommonFunctions.commonSpace(height * 0.01, 0),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: height*0.02,horizontal:width*0.04),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(text: 'Order ID : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                            TextSpan(text: orderData['orderID'], style: textTheme.bodySmall),
                                          ]),
                                        ),
                                        CommonFunctions.commonSpace(height*0.01,0),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(text: 'order Time : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                            TextSpan(text: orderData['orderTime'], style: textTheme.bodySmall),
                                          ]),
                                        ),
                                      ],
                                    ),
                                    CommonFunctions.commonSpace(height*0.01,0),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(text: 'Order Date : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                        TextSpan(text: orderData['orderDate'], style: textTheme.bodySmall),
                                      ]),
                                    ),
                                    Center(child: const Text('- - - - - - - - - - - - - - - - - - - -',style: TextStyle(fontSize: 20),)),
                                    CommonFunctions.commonSpace(height*0.01,0),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(text: 'Branch Name : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                        TextSpan(text: store['branchName'], style: textTheme.bodySmall),
                                      ]),
                                    ),
                                    CommonFunctions.commonSpace(height*0.02,0),
                                    RichText(
                                      text: TextSpan(children: [
                                        TextSpan(text: 'Branch Location : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                        TextSpan(text: store['branchLocation'], style: textTheme.bodySmall),
                                      ]),
                                    ),
                                  ],
                                ),

                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

