import 'package:bill_creator/models/auth.dart';
import 'package:bill_creator/screens/auth_scree.dart';
import 'package:bill_creator/screens/report_screen.dart';
import 'package:bill_creator/screens/resest_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '/models/product_manage.dart';

import '/screens/order_details_screen.dart';
import '/screens/orders_scree.dart';
import '/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => ProductMange()),
        ChangeNotifierProvider(create: (ctx) => Auth()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Order Management',
        theme: ThemeData(primarySwatch: Colors.teal, accentColor: Colors.amber),
        routes: {
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          OrderDetailsScreen.routeName: (ctx) => OrderDetailsScreen(),
          ResetScreen.routeName: (ctx) => ResetScreen(),
          ReportScreen.routeName: (ctx) => ReportScreen(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snap) {
            if (snap.hasData) {
              return HomeScreen();
            }
            return AuthScreen();
          },
        ),
      ),
    );
  }
}
