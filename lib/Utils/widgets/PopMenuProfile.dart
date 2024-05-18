import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/ChangePassword.dart';
import 'package:pharmasage/View/EditProfile.dart';
enum StoreAction { edit, Change, delete }
class PopMenuProfile extends StatelessWidget {
  final String role;
  const PopMenuProfile({super.key,required this.role});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return PopupMenuButton<StoreAction>(
      icon: const Icon(Icons.more_vert),
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
              const Text('Edit Profile', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
        PopupMenuItem<StoreAction>(
          value: StoreAction.Change,
          child:Row(
            children: [
              const Icon(Icons.lock_open_rounded),
              CommonFunctions.commonSpace(0, width*0.02),
              const Text('Change Password', style: TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
  void handleStoreAction(BuildContext context, StoreAction action) {
    if (action == StoreAction.edit) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile(role: role,)));
    } else if (action == StoreAction.Change) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()));
      // You can show a confirmation dialog before deleting if needed
    }
  }
}
