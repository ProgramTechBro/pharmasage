import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/EmployeeController.dart';
import 'package:pharmasage/Controller/AdminController/StoreController.dart';
import 'package:pharmasage/Controller/Service/Admin/vendorServices.dart';
import 'package:pharmasage/Utils/colors.dart';
UserHandler handler=UserHandler();
class DeleteBranchManagerDialog extends StatefulWidget {
  final String title;
  final String content;
  final String bId;

  const DeleteBranchManagerDialog({Key? key, required this.title, required this.content, required this.bId})
      : super(key: key);

  @override
  _DeleteBranchManagerDialogState createState() => _DeleteBranchManagerDialogState();
}

class _DeleteBranchManagerDialogState extends State<DeleteBranchManagerDialog> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Center(child: Text(widget.title, style: textTheme.bodyLarge)),
      content: Text(
        widget.content,
        style: textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  _isDeleting = true; // Show circular indicator
                });
                await handler.deleteBMUserDocument(context,widget.bId);
                //await EmployeeController.deleteEmployee(context: context, employeeID: widget.empId,branchID: widget.storeId);
                print('Helooooooooooooooooooooooooo');
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                setState(() {
                  _isDeleting = false; // Hide circular indicator
                });
                // Close the dialog
              },
              child: _isDeleting
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Delete',
                style: textTheme.bodyMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                minimumSize: Size(width * 0.3, height * 0.06),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: textTheme.bodyMedium!.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                primary: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                minimumSize: Size(width * 0.3, height * 0.06),
              ),
            ),
          ],
        ),
        CommonFunctions.commonSpace(0, width * 0.02),
      ],
    );
  }
}
