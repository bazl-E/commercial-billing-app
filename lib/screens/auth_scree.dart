import 'package:bill_creator/models/auth.dart';
import 'package:bill_creator/screens/resest_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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
      await Provider.of<Auth>(context, listen: false).login(email!, password!);

      isLoading = false;
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
              height: mHeight * .4,
              width: mHeight * .385,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: mHeight * .025,
                      ),
                      Text(
                        'Login To Get Access',
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
                      TextFormField(
                        key: ValueKey('password'),
                        obscureText: true,
                        validator: (val) {
                          if (val!.length < 7 || val.isEmpty) {
                            return 'provide atleast 7 charectors';
                          }

                          return null;
                        },
                        onSaved: (val) {
                          password = val;
                        },
                        decoration: InputDecoration(
                          labelText: 'Password',
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
                                FocusScope.of(context).unfocus();
                                onSaved(con);
                              },
                              child: Text('Get access')),
                      TextButton(
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            Navigator.of(context)
                                .pushNamed(ResetScreen.routeName);

                            // await manage.resetRequest(email!);
                          },
                          child: Text(
                            'Forgot password?',
                            style:
                                TextStyle(decoration: TextDecoration.underline),
                          ))
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
