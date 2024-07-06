import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/View/Vendors/LoginPage.dart';
import 'package:provider/provider.dart';
import '../Utils/widgets/DeleteEmployeeDialog.dart';
import '../Utils/widgets/DeletePOSProductdialog.dart';
import '../Utils/widgets/DeleteStoreDialog.dart';
import '../Utils/widgets/deleteBranchManagerDailog.dart';
import '../View/MyProfile.dart';
import '../utils/colors.dart';
FirebaseAuth auth=FirebaseAuth.instance;
class CommonFunctions{
  static commonSpace(double? height,double? width)
  {
    return SizedBox(height: height??0,width: width??0,);
  }
  static Devider()
  {
    return Divider(
      color: grey,
      height: 10,
      indent: 10,
      thickness: 5,
    );
  }
  // static showToast({required BuildContext context,required String message}){
  //   return Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_SHORT,
  //     gravity: ToastGravity.TOP,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: white,
  //     textColor: black,
  //     fontSize: 16.0,
  //   );
  // }
  static showSuccessToast(
      {required BuildContext context, required String message}) {
    return MotionToast.success(
      title: const Text('Success'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showErrorToast(
      {required BuildContext context, required String message}) {
    return MotionToast.error(
      title: const Text('Error'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }

  static showWarningToast(
      {required BuildContext context, required String message}) {
    return MotionToast.warning(
      title: const Text('Opps!'),
      description: Text(message),
      position: MotionToastPosition.top,
    ).show(context);
  }
  void showMainPopupMenu(BuildContext context,double height,double width) {
    final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          overlay.localToGlobal(overlay.size.topRight(Offset.zero)),
          overlay.localToGlobal(overlay.size.topRight(Offset.zero)),
        ),
        Offset.zero & overlay.size,
      ),
      items: [
         PopupMenuItem<String>(
          value: 'item1',
          child: Row(
            children: [
              Icon(Icons.account_circle),
              CommonFunctions.commonSpace(0, width*0.03),
              Text('My Profile', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
         PopupMenuItem<String>(
          value: 'item2',
          child: Row(
            children: [
              Icon(Icons.exit_to_app),
              CommonFunctions.commonSpace(0, width*0.03),
              Text('Logout', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
        // Add more PopupMenuItem widgets for additional items
      ],
    ).then((value) {
      if (value == 'item1') {
        Navigator.push(context, PageTransition(child: const MyProfile(), type: PageTransitionType.rightToLeft));
      } else if (value == 'item2') {
        auth.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    });
  }
  void showDeleteStoreDialog(BuildContext context,String title,String content,String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteStoreDialog(
          title: title,
          content: content,
          id: id,

        );
      },
    );
  }
  void showDeletePOSProductDialog(BuildContext context,String title,String content,String id,String storeId)  {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeletePOSProductDialog(
          title: title,
          content: content,
          id: id,
          storeId:storeId,
        );
      },
    );
  }
  void showDeleteEmployeeDialog(BuildContext context,String title,String content,String empId,String branchId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteEmployeeDialog(
          title: title,
          content: content,
          empId: empId,
          storeId: branchId,
        );
      },
    );
  }
  void showDeleteBranchManagerDialog(BuildContext context,String title,String content,String bId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteBranchManagerDialog(
          title: title,
          content: content,
          bId:bId,
        );
      },
    );
  }
  List<String> productCategories = [
    'Select Category',
    'Medicine',
    'Cosmetics',
    'Baby Care',
    'Pet Care',
  ];
  List<String> posCategories = [
    'All',
    'Medicine',
    'Cosmetics',
    'Baby Care',
    'Pet Care',
  ];
}
