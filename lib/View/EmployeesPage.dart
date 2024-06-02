import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/Utils/widgets/PopMenuEmployee.dart';
import 'package:pharmasage/View/AddEmployee.dart';
import 'package:provider/provider.dart';

import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/Authprovider.dart';
import 'EmployeeDetails.dart';

class EmployeePage extends StatefulWidget {
  final String branchId;

  const EmployeePage({Key? key, required this.branchId}) : super(key: key);

  @override
  State<EmployeePage> createState() => _EmployeePageState();
}

class _EmployeePageState extends State<EmployeePage> {
  late Stream<QuerySnapshot> employeeStream;

  @override
  void initState() {
    super.initState();
    employeeStream = FirebaseFirestore.instance
        .collection('Employees')
        .doc(widget.branchId)
        .collection('Employee ID')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AdminProvider>(context, listen: false).role;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: employeeStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          final List<QueryDocumentSnapshot> employees = snapshot.data!.docs;

          final height = MediaQuery.of(context).size.height;
          final textTheme = Theme.of(context).textTheme;

          return Container(
            height: height,
            padding: EdgeInsets.symmetric(vertical:20,horizontal: 10),
            child: ListView.separated(
              itemCount: employees.length,
              scrollDirection: Axis.vertical,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: height * 0.01); // Adjust the height as needed
              },
              itemBuilder: (context, index) {
                final employeeData = employees[index].data() as Map<String, dynamic>;

                return GestureDetector(
                  onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EmployeeDetails(employeeData: employeeData),
                    ),
                  );
                  },
                  child: Card(
                    color: grey,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Container(
                      height: height * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: height * 0.06,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                                          employeeData['employeeName'],
                                          textAlign: TextAlign.center,
                                          style: textTheme.bodySmall!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                YourEmployeeWidget(employeeData: employeeData,),
                              ],
                            ),
                          ),
                          CommonFunctions.commonSpace(height * 0.01, 0),
                          ListTile(
                            leading: ClipOval(
                              child: Container(
                                width: 50, // Adjust the size as needed
                                height: 50, // Adjust the size as needed
                                color: Colors.transparent,
                                child: Image.network(
                                  employeeData['employeeImageURL'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            title: Text(employeeData['employeeID'], style: textTheme.bodySmall),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(employeeData['employeeContact'], style: textTheme.bodySmall),
                                Text(employeeData['employeeEmail'], style: textTheme.bodySmall),
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
          );
        },
      ),
      floatingActionButton: role == 'Branch Manager' // Use role variable here
          ? FloatingActionButton(
        backgroundColor: primaryColor,
        child: Icon(Icons.add, size: 35),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEmployee()),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(15.0))),
      )
          : null, // If role is not 'Branch Manager', return null
    );
  }
}
