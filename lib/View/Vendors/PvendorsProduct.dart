import 'package:flutter/material.dart';
import 'package:pharmasage/Utils/colors.dart';
import 'package:provider/provider.dart';
import '../../Controller/Provider/Authprovider.dart';
import '../../Utils/widgets/productGrid.dart';
import 'AddProduct.dart';
class vendorProducts extends StatefulWidget {
  const vendorProducts({super.key});

  @override
  State<vendorProducts> createState() => _vendorProductsState();
}

class _vendorProductsState extends State<vendorProducts> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AdminProvider>(context,listen: false).loadUserDataIntoMemory();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
       floatingActionButton: FloatingActionButton(
         backgroundColor: primaryColor,
         onPressed: (){
           Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => const AddProduct()),
           );
         },
         child: Icon(Icons.add,color: white,),
       ),
        body: ProductsGrid(),
      ),
    );
  }
}
