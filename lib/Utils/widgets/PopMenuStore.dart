import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/View/BranchManagerPage.dart';
import '../../View/EditStore.dart';
import 'PopMenuProfile.dart';
class YourWidget extends StatelessWidget {
  final Map<String, dynamic> storeData;

  YourWidget({required this.storeData});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return PopupMenuButton<StoreAction>(
      icon: const Icon(Icons.more_vert, color: Colors.white),
      onSelected: (StoreAction action) {
        handleStoreAction(context, action);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<StoreAction>>[
        PopupMenuItem<StoreAction>(
          value: StoreAction.edit,
          child: Row(
            children: [
              const Icon(Icons.edit),
              CommonFunctions.commonSpace(0, width * 0.02),
              const Text('Edit Store', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
        PopupMenuItem<StoreAction>(
          value: StoreAction.delete,
          child: Row(
            children: [
              const Icon(Icons.delete),
              CommonFunctions.commonSpace(0, width * 0.02),
              const Text('Delete Store', style: TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ],
    );
  }

  void handleStoreAction(BuildContext context, StoreAction action) {
    if (action == StoreAction.edit) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => EditStore(storeData: storeData)));
    } else if (action == StoreAction.delete) {
      common.showDeleteStoreDialog(context,'Delete Store','Are you Sure you want to delete this Store?',storeData['branchID']);
    }
  }
}
