import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Constants/CommonFunctions.dart';
import '../../Model/Product/Productdetails.dart';
import '../../Utils/colors.dart';
import '../../databasehelper.dart';
class AdminProducts extends StatefulWidget {
  final currentVendor;
  const AdminProducts({super.key,required this.currentVendor});

  @override
  State<AdminProducts> createState() => _AdminProductsState();
}

class _AdminProductsState extends State<AdminProducts> {
  DatabaseHelper db=DatabaseHelper();
  FirebaseAuth auth=FirebaseAuth.instance;
  Future<List<Product>> fetchProducts(String branchManagerId) async {
    print(branchManagerId);
    List<Product> products = [];
    try {
      QuerySnapshot productSnapshot = await FirebaseFirestore.instance
          .collection('Products')
          .doc(branchManagerId) // Assuming branchManagerId is the document ID
          .collection('SellerProducts')
          .get();
      print('ye lo ${productSnapshot}');
      productSnapshot.docs.forEach((sellerProductDoc) {
        products.add(Product.fromMap(sellerProductDoc.data() as Map<String, dynamic>));
        print(sellerProductDoc);
      });
      print('products ${products}');
      return products;
    } catch (e) {
      print('Error fetching products: $e');
      return []; // Return empty list in case of error
    }
  }



  @override
  Widget build(BuildContext context) {
    //final carting=Provider.of<CartProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    //final carting=Provider.of<CartProvider>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: primaryColor,
            title:Text('Products', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
            centerTitle: true,
        ),
        body: FutureBuilder<List<Product>>(
          future: fetchProducts(widget.currentVendor['email']), // Pass branch manager ID here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products available'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final product = snapshot.data![index];
                  return Card(
                    color: Colors.white,
                    child: ListTile(
                      leading: Image.network(product.productImage!),
                      //CommonFunctions.commonSpace(0, width*0.003),
                      //title: Text(product.productName!,style: textTheme.labelLarge,),
                      title: Padding(
                        padding: const EdgeInsets.only(left:8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(product.productName!,style: textTheme.labelLarge,),
                            CommonFunctions.commonSpace(height*0.01, 0),
                            Text(product.productCompany!,style: textTheme.labelLarge,),
                            CommonFunctions.commonSpace(height*0.01, 0),
                            Text('\PKR ${product.productPrice.toString()}',style: textTheme.labelLarge,),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),

      ),
    );
  }
}
