import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/View/Dashboard.dart';
import 'package:pharmasage/View/VendorDashboard.dart';
import 'package:provider/provider.dart';

import '../Constants/CommonFunctions.dart';

UserHandler services = UserHandler();

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({Key? key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Role Selection'),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CommonFunctions.commonSpace(height * 0.03, 0),
                  Text(
                    'Choose your Role',
                    style: textTheme.bodyMedium,
                  ),
                  CommonFunctions.commonSpace(height * 0.03, 0),
                  InkWell(
                    onTap: () async {
                      Provider.of<AdminProvider>(context,listen: false).setUpdateStatus();
                      await services.updateRoleForUser(context, 'Admin/Owner');
                      Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Dashboard()),
                      );
                    },
                    child: Container(
                      height: height*0.3,
                      width: width*0.55,
                      child: Card(
                        color: grey,
                        child: Column(
                          children: [
                            CommonFunctions.commonSpace(height * 0.02, 0),
                            //Image.asset('assets/images/ad.png',height: height*0.3,width: width*0.5,),
                            Container(
                              width: width * 0.4,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/ad.png'), // Use AssetImage for local images
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CommonFunctions.commonSpace(height * 0.01, 0),
                            Text(
                              'Pharmacist',
                              style: textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CommonFunctions.commonSpace(height * 0.04, 0),
                  InkWell(
                    onTap: () async {
                      Provider.of<AdminProvider>(context,listen: false).setUpdateStatus();
                      await services.updateRoleForUser(context, 'Vendor');
                      Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => VendorDashboard()),
                      );
                    },
                    child: Container(
                      height: height*0.3,
                      width: width*0.55,
                      child: Card(
                        color: grey,
                        child: Column(
                          children: [
                            CommonFunctions.commonSpace(height * 0.02, 0),
                            //Image.asset('assets/images/vd.png',height: height*0.3,width: width*0.5,),
                            Container(
                              width: width * 0.4,
                              height: height * 0.2,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/vd.png'), // Use AssetImage for local images
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            CommonFunctions.commonSpace(height * 0.01, 0),
                            Text(
                              'Vendor',
                              style: textTheme.displaySmall!.copyWith(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: Provider.of<AdminProvider>(context).roleUpdate,
              child: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
