import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../colors.dart';
class ProductItem extends StatelessWidget {
  final QueryDocumentSnapshot product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final textTheme = Theme.of(context).textTheme;
    return FutureBuilder<String>(
      future: _getImageUrl(product['productID']), // Fetch image URL from Firebase Storage
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: primaryColor,));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        final imageUrl = snapshot.data!;

        return ClipRRect(
       borderRadius: BorderRadius.circular(30),
          child: Card(
            color: grey,
            child: Container(
              decoration: BoxDecoration(
                //border: Border.all(color: ),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 10),
                  Text(product['productName'] ?? 'Unknown Product',style:textTheme.labelLarge ,),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<String> _getImageUrl(String productId) async {
    final ref = FirebaseStorage.instance.ref().child('Product_Images/$productId.jpg');
    return await ref.getDownloadURL();
  }
}