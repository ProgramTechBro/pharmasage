import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/AdminController/EmployeeController.dart';
import 'package:pharmasage/Model/Employee/Employees.dart';
import 'package:pharmasage/View/EditProfile.dart';
import 'package:provider/provider.dart';
import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/Employeeprovider.dart';
import '../Utils/colors.dart';
FirebaseAuth auth = FirebaseAuth.instance;
EmployeeController controller=EmployeeController();
class EditEmployee extends StatefulWidget {
  final Map<String, dynamic> employeeData;
  const EditEmployee({super.key,required this.employeeData});

  @override
  State<EditEmployee> createState() => _EditEmployeeState();
}

class _EditEmployeeState extends State<EditEmployee> {
  @override
  void dispose() {
    super.dispose();
  }
  late TextEditingController employeeIDController = TextEditingController();
  late TextEditingController employeeNameController = TextEditingController();
  late TextEditingController employeeEmailController = TextEditingController();
  late TextEditingController employeeCNICController = TextEditingController();
  late TextEditingController employeeContactController = TextEditingController();
  late TextEditingController employeeBranchIDController = TextEditingController();
  late TextEditingController employeePositionController = TextEditingController();
  late TextEditingController employeeSalaryController = TextEditingController();
  String? newEmployeeImage = '';
  bool isLoading=false;
  bool check = true;
  String empId='';
  String bid='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchEmployeeData();
  }
  fetchEmployeeData()async{
    setState(() {
      isLoading=true;
    });
    employeeDetails=await controller.getEmployeeData(widget.employeeData['employeeBranchID'],widget.employeeData['employeeID']);
    if(check){
      employeeIDController.text=employeeDetails['employeeID'];
      employeeNameController.text=employeeDetails['employeeName'];
      employeeEmailController.text=employeeDetails['employeeEmail'];
      employeeCNICController.text=employeeDetails['employeeCNIC'];
      employeeContactController.text=employeeDetails['employeeContact'];
      employeeBranchIDController.text=employeeDetails['employeeBranchID'];
      employeePositionController.text=employeeDetails['employeePosition'];
      employeeSalaryController.text=employeeDetails['employeeSalary'];
      check=false;
    }
    setState(() {
      isLoading=false;
    });
  }

   Map<String, dynamic> employeeDetails={};
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final provider=Provider.of<EmployeeProvider>(context,listen: false);
    // employeeDetails = provider.employeeData.isNotEmpty && provider.employeeData['employeeID'] == widget.employeeData['employeeID']
    //     ? provider.employeeData
    //     : widget.employeeData;
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('Edit Profile', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(color: primaryColor,),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Edit Profile', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: width,
          padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Center(
                child: Consumer<EmployeeProvider>(
                  builder: (context, profileImageProvider, child) {
                    return Stack(
                      children: [
                        Container(
                          height: height * 0.15,
                          width: width * 0.3,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: profileImageProvider.updatedEmployeeImage != null
                                  ? FileImage(File(profileImageProvider.updatedEmployeeImage!.path!))
                                  : NetworkImage(employeeDetails['employeeImageURL']!) as ImageProvider<Object>
                            ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: Container(
                            height: height * 0.09,
                            width: width * 0.10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(width: width * 0.003, color: Colors.grey),
                            ),
                            child: Center(
                              child: IconButton(
                                onPressed: () async {
                                  await provider.fetchUpdatedEmployeeImageFromGallery(context: context);
                                },
                                icon: Icon(Icons.camera_alt, size: 20),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              CommonFunctions.commonSpace(height * 0.04, 0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        EditTextField(Controller: employeeIDController, textTheme: textTheme, hintext: 'Enter EmployeeID', icon: Icons.person_pin),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeeNameController, textTheme: textTheme, hintext: 'Enter EmployeeName', icon: Icons.person_pin_rounded),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeeEmailController, textTheme: textTheme, hintext: 'Enter EmployeeEmail', icon: Icons.email_outlined),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeeCNICController, textTheme: textTheme, hintext: 'Enter EmployeeCNIC', icon: Icons.credit_card),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeeContactController, textTheme: textTheme, hintext: 'Enter EmployeeContact', icon: Icons.contact_mail),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeeBranchIDController, textTheme: textTheme, hintext: 'Enter EmployeeBranchID', icon: Icons.store),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeePositionController, textTheme: textTheme, hintext: 'Enter EmployeePosition', icon: Icons.work),
                        CommonFunctions.commonSpace(height * 0.03, 0),
                        EditTextField(Controller: employeeSalaryController, textTheme: textTheme, hintext: 'Enter EmployeeSalary', icon: Icons.attach_money),
                        CommonFunctions.commonSpace(height * 0.05, 0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                  side: BorderSide(color:primaryColor),
                                  minimumSize: Size(width, height * 0.08),
                                ),
                                onPressed: () async {
                                  CommonFunctions.showWarningToast(context: context, message: 'Changes Discarded');
                                  await Future.delayed(const Duration(seconds: 3));
                                  provider.removeUpdatedEmployeeImage();
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Discard',
                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color:primaryColor),
                                ),
                              ),
                            ),
                            CommonFunctions.commonSpace(0, width * 0.04),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                                  minimumSize: Size(width, height * 0.08),
                                ),
                                onPressed: () async {
                                  provider.updateEmployeeUpdateSaving();
                                  print('State updated is ${provider.updateSaving}');
                                  String? name = employeeDetails['employeeID'];
                                  empId=employeeIDController.text.isNotEmpty ? employeeIDController.text : employeeDetails['employeeID'];
                                  bid=employeeBranchIDController.text.isNotEmpty?employeeBranchIDController.text:employeeDetails['employeeBranchID'];
                                  if(provider.updatedEmployeeImage!=null)
                                  {
                                    final employeeImage = provider.updatedEmployeeImage;
                                    await EmployeeController.uploadUpdatedEmployeeImageToFirebaseStorage(images:employeeImage!, context: context, imageNAme:name!);
                                    newEmployeeImage = provider.updateEmployeeImageUrL;
                                    print('New URL is $newEmployeeImage');
                                  }
                                  else
                                  {
                                    newEmployeeImage=employeeDetails['employeeImageURL'];
                                  }
                                  Employees employeeData = Employees(
                                    employeeImageURL: newEmployeeImage,
                                    employeeID: employeeIDController.text.isNotEmpty ? employeeIDController.text : employeeDetails['employeeID'],
                                    employeeName:employeeNameController.text.isNotEmpty ? employeeNameController.text : employeeDetails['employeeName'] ,
                                    employeeEmail:employeeEmailController.text.isNotEmpty?employeeEmailController.text: employeeDetails['employeeEmail'],
                                    employeeCNIC: employeeCNICController.text.isNotEmpty?employeeCNICController.text: employeeDetails['employeeCNIC'],
                                    employeeContact:employeeContactController.text.isNotEmpty?employeeContactController.text: employeeDetails['employeeContact'],
                                    employeeBranchID: employeeBranchIDController.text.isNotEmpty?employeeBranchIDController.text:employeeDetails['employeeBranchID'],
                                    employeePosition: employeePositionController.text.isNotEmpty?employeePositionController.text: employeeDetails['employeePosition'],
                                    employeeSalary: employeeSalaryController.text.isNotEmpty?employeeSalaryController.text: employeeDetails['Salary'],
                                  );
                                  await controller.updateEmployeeData(context: context, details:employeeData);
                                  provider.updateEmployeeUpdateSaving();
                                  setState(() {});
                                },
                                child: provider.updateSaving
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text(
                                  'Save',
                                  style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
