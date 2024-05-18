import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pharmasage/Controller/Provider/InventoryCartProvider.dart';
import 'package:pharmasage/View/SplashScreen.dart';
import 'package:provider/provider.dart';
import 'Controller/Provider/Authprovider.dart';
import 'Controller/Provider/CartProvider.dart';
import 'Controller/Provider/Employeeprovider.dart';
import 'Controller/Provider/POSProvider.dart';
import 'Controller/Provider/ProductProvider.dart';
import 'Controller/Provider/ReturnProvider.dart';
import 'Controller/Provider/StoreProvider.dart';
import 'Utils/theme.dart';
import 'firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<AdminProvider>(create: (context)=>AdminProvider()),
          ChangeNotifierProvider<ProductProvider>(create: (context)=>ProductProvider()),
          ChangeNotifierProvider<StoreProvider>(create: (context)=>StoreProvider()),
          ChangeNotifierProvider<EmployeeProvider>(create: (context)=>EmployeeProvider()),
          ChangeNotifierProvider<CartProvider>(create: (context)=>CartProvider()),
          ChangeNotifierProvider<POSProvider>(create: (context)=>POSProvider()),
          ChangeNotifierProvider<InventoryCartProvider>(create: (context)=>InventoryCartProvider()),
          ChangeNotifierProvider<ReturnProvider>(create: (context)=>ReturnProvider()),
        ],
    child:MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: theme,
    home: SplashScreen(),
    //home: const ForgetPassword(key: key, email: email),
    ),
    );
  }
}

