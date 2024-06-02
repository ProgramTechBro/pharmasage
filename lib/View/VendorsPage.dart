import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pharmasage/View/AdminProducts.dart';
import 'package:pharmasage/View/BMProducts.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/Authprovider.dart';
import '../Utils/colors.dart';
import 'Vendors/AdminProducts.dart';

CommonFunctions common = CommonFunctions();

class VendorPage extends StatefulWidget {
  const VendorPage({Key? key}) : super(key: key);

  @override
  State<VendorPage> createState() => _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  List<DocumentSnapshot> users = [];
  List<DocumentSnapshot> filteredUsers = [];


  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('Users').get();
    setState(() {
      users = snapshot.docs;
      filteredUsers = users;
    });
  }
  void filterUsers(String keyword) {
    setState(() {
      filteredUsers = users.where((user) {
        final userData = user.data() as Map<String, dynamic>;
        final fullName = userData['fullName'].toString().toLowerCase();
        return fullName.contains(keyword.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final roletogo = Provider.of<AdminProvider>(context, listen: false).role;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search, color: grey), // Set prefix icon color to grey
                    hintText: 'Search by name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: grey),
                    ),
                  ),
                  cursorColor: grey, // Set cursor color to grey
                  onChanged: (value) {
                    filterUsers(value);
                    print(value);
                  },
                ),
                CommonFunctions.commonSpace(height * 0.03, 0),
                Container(
                  height: height * 0.8,
                  child: users.isEmpty
                      ? Center(child: CircularProgressIndicator(color: primaryColor,))
                      : ListView.separated(
                    itemCount: users.length,
                    scrollDirection: Axis.vertical,
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: height * 0.002);
                    },
                    itemBuilder: (context, index) {
                      final userData = users[index].data() as Map<String, dynamic>;
                      final role = userData['role'];
                     print('role $role');
                      if (role == 'Vendor') {
                        final fullName = userData['fullName'];
                        final username = userData['userName'];
                        final email=userData['email'];
                        final contact=userData['contact'];
                        final image=userData['imagesURL'];

                        return GestureDetector(
                          onTap: (){
                            print('something');
                           if(roletogo=='Pharmacist')
                             {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => AdminProducts(currentVendor: userData,)),
                               );
                             }
                           else if(roletogo=='Branch Manager')
                             {
                               print(email);
                               if (email != null) {
                                 Navigator.push(
                                   context,
                                   MaterialPageRoute(builder: (context) => BranchManagerProducts(currentVendor: userData)),
                                 );
                               } else {
                                 // Handle the case where email is null
                               }
                             }
                          },
                          child: Card(
                            color: grey,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Container(
                              height: height * 0.23,
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
                                        Text(
                                          fullName,
                                          style: textTheme.bodyMedium!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
                                  CommonFunctions.commonSpace(height * 0.01, 0),
                                  ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      backgroundImage: image != 'NULL'
                                          ? NetworkImage(image)
                                          : AssetImage('assets/images/farmer.png') as ImageProvider<Object>?,
                                    ),
                                    title: Text(username, style: textTheme.labelMedium),
                                    //CommonFunctions.commonSpace(height * 0.01, 0),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CommonFunctions.commonSpace(height * 0.01, 0),
                                        Text(contact, style: textTheme.labelMedium),
                                        CommonFunctions.commonSpace(height * 0.01, 0),
                                        Text(email, style: textTheme.labelMedium),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      } else {
                        // Return an empty container if the user is not a vendor
                        return Container();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
