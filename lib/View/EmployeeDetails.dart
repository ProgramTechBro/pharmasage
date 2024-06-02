import 'package:flutter/material.dart';
import '../Constants/CommonFunctions.dart';
import '../Model/Employee/Employees.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/DataContainer.dart';
import '../Utils/widgets/Textontheline.dart';
class EmployeeDetails extends StatefulWidget {
  final Map<String, dynamic> employeeData;
   EmployeeDetails({super.key,required this.employeeData});

  @override
  State<EmployeeDetails> createState() => _EmployeeDetailsState();
}

class _EmployeeDetailsState extends State<EmployeeDetails> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:Text('Employee Details', style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
          centerTitle: true,
          //automaticallyImplyLeading: false,
        ),
      body: SingleChildScrollView(
        child: Container(
        width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.05, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonFunctions.commonSpace(height * 0.01, 0),
              Center(
                child: ClipOval(
                  child: Container(
                    width: width*0.5, // Adjust the size as needed
                    height: height*0.23, // Adjust the size as needed
                    color: Colors.transparent,
                    child: Image.network(
                      widget.employeeData['employeeImageURL'],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              CommonFunctions.commonSpace(height * 0.02, 0),
              Center(
                child: Text(widget.employeeData['employeeName'], style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.5)),
              ),
              CommonFunctions.commonSpace(height * 0.04, 0),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeeID'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeeEmail'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeeCNIC'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeeContact'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeePosition'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeeSalary'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                    Text('Employee ID', style: textTheme.labelMedium),
                    CommonFunctions.commonSpace(height * 0.01, 0),
                    DataContainer(icon: Icons.person_outline, title: widget.employeeData['employeeBranchID'] ?? 'No Data', height: height, width: width, textTheme: textTheme),
                    CommonFunctions.commonSpace(height * 0.02, 0),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ),
    );
  }
}

