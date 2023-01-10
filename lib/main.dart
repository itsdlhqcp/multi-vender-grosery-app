import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_grocery_shop/vendor/auth/vendor_login_screen.dart';

import 'package:multi_grocery_shop/vendor/provider/cart_provider.dart';

import 'package:multi_grocery_shop/vendor/provider/product_vendor.dart';
import 'package:multi_grocery_shop/vendor/provider/vendor_provider.dart';
import 'package:multi_grocery_shop/views/screens/auth/customer_login_screen.dart';
import 'package:multi_grocery_shop/views/screens/main_screen.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp().whenComplete(() {
    print('completed');
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductProvder(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VendorProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the rootss of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Semi-Bold',
      ),
      home: MainScreen(),
      builder: EasyLoading.init(),
    );
  }
}
