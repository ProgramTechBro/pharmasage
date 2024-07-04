import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmasage/View/AddBranchManager.dart';
import '../Constants/CommonFunctions.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/popMenuBranchManager.dart';

CommonFunctions common = CommonFunctions();

class BranchManager extends StatefulWidget {
  const BranchManager({Key? key}) : super(key: key);

  @override
  State<BranchManager> createState() => _BranchManagerState();
}

class _BranchManagerState extends State<BranchManager> {
  //late Stream<QuerySnapshot> _branchManagersStream;

  @override
  void initState() {
    super.initState();
    // Initialize the stream
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final Stream<QuerySnapshot> branchManagersStream = FirebaseFirestore.instance
        .collection('Users')
        .where('role', isEqualTo: 'Branch Manager')
        .snapshots();

    return SafeArea(
      child: Scaffold(
        body: StreamBuilder<QuerySnapshot>(
          stream: branchManagersStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: primaryColor,));
            }
            final List<DocumentSnapshot> users = snapshot.data!.docs;
            return SingleChildScrollView(
              child: Container(
                width: width,
                padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: height * 0.8,
                      child: ListView.separated(
                        itemCount: users.length,
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (BuildContext context, int index) {
                          return SizedBox(height: height * 0.02);
                        },
                        itemBuilder: (context, index) {
                          final userData = users[index].data() as Map<String, dynamic>;
                          final fullName = userData['bMFullName'];
                          final username = userData['bMUserName'];
                          final branchID = userData['branchID'];

                          return Card(
                            color: grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
                              height: height * 0.17,
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
                                                fullName,
                                                style: textTheme.displaySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                        ),
                                        PopMenuBranchManagerProfile(bmUsername:username,),
                                      ],
                                    )
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 10),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(children: [
                                            TextSpan(text: 'Username :     ', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                            TextSpan(text: username, style: textTheme.bodySmall),
                                          ]),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            RichText(
                                              text: TextSpan(children: [
                                                TextSpan(text: 'Branch ID :     ', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500)),
                                                TextSpan(text: branchID, style: textTheme.bodySmall),
                                              ]),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                common.showDeleteBranchManagerDialog(context,'Delete BranchManager','Are you Sure you want to delete this BranchManager?',username);
                                              },
                                              child: Container(
                                                height: height * 0.07,
                                                width: width * 0.07,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  border: Border.all(width: width * 0.003, color: Colors.grey),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
              MaterialPageRoute(builder: (context) => const AddBranchManager()),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
      ),
    );
  }
}
