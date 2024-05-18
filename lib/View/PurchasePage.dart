// import 'package:flutter/material.dart';
// import 'package:pharmasage/Utils/colors.dart';
// import 'package:pharmasage/View/OrdersDetails.dart';
// import '../Constants/CommonFunctions.dart';
// class PurchasePage extends StatefulWidget {
//   const PurchasePage({super.key});
//
//   @override
//   State<PurchasePage> createState() => _PurchasePageState();
// }
//
// class _PurchasePageState extends State<PurchasePage> {
//   var selectedcategory = 'All';
//   List<String> categories = [
//     'All',
//     'Daily',
//     'Weekly',
//     'Monthly',
//   ];
//   List<String> orderTypes = [
//     'Orders In Process',
//     'Completed Orders',
//     'Accepted Orders',
//     'Rejected Orders',
//   ];
//   List<String> iconPics = [
//     'assets/Icons/process.png',
//     'assets/Icons/completed.png',
//     'assets/Icons/accepted.png',
//     'assets/Icons/rejected.png',
//   ];
//   List<String> iconImg = [
//     'assets/Icons/pr.png',
//     'assets/Icons/co.png',
//     'assets/Icons/ap.png',
//     'assets/Icons/ro.png',
//   ];
//   List<String> details = [
//     '25',
//     '70',
//     '10',
//     '12',
//   ];
//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final textTheme = Theme.of(context).textTheme;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             width: width,
//             padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: height * 0.02),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 CommonFunctions.commonSpace(height*0.02,0),
//                 // Padding(
//                 //   padding: const EdgeInsets.symmetric(horizontal: 16),
//                 //   child: SizedBox(
//                 //     height: height*0.065,
//                 //     child: ListView.builder(
//                 //       scrollDirection: Axis.horizontal,
//                 //       itemCount: categories.length,
//                 //       itemBuilder: (context, index) {
//                 //         return GestureDetector(
//                 //           onTap: () {
//                 //             selectedcategory = categories[index];
//                 //             setState(() {});
//                 //           },
//                 //           child: Container(
//                 //             width: width*0.27,
//                 //             margin: const EdgeInsets.only(right: 12),
//                 //             padding: const EdgeInsets.only(right: 16, left: 16),
//                 //             decoration: BoxDecoration(
//                 //               borderRadius: BorderRadius.circular(17),
//                 //               border: Border.all(color:grey,width: 6),
//                 //               color: selectedcategory == categories[index]
//                 //                   ? grey
//                 //                   : Colors.white,
//                 //             ),
//                 //             child: Center(
//                 //               child: Text(
//                 //                 categories[index],
//                 //                 style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
//                 //               ),
//                 //             ),
//                 //           ),
//                 //         );
//                 //       },
//                 //     ),
//                 //   ),
//                 // ),
//                 // CommonFunctions.commonSpace(height*0.03,0),
//                 // Container(
//                 //   width: width,
//                 //   height: height*0.003,
//                 //   color: Colors.grey,
//                 // ),
//                 // Container(
//                 //   padding: EdgeInsets.symmetric(horizontal: width * 0.06, vertical: height * 0.02),
//                 //   child: Row(
//                 //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //     children: [
//                 //       Text('Total Accepted Orders :',style: textTheme.bodyLarge),
//                 //       Text('25',style: textTheme.bodyLarge),
//                 //     ],
//                 //   ),
//                 // ),
//                 // Container(
//                 //   width: width,
//                 //   height: height*0.003,
//                 //   color: Colors.grey,
//                 // ),
//                 //CommonFunctions.commonSpace(height*0.03,0),
//                 GridView.builder(
//                     physics:const NeverScrollableScrollPhysics(),
//                     itemCount: 4,
//                     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10),
//                     shrinkWrap: true,
//                     itemBuilder: (context,index){
//                       return InkWell(
//                         onTap: (){
//                           Navigator.push(context, MaterialPageRoute(builder: (context) => OrdersDetails()));
//                         },
//                         child: Container(
//                           height: height*0.2,
//                           decoration: BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(20)),
//                             color: grey,
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 height: height * 0.05,
//                                 decoration: BoxDecoration(
//                                   borderRadius: const BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
//                                   color: primaryColor,
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     orderTypes[index],
//                                     style: textTheme.bodyLarge!.copyWith(color: Colors.white, fontWeight: FontWeight.w500),
//                                   ),
//                                 ),
//                               ),
//                               //CommonFunctions.commonSpace(height * 0.01, 0),
//                               Container(
//                                 //padding: EdgeInsets.all(10),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                    Container(
//                                      height: height*0.10,
//                                      width: width*0.6,
//                                      decoration: BoxDecoration(
//                                        //color: Colors.red,
//                                        image: DecorationImage(
//                                          image: AssetImage(iconImg[index]),
//                                        )
//                                      ),
//                                    ),
//                                     Center(
//                                       child: Container(
//                                         height: height*0.06,
//                                         width: width*0.35,
//                                         decoration: BoxDecoration(
//                                           borderRadius: BorderRadius.circular(25),
//                                           color: Colors.white,
//                                         ),
//                                         child: Row(
//                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Image.asset(iconPics[index]),
//                                             Text(details[index],style: textTheme.displayLarge!.copyWith(fontWeight: FontWeight.w900)),
//                                           ],
//                                         ),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//               ],
//             ),
//           ),
//
//         )
//       ),
//     );
//   }
// }
