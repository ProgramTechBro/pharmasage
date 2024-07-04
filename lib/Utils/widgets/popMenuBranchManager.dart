import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/ChangePassword.dart';
import 'package:pharmasage/View/EditProfile.dart';
import 'package:pharmasage/View/Vendors/editBMProfile.dart';

import '../../View/ChangeBMPassword.dart';
enum StoreAction { edit, Change, delete }
class PopMenuBranchManagerProfile extends StatefulWidget {
  final String bmUsername;
   PopMenuBranchManagerProfile({super.key,required this.bmUsername});

  @override
  State<PopMenuBranchManagerProfile> createState() => _PopMenuBranchManagerProfileState();
}

class _PopMenuBranchManagerProfileState extends State<PopMenuBranchManagerProfile> {
  late String bmUsername;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bmUsername=widget.bmUsername;
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return PopupMenuButton<StoreAction>(
      icon: const Icon(Icons.more_vert,color: Colors.white,),
      onSelected: (StoreAction action) {
        handleStoreAction(context, action,);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<StoreAction>>[
        PopupMenuItem<StoreAction>(
          value: StoreAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit),
              CommonFunctions.commonSpace(0, width*0.02),
              const Text('Edit BMProfile', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        PopupMenuItem<StoreAction>(
          value: StoreAction.Change,
          child:Row(
            children: [
              const Icon(Icons.lock_open_rounded),
              CommonFunctions.commonSpace(0, width*0.02),
              const Text('Change BMPassword', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }

  void handleStoreAction(BuildContext context, StoreAction action) {
    if (action == StoreAction.edit) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditBMProfile(bMUserName: bmUsername,)));
    } else if (action == StoreAction.Change) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeBMPassword()));
      // You can show a confirmation dialog before deleting if needed
    }
  }
}
