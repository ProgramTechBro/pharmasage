import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/ProductController.dart';
import 'package:pharmasage/Controller/Provider/Authprovider.dart';
import 'package:pharmasage/Model/OrderModel/Order.dart';
import 'package:pharmasage/databasehelper.dart';
import 'package:provider/provider.dart';

import '../Controller/Provider/CartProvider.dart';
import '../Model/CartModel/cartmodel.dart';
import '../Model/Product/Productdetails.dart';
import '../Utils/colors.dart';
import '../Utils/modifiedtext.dart';
class CartPage extends StatefulWidget {
  final currentVendor;
  const CartPage({super.key,required this.currentVendor});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  DatabaseHelper helper=DatabaseHelper();
  late Future<List<Cart>> list;
  bool isPlacingOrder=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list=helper.getnoteslist();
  }
  String generateOrderId() {
    // Generate a random number between 100 and 900
    int randomNumber = Random().nextInt(801) + 100;

    // Concatenate "R" with the random number to create the order ID
    String orderId = 'R$randomNumber';

    return orderId;
  }
  String getCurrentDateFormatted() {
    // Get the current date
    DateTime now = DateTime.now();

    // Create a DateFormat instance with the desired format
    DateFormat formatter = DateFormat('dd MMM yyyy');

    // Format the date and return it as a string
    String formattedDate = formatter.format(now);

    return formattedDate;
  }
  String getCurrentTimeFormatted() {
    // Get the current time
    DateTime now = DateTime.now();

    // Create a DateFormat instance with the desired format
    DateFormat formatter = DateFormat('hh:mm a');

    // Format the time and return it as a string
    String formattedTime = formatter.format(now);

    return formattedTime;
  }
  onPressed()async
  {
    setState(() {
      isPlacingOrder=true;
    });
    String bId=Provider.of<AdminProvider>(context,listen: false).Branchid;
    print('Branch id $bId');
    final vendor=widget.currentVendor;
    int totalPrice=Provider.of<CartProvider>(context,listen: false).gettotalprice().toInt();
    String orderId=generateOrderId();
    String orderDate=getCurrentDateFormatted();
    String orderTime=getCurrentTimeFormatted();
    final cartItems = await helper.getnoteslist();

    // Create a list of products from cart items
    final products = cartItems.map((cartItem) {
      return Product(
        productImage: cartItem.imagePath.toString(),
        productID: cartItem.productId.toString(),
        productName: cartItem.productName,
        productCompany: cartItem.productCompany,
        productSellerId:vendor['email'] ,
        productCategory: cartItem.productCategory,
        productPrice: cartItem.productPrice!.toDouble(),
        quantity: cartItem.quantity!,
        // Add other product details if needed
      );
    }).toList();
    OrderModel ordermodel=OrderModel(
      orderID: orderId,
      orderDate:orderDate,
      orderTime: orderTime,
      orderStatus: 'Pending',
      vendorName: vendor['fullName'],
      vendorEmail: vendor['email'],
      vendorContact: vendor['contact'],
      storeId: bId,
      orderedProducts: products,
      totalAmount: totalPrice,
    );
    await OrderController.addOrder(context: context, model: ordermodel);
    helper.clearCart();
    setState(() {
      list = Future.value([]);
    });
    Provider.of<CartProvider>(context,listen: false).resetPref();


    setState(() {
      isPlacingOrder=false;
    });
  }
  Widget build(BuildContext context) {
    final carts=Provider.of<CartProvider>(context);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
        child: Scaffold(
        appBar: AppBar(
        backgroundColor: primaryColor,
        title:Text('Cart Page', style: textTheme.displaySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
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
                  child: Icon(Icons.shopping_cart,color: Colors.white,size: 35,),
                )
            ),
            SizedBox(width: 10,),
          ],
        ),
        body:Column(
          children: [
            Expanded(
              child: Container(
                child: FutureBuilder<List<Cart>>(
                  future:list,
                  builder: (context,snapshot){
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: primaryColor,));
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: modifiedtext(text:'No Items in Cart',colors: Colors.black,Size: 30,));
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context,index){
                          //final initialtotal=snapshot.data![index].initialPrice;
                          return Card(
                            color: Colors.white,
                            child: Container(
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                children: [
                                  Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Image.network(snapshot.data![index].imagePath!),
                                        height: 70,
                                        width: 70,
                                      ),
                                      SizedBox(width: 10,),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            CommonFunctions.commonSpace(height*0.02, 0),
                                            Text(snapshot.data![index].productName!,style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),),
                                            CommonFunctions.commonSpace(height*0.01, 0),
                                            Text(snapshot.data![index].productCompany!,style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),),
                                            CommonFunctions.commonSpace(height*0.01, 0),
                                            Text('\PKR ${snapshot.data![index].productPrice.toString()}',style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500),),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    //color: Colors.blue,
                                      child:Column(
                                        mainAxisAlignment:MainAxisAlignment.spaceEvenly ,
                                        children: [
                                          GestureDetector(onTap:(){
                                            helper.deleteNote(snapshot.data![index].id!);
                                            carts.removecounter();
                                            carts.removetotalPrice(snapshot.data![index].productPrice!.toDouble());
                                            setState(() {
                                              list=helper.getnoteslist();
                                            });
                                          },child: Icon(Icons.delete,color: red,size: 30,)),
                                          SizedBox(height: 20,),
                                          Container(
                                            height: 40,
                                            width: 100,
                                            margin: EdgeInsets.only(right: 15,bottom: 5),
                                            decoration: BoxDecoration(
                                              color: primaryColor,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Center(
                                              child: Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  GestureDetector(onTap:(){
                                                    int quantity=snapshot.data![index].quantity!;
                                                    print(quantity);
                                                    int price=snapshot.data![index].initialPrice!;
                                                    quantity++;
                                                    print(quantity);
                                                    int? newprice=quantity*price;
                                                    helper.updateNote(
                                                        Cart(
                                                          id:snapshot.data![index].id,
                                                          productId:snapshot.data![index].id.toString(),
                                                          productName: snapshot.data![index].productName,
                                                          productCompany: snapshot.data![index].productCompany,
                                                          initialPrice: snapshot.data![index].initialPrice,
                                                          productCategory: snapshot.data![index].productCategory,
                                                          productPrice: newprice,
                                                          quantity: quantity,
                                                          imagePath: snapshot.data![index].imagePath,
                                                        )
                                                    ).then((value) {
                                                      setState(() {
                                                        snapshot.data![index].quantity = quantity;
                                                        snapshot.data![index].productPrice=newprice;// Update the displayed quantity
                                                      });
                                                      newprice=0;
                                                      quantity=0;
                                                      carts.addtotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));
                                                    }).onError((error, stackTrace){
                                                      print(error.toString());
                                                    });
                                                    //carts.addquantity();
                                                  },child: Icon(Icons.add,color: Colors.white,size: 20,)),
                                                  SizedBox(width: 15,),
                                                  modifiedtext(text:snapshot.data![index].quantity.toString(),colors: Colors.white,Size: 15,),
                                                  SizedBox(width: 15,),
                                                  GestureDetector(onTap:(){
                                                    int quantity=snapshot.data![index].quantity!;
                                                    int price=snapshot.data![index].initialPrice!;
                                                    quantity--;
                                                    int? newprice=quantity*price;
                                                    if(quantity>0)
                                                    {
                                                      helper.updateNote(
                                                          Cart(
                                                            id:snapshot.data![index].id,
                                                            productId:snapshot.data![index].id.toString(),
                                                            productName: snapshot.data![index].productName,
                                                            productCompany: snapshot.data![index].productCompany,
                                                            initialPrice: snapshot.data![index].initialPrice,
                                                            productCategory: snapshot.data![index].productCategory,
                                                            productPrice: newprice,
                                                            quantity: quantity,
                                                            imagePath: snapshot.data![index].imagePath,
                                                          )
                                                      ).then((value) {
                                                        setState(() {
                                                          snapshot.data![index].quantity = quantity;
                                                          snapshot.data![index].productPrice=newprice;// Update the displayed quantity
                                                        });
                                                        newprice=0;
                                                        quantity=0;
                                                        carts.removetotalPrice(double.parse(snapshot.data![index].initialPrice!.toString()));

                                                      }).onError((error, stackTrace){
                                                        print(error.toString());
                                                      });
                                                    }
                                                  },child: Icon(Icons.remove,color: Colors.white,size: 20,)),
                                                  //CommonFunctions.commonSpace(0, width*0.005),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        },

                      );
                    }
                  },
                ),
              ),

            ),
            Visibility(
              visible: carts.gettotalprice().toString()=="0.0"?false:true,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                      children: [
                        modifiedtext(text:'Subtotal',colors: Colors.black,Size: 15,),
                        Consumer<CartProvider>(
                            builder:(context,value,key){
                              return modifiedtext(text: '\$${value.gettotalprice()}',colors: Colors.black,Size: 15,);
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                      children: [
                        modifiedtext(text:'Dicount 0%',colors: Colors.black,Size: 15,),
                        modifiedtext(text: '\$0',colors: Colors.black,Size: 15,)
                      ],
                    ),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                      children: [
                        modifiedtext(text:'Total',colors: Colors.black,Size: 15,),
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, key) {
                            double totalAfterSubtraction = cartProvider.gettotalprice() - 0.0;

                            return modifiedtext(text: '\$${totalAfterSubtraction.toStringAsFixed(2)}', colors: Colors.black, Size: 15);
                          },
                        ),

                      ],
                    ),
                    CommonFunctions.commonSpace(height*0.02, 0),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                        minimumSize: Size(width, height * 0.08),
                      ),
                      onPressed: onPressed,
                      child: isPlacingOrder
                          ? CircularProgressIndicator(color: white)
                          : Text(
                        'Place Order',
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

          ],
        ) ,
    ),
    );
  }
}
