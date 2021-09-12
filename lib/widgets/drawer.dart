// import 'package:bill_creator/models/auth.dart';
import 'package:bill_creator/screens/report_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '/screens/orders_scree.dart';

class SideDrawer extends StatelessWidget {
  const SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    // final manage = Provider.of<Auth>(context, listen: false);
    return Drawer(
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            height: mHeight * .3,
            width: double.infinity,
            decoration: const BoxDecoration(color: Colors.teal),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Surya IND',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: Colors.white),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: const Icon(Icons.collections_bookmark),
            title: const Text('View Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(OrdersScreen.routeName, arguments: 'order');
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.done_all),
            title: const Text('Finished Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(OrdersScreen.routeName, arguments: 'finished');
            },
          ),
          // const SizedBox(height: 5),
          // ListTile(
          //   leading: const Icon(Icons.restore),
          //   title: const Text('Reset password'),
          //   onTap: () async {
          //     if (FirebaseAuth.instance.currentUser!.email == null) {
          //       return;
          //     }
          //     await manage
          //         .resetRequest(FirebaseAuth.instance.currentUser!.email!);
          //     showDialog(
          //         context: context,
          //         builder: (ctx) => AlertDialog(
          //               content: Text(
          //                 'A password reset link has send to your email,please check it',
          //               ),
          //               actions: [
          //                 TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                     child: Text('ok'))
          //               ],
          //             ));
          //   },
          // ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.bookmarks),
            title: const Text('Report'),
            onTap: () {
              Navigator.of(context).pushNamed(ReportScreen.routeName);
            },
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
