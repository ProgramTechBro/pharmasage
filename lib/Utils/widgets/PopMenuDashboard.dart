import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
class PopManu extends StatefulWidget {
  const PopManu({
    super.key,
  });

  @override
  State<PopManu> createState() => _PopManuState();
}

class _PopManuState extends State<PopManu> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return PopupMenuButton<String>(
      color: Colors.white,
      onSelected: (value) {
        if (value == 'item1') {
          {

          }
        }
        else if (value == 'item5') {

        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'item1',
            child: Row(
              children: [
                const Icon(Icons.account_circle),
                CommonFunctions.commonSpace(0, width*0.04),
                const Text('My Profile', style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
           PopupMenuItem<String>(
            value: 'item2',
            child: Row(
              children: [
                const Icon(Icons.exit_to_app),
                CommonFunctions.commonSpace(0, width*0.04),
                const Text('Logout', style: TextStyle(fontSize: 17),),
              ],
            ),
          ),
          // Add more PopupMenuItem widgets for additional items
        ];
      },
    );
  }
}
