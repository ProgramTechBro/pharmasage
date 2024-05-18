import 'package:flutter/material.dart';
import '../../Constants/CommonFunctions.dart';
import '../colors.dart';
class DataContainer extends StatelessWidget {
  const DataContainer({
    super.key,
    required this.height,
    required this.width,
    required this.textTheme,
    required this.title,
    required this.icon,
  });

  final double height;
  final double width;
  final TextTheme textTheme;
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height*0.07,
      width: width*0.95,
      padding: EdgeInsets.symmetric(vertical: 12,horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color:primaryColor),
        color: grey,
      ),
      child: Row(

        children: [
          Text(title,style: textTheme.labelMedium,),
        ],
      ),
    );
  }
}
