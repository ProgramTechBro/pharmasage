import 'package:flutter/material.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:pharmasage/Utils/widgets/Textontheline.dart';
import '../Constants/CommonFunctions.dart';
import '../Utils/widgets/DataContainer.dart';

class StoreDetails extends StatelessWidget {
  final Map<String, dynamic> storeData;

  const StoreDetails({Key? key, required this.storeData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Store Details', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.04, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height * 0.04, 0),
                Center(
                  child: Container(
                    width: width * 0.9,
                    height: height * 0.25,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                        image: storeData['branchImageURL'] != 'NULL'
                            ? NetworkImage(storeData['branchImageURL']) as ImageProvider<Object>
                            : AssetImage('assets/images/farmer.png'), // Use the URL from storeData for the image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                CommonFunctions.commonSpace(height * 0.04, 0),
                Center(
                  child: Text(storeData['branchName'], style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                ),
                CommonFunctions.commonSpace(height * 0.04, 0),
                Container(
                  width: width,
                  padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Branch ID', style: textTheme.labelMedium),
                      CommonFunctions.commonSpace(height * 0.01, 0),
                      DataContainer(icon: Icons.person_outline, title: storeData['branchID'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                      CommonFunctions.commonSpace(height * 0.02, 0),
                      Text('Branch Location', style: textTheme.labelMedium),
                      CommonFunctions.commonSpace(height * 0.01, 0),
                      DataContainer(icon: Icons.person_outline, title: storeData['branchLocation'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                      CommonFunctions.commonSpace(height * 0.02, 0),
                      Text('Branch Manager', style: textTheme.labelMedium),
                      CommonFunctions.commonSpace(height * 0.01, 0),
                      DataContainer(icon: Icons.person_outline, title: storeData['branchManagerName'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                      CommonFunctions.commonSpace(height * 0.02, 0),
                    ],
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
