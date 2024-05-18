import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/AdminController/EmployeeController.dart';
import '../Controller/Provider/Employeeprovider.dart';
import '../Controller/Provider/StoreProvider.dart';
import '../Model/Employee/Employees.dart';
import '../Utils/colors.dart';
import '../Utils/widgets/InputTextFiellds.dart';
class AddEmployee extends StatefulWidget {
  const AddEmployee({super.key});

  @override
  State<AddEmployee> createState() => _AddEmployeeState();
}

class _AddEmployeeState extends State<AddEmployee> {
  TextEditingController employeeIDController=TextEditingController();
  TextEditingController employeeNameController=TextEditingController();
  TextEditingController employeeEmailController=TextEditingController();
  TextEditingController employeeCNICController=TextEditingController();
  TextEditingController employeeContactController=TextEditingController();
  TextEditingController employeePositionController=TextEditingController();
  TextEditingController employeeSalaryController=TextEditingController();
  TextEditingController employeeBranchIdController=TextEditingController();
  bool addEmployeeButton=false;
  onPressed()async
  {
    setState(() {
      addEmployeeButton=true;
    });
    String name=employeeIDController.text;
    final productImage = Provider.of<EmployeeProvider>(context,listen: false).employeeImage;
    if (productImage != null && productImage.existsSync() && productImage.lengthSync() > 0) {
      await EmployeeController.uploadEmployeeImageToFirebaseStorage(images: Provider.of<EmployeeProvider>(context,listen: false).employeeImage!, context: context,imageNAme: name);
      String employeeImage=Provider
          .of<EmployeeProvider>(context,listen: false).employeeImageUrL;
      print('Emplayee Image Url $employeeImage');
      Employees employees=Employees(
        employeeID: employeeIDController.text,
        employeeImageURL: employeeImage,
        employeeName: employeeNameController.text,
        employeeEmail: employeeEmailController.text,
        employeeCNIC: employeeCNICController.text,
        employeeContact: employeeContactController.text,
        employeePosition: employeePositionController.text,
        employeeSalary: employeeSalaryController.text,
        employeeBranchID: employeeBranchIdController.text,

      );
      await EmployeeController.addEmployee(
          context: context, employees: employees);
      employeeIDController.clear();
      employeeNameController.clear();
      employeeEmailController.clear();
      employeeCNICController.clear();
      employeeContactController.clear();
      employeePositionController.clear();
      employeeSalaryController.clear();
      employeeBranchIdController.clear();
      setState(() {
        addEmployeeButton = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title:Text('Add Employee', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Container(
              width: width,
              padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Consumer<EmployeeProvider>(
                    builder: (context,productProvider,child){
                      return Builder(builder: (context){
                        if(productProvider.employeeImage==null)
                        {
                          return InkWell(
                            onTap: (){
                              productProvider.fetchEmployeeImagesFromGallery(context: context);
                            },
                            child: Container(
                              height: height*0.23,
                              width: width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: greyShade3),
                              ),
                              child: Column(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.add,size: height*0.07,color: greyShade3,),
                                  Text('Upload Pic',style: textTheme.displayMedium!.copyWith(color: greyShade3),)
                                ],
                              ),
                            ),
                          );
                        }
                        else
                        {
                          File images=Provider.of<EmployeeProvider>(context,listen: false).employeeImage!;
                          return Container(
                            height: height*0.23,
                            width: width,
                            decoration: BoxDecoration(
                              //color: Colors.amber,
                                image: DecorationImage(
                                  image: FileImage(File(images.path)),fit: BoxFit.contain,
                                )
                            ),
                          );
                        }
                      });
                    },
                  ),
                  CommonFunctions.commonSpace(height*0.03,0 ),
                  Text('Enter Employee Details here :',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.03,0 ),
                  Text('Employee ID',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeIDController,title: 'Employee ID', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee Name',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeNameController,title: 'Employee Name', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee Email',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeEmailController,title: 'Employee Name', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee CNIC',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeCNICController,title: 'Employee CNIC', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee Contact',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeContactController,title: 'Employee Contact', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee Position',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeePositionController,title: 'Employee Position', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee Salary',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeSalaryController,title: 'Employee Salary', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.02, 0),
                  Text('Employee BranchID',style: textTheme.bodyMedium),
                  CommonFunctions.commonSpace(height*0.008, 0),
                  InputTextFieldSeller( controller:employeeBranchIdController,title: 'Employee Branch ID', textTheme: textTheme),
                  CommonFunctions.commonSpace(height*0.04, 0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                      minimumSize: Size(width, height * 0.08),
                    ),
                    onPressed: onPressed,
                    child: addEmployeeButton
                        ? CircularProgressIndicator(color: white)
                        : Text(
                      'Add Employee',
                      style: textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
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
