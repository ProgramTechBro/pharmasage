import 'package:flutter/material.dart';
import 'package:pharmasage/Constants/CommonFunctions.dart';
import 'package:pharmasage/Controller/AdminController/ProductController.dart';
import 'package:pharmasage/Utils/colors.dart';
OrderController controller=OrderController();
class OrderDetailsPage extends StatefulWidget {
  final Map<String, dynamic> orderData;
  final Map<String, dynamic> store;
  const OrderDetailsPage({Key? key, required this.orderData,required this.store}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool orderAccepting=false;
  bool orderRejecting=false;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    final List<dynamic> orderedProducts = widget.orderData['orderedProducts'];

    return Scaffold(
      backgroundColor: Color(0xFFF0F0F0),
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CommonFunctions.commonSpace(height*0.02, 0),
            Center(
              child: Container(
                color: white,
                height: height*0.08,
                width: width*0.95,
                padding: EdgeInsets.symmetric(horizontal: width * 0.04,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Image',style: textTheme.labelLarge,),
                    CommonFunctions.commonSpace(height*0.01,0),
                    Text('Description',style: textTheme.labelLarge,),
                    Text('Quantity',style: textTheme.labelLarge,)
                  ],
                ),
              ),
            ),
            CommonFunctions.commonSpace(height*0.004,0),
            //SizedBox(height: height * 0.02),
            ListView.builder(
              shrinkWrap: true,
              itemCount: orderedProducts.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    Container(
                      color: white,
                      height: height*0.08,
                      width: width*0.95,
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04,),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(orderedProducts[index]['productImage']),
                          ),
                          Text(orderedProducts[index]['productName'], style: textTheme.labelMedium,),
                          Text(orderedProducts[index]['quantity'].toString(), style: textTheme.labelMedium,),
                        ],
                      ),
                    ),
                    CommonFunctions.commonSpace(height*0.004,0),
                  ],
                );
              },
            ),
            CommonFunctions.commonSpace(height*0.35,0),
            Padding(
              padding:  EdgeInsets.symmetric(horizontal: width*0.04),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          side: BorderSide(color:primaryColor),
                          minimumSize: Size(width, height*0.08),
                        ),
                        onPressed: ()  async{
                         setState(() {
                           orderRejecting=true;
                         });
                         await controller.rejectOrder(context: context, orderId: widget.orderData['orderID']);
                         setState(() {
                           orderRejecting = false;
                         });
                         CommonFunctions.showSuccessToast(
                           context: context,
                           message: 'Order Rejected',
                         ).then((_) {
                           // Pop the screen from the navigation stack after the toast is dismissed
                           Navigator.of(context).pop();
                         });
                        },
                        child:orderRejecting?CircularProgressIndicator(color: primaryColor,):Text('Reject',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: primaryColor),)),
                  ),
                  CommonFunctions.commonSpace(0, width*0.04),
                  Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
                          minimumSize: Size(width, height*0.08),
                        ),
                        onPressed:() async{
                          setState(() {
                            orderAccepting=true;
                          });
                          await controller.acceptOrder(context: context, orderId:widget.orderData['orderID'], orderData: widget.orderData);
                          setState(() {
                            orderAccepting = false;
                          });
                          CommonFunctions.showSuccessToast(
                            context: context,
                            message: 'Order Accepted',
                          ).then((_) {
                            // Pop the screen from the navigation stack after the toast is dismissed
                            Navigator.of(context).pop();
                          });
                        },
                        child:orderAccepting?CircularProgressIndicator(color: Colors.white,):Text('Accept',style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold,color: Colors.white),)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
