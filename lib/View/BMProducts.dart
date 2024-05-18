import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/CommonFunctions.dart';
import '../Controller/Provider/CartProvider.dart';
import '../Model/CartModel/cartmodel.dart';
import '../Model/Product/Productdetails.dart';
import '../Utils/colors.dart';
import '../Utils/modifiedtext.dart';
import '../databasehelper.dart';
import 'CartPage.dart';
class BranchManagerProducts extends StatefulWidget {
  final currentVendor;
  const BranchManagerProducts({super.key,required this.currentVendor});

  @override
  State<BranchManagerProducts> createState() => _BranchManagerProductsState();
}

class _BranchManagerProductsState extends State<BranchManagerProducts> {
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
            actions:  [
          Center(
          child: Badge(
          largeSize: 20,
            label: Consumer<CartProvider>(
              builder: (context,value,child){
                return Text(value.getcounter().toString(),style: TextStyle(
                  fontSize: 14,
                ),);
              },
            ),
            child: GestureDetector(onTap:(){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage(currentVendor: widget.currentVendor,)));
            },child: Icon(Icons.shopping_cart,color: Colors.white,size: 35,)),
          )
        ),
      SizedBox(width: 10,),
      ]
          ),
          body: FutureBuilder<List<Product>>(
            future: fetchProducts(widget.currentVendor['email']), // Pass branch manager ID here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: primaryColor,));
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.productName!,style: textTheme.labelLarge,),
                              CommonFunctions.commonSpace(height*0.01, 0),
                              Text(product.productCompany!,style: textTheme.labelLarge,),
                              CommonFunctions.commonSpace(height*0.01, 0),
                              Text('\PKR ${product.productPrice.toString()}',style: textTheme.labelLarge,),
                            ],
                          ),
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            //Adding Product in Local Database SQFLite To show in Cart
                            db.insert(
                              Cart(
                                id: index,
                                productId: product.productID,
                                productName: product.productName,
                                productCompany: product.productCompany,
                                initialPrice: product.productPrice!.toInt(),
                                productPrice: product.productPrice!.toInt(),
                                productCategory: product.productCategory,
                                quantity: 1,
                                //unitTag: product.productUnits,
                                imagePath: product.productImage,
                              ),
                            ).then((value) {
                              //print('Data added');
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Row(children: [
                                const Icon(Icons.check_circle),
                                CommonFunctions.commonSpace(0, width*0.2),
                                const Text('Product added')
                              ],)));
                              const SnackBar(content: Text('Product added'),);
                              //Updating Total Price and Counter of Cart
                              Provider.of<CartProvider>(context,listen: false).addtotalPrice(double.parse(product.productPrice.toString()));
                              Provider.of<CartProvider>(context,listen: false).addcounter();
                            }).onError((error, stackTrace) {
                              print(error.toString());
                            });

                          },
                          child: modifiedtext(text: 'Buy', colors: Colors.white, Size: 15,),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
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
