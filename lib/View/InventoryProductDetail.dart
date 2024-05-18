import 'package:flutter/material.dart';

import '../Constants/CommonFunctions.dart';
import '../Utils/colors.dart';
class InventoryProductDetails extends StatefulWidget {
  final product;
  const InventoryProductDetails({super.key,required this.product});

  @override
  State<InventoryProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<InventoryProductDetails> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title:Text('Product Details', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500,color: Colors.white)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            width: width,
            padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CommonFunctions.commonSpace(height*0.03,0 ),
                Center(
                  child: Container(
                    height: height*0.65,
                    width: width*0.95,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Color(0xFFD9D9D9),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CommonFunctions.commonSpace(height*0.03,0 ),
                        Center(
                          child: Container(
                            width: width * 0.5,
                            height: height * 0.25,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                image: NetworkImage(widget.product['productImage']), // Use the URL from storeData for the image
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        CommonFunctions.commonSpace(height*0.02,0 ),
                        Center(child: Text(widget.product['productName'],style: textTheme.labelLarge,),),
                        CommonFunctions.commonSpace(height*0.02,0 ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: width*0.08),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Product ID : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                  TextSpan(text: widget.product['productID'].toString()!, style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height*0.02,0 ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Product Category : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                  TextSpan(text: widget.product['productCategory'], style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height*0.02,0 ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Product InStock : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                  TextSpan(text: widget.product['productQuantity'].toString(), style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height*0.02,0 ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Expiry Date : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                  TextSpan(text: widget.product['productExpiry'].toString()!, style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height*0.02,0 ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Cost Price : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                  TextSpan(text: widget.product['costPrice'].toString(), style: textTheme.bodySmall),
                                ]),
                              ),
                              CommonFunctions.commonSpace(height*0.02,0 ),
                              RichText(
                                text: TextSpan(children: [
                                  TextSpan(text: 'Selling Price : ', style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w500)),
                                  TextSpan(text: widget.product['sellingPrice'].toString(), style: textTheme.bodySmall),
                                ]),
                              ),
                            ],
                          ),
                        )

                      ],
                    ),
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
