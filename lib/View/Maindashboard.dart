import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/Utils/widgets/MainDrawer.dart';
import 'package:pharmasage/View/AddStore.dart';
import 'package:pharmasage/View/StoreDashboard.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider/Authprovider.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({Key? key}) : super(key: key);

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    String owner=auth.currentUser!.email!;
    final Stream<QuerySnapshot> storeStream = FirebaseFirestore.instance
        .collection('Medical Stores').where('branchOwnerName',isEqualTo: owner)
        .snapshots();

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: storeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final List<DocumentSnapshot> stores = snapshot.data!.docs;

          // Filter medical stores based on branchOwnerName
          final List<DocumentSnapshot> filteredStores = stores.where((store) {
            final branchOwnerName = store['branchOwnerName'];
            return branchOwnerName == auth.currentUser!.email;
          }).toList();

          final textTheme = Theme.of(context).textTheme;
          final fullName = Provider.of<AdminProvider>(context).vendorDetail.fullName;

          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.03, vertical: MediaQuery.of(context).size.height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text('Hello ! Mr. $fullName', style: textTheme.bodyLarge!.copyWith(letterSpacing: 0.1)),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    child: ListView.separated(
                      itemCount: filteredStores.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: MediaQuery.of(context).size.height * 0.02);
                      },
                      itemBuilder: (context, index) {
                        final storeData = filteredStores[index].data() as Map<String, dynamic>;

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => storeDashboard(branchID: storeData['branchID'])),
                            );
                          },
                          child: Card(
                            color: grey,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height * 0.05,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
                                      color: primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        storeData['branchName'],
                                        style: textTheme.displaySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
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
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(text: 'Branch Location : ', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                            TextSpan(text: storeData['branchLocation'], style: textTheme.bodySmall),
                                          ]),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.005),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add, size: 35),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddStore()),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      ),
      drawer: AppDrawer(),
    );
  }
}
