import 'package:bill_creator/models/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetScreen extends StatefulWidget {
  static const routeName = '/resetScreen';
  @override
  _ResetScreen createState() => _ResetScreen();
}

class _ResetScreen extends State<ResetScreen> {
  final _formKey = GlobalKey<FormState>();

  String? email;

  String? password;

  bool isLoading = false;

  void onSaved(BuildContext context) async {
    print('validating.......');
    final valid = _formKey.currentState!.validate();
    if (!valid) {
      return;
    }
    print('valid.......');
    setState(() {
      isLoading = true;
    });
    print('try login in.......');
    try {
      _formKey.currentState!.save();
      await Provider.of<Auth>(context, listen: false).resetRequest(email!);
      setState(() {
        isLoading = false;
      });
      showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                content: Text(
                  'A password reset link has send to your email,please check it',
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'ok',
                      ))
                ],
              ));
    } on FirebaseAuthException catch (error) {
      var message = 'Something went swrong!!';
      if (error.message != null) {
        message = error.message!;
      }
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ));
    } catch (eroor) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Something went swrong!!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mHeight = MediaQuery.of(context).size.height;
    // final manage = Provider.of<Auth>(context, listen: false);

    final con = context;
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Center(
          child: Card(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              height: mHeight * .3,
              width: mHeight * .385,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: mHeight * .007,
                      ),
                      Text(
                        'Enter mail Id ',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.teal,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: mHeight * .025,
                      ),
                      TextFormField(
                        key: ValueKey('email'),
                        validator: (val) {
                          if (!val!.contains('@') || val.isEmpty) {
                            return 'provide a valid email';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          email = val;
                        },
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      SizedBox(
                        height: mHeight * .04,
                      ),
                      isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.teal,
                                  onPrimary: Colors.white),
                              onPressed: () {
                                onSaved(con);
                              },
                              child: Text('Sent request')),
                      TextButton(
                          style: TextButton.styleFrom(
                            primary: Colors.teal,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Back to login')),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
