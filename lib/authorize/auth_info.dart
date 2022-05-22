import 'dart:typed_data';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/home.dart';
import 'package:flutter_loadingindicator/flutter_loadingindicator.dart';

var _firestore = FirebaseFirestore.instance;
var _fireauth = FirebaseAuth.instance;

class AuthInfo extends StatefulWidget {

  @override
  State<AuthInfo> createState() => _AuthInfoState();
}

class _AuthInfoState extends State<AuthInfo> {
  final _formkey = GlobalKey<FormState>();

  late String _email;
  late String _password;
  String _username='' ;
  bool isLogin = false;

  String? uid;

  void startAuthentication() async {
    final validity = _formkey.currentState!.validate();
    if (validity) {

      _formkey.currentState!.save();
      _formkey.currentState!.reset();

      if(_username.isEmpty) {
        submitForm( '', _email, _password);
      }
      else{
        submitForm( _username, _email, _password);
      }
    }
  }

  void submitForm(String username, String email, String password) async {
    try {
      if (isLogin) {
        await _fireauth.signInWithEmailAndPassword(
            email: email, password: password);
        uid = FirebaseAuth.instance.currentUser!.uid;
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Home();
        }));
        EasyLoading.dismiss();
      } else {
        await _fireauth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((userData) async {
          uid =  userData.user!.uid;
        });

        await _firestore.collection('users').doc(uid).set({
          'username': _username,
          'email': _email,
          'password': _password,
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const Home();
        }));
        EasyLoading.dismiss();

      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 8.0),
          children: [
            Container(
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!isLogin)
                        TextFormField(
                          autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          key: const ValueKey('Username'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Username Field is empty';
                            } else {
                              return null;
                            }
                          },
                          onSaved: (valueKey) {
                            _username = valueKey!;
                          },
                          decoration: const InputDecoration(
                            // labelText: 'email',
                            labelStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            hintText: 'Username',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(9.0),
                              ),
                              borderSide: BorderSide(),
                            ),
                          ),
                        ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        autofocus: true,
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('Email'),
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'Incorrect Email';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (valueKey) {
                          _email = valueKey!;
                        },
                        decoration: const InputDecoration(
                          // labelText: 'email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          hintText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(9.0),
                            ),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: const ValueKey('Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty || value.length <= 5) {
                            return 'Password must be atleast 6 character long';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (valueKey) {
                          _password = valueKey!;
                        },
                        decoration: const InputDecoration(
                          // labelText: 'email',
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                          hintText: 'Password',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(9.0),
                            ),
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Material(
                        color: Colors.orange,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9.0)),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          child: Text(
                            isLogin ? 'Login' : 'Register',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed:() {
                            EasyLoading.show(status: 'loading...');
                            startAuthentication();
                          }
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !isLogin
                                ? TextButton(
                                    child:
                                        const Text('Already have an account?'),
                                    onPressed: () {
                                      setState(() {
                                        isLogin = true;
                                      });
                                    },
                                  )
                                : TextButton(
                                    child:
                                        const Text('Don\'t have an account?'),
                                    onPressed: () {
                                      setState(() {
                                        isLogin = false;
                                      });
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
