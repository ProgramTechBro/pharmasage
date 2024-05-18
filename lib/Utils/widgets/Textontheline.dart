import 'package:flutter/material.dart';
import '../../Constants/CommonFunctions.dart';
class Textontheline extends StatelessWidget {
  const Textontheline({
    super.key,
    required this.textTheme,
    required this.height,
    required this.width,
    required this.title,
  });

  final TextTheme textTheme;
  final double height;
  final double width;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: textTheme.labelMedium,
        ),
        CommonFunctions.commonSpace(height*0.01,0),
        Container(
          width: width*0.5,
          height: height*0.0021,
          color: Colors.grey,
        ),
      ],
    );
  }
}