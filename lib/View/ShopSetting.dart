import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/Utils/widgets/PopMenuStore.dart';
import 'package:pharmasage/View/StoreDetails.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider/Authprovider.dart';
import '../Constants/CommonFunctions.dart';

class ShopSetting extends StatefulWidget {
  const ShopSetting({Key? key}) : super(key: key);

  @override
  State<ShopSetting> createState() => _ShopSettingState();
}

class _ShopSettingState extends State<ShopSetting> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream:FirebaseFirestore.instance
              .collection('Medical Stores').where('branchOwnerName',isEqualTo: _auth.currentUser!.email!)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            final List<DocumentSnapshot> stores = snapshot.data!.docs;

            return SingleChildScrollView(
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    Center(
                      child: Text(
                        'Shop Setting',
                        style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Container(
                      height: height * 0.8,
                      child: ListView.separated(
                        itemCount: stores.length,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
                        },
                        itemBuilder: (context, index) {
                          final storeData = stores[index].data() as Map<String, dynamic>;

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => StoreDetails(storeData: storeData)),
                              );
                            },
                            child: Card(
                              color: grey,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                height: height * 0.2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: height * 0.05,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                        color: primaryColor,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  child: Text(
                                                    storeData['branchName'],
                                                    textAlign: TextAlign.center,
                                                    style: textTheme.bodySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          YourWidget(storeData: storeData),
                                        ],
                                      ),
                                    ),
                                    CommonFunctions.commonSpace(height * 0.01, 0),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(text: 'Branch Code : ', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                              TextSpan(text: storeData['branchID'], style: textTheme.bodySmall),
                                            ]),
                                          ),
                                          CommonFunctions.commonSpace(height * 0.005, 0),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(text: 'Branch Location : ', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                              TextSpan(text: storeData['branchLocation'], style: textTheme.bodySmall),
                                            ]),
                                          ),
                                          CommonFunctions.commonSpace(height * 0.005, 0),
                                          RichText(
                                            text: TextSpan(children: [
                                              TextSpan(text: 'Branch Manager : ', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                              TextSpan(text: storeData['branchManagerName'], style: textTheme.bodySmall),
                                            ]),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
