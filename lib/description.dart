import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


var _firebaseauth = FirebaseAuth.instance;
var _firestore = FirebaseFirestore.instance;

String? uid = _firebaseauth.currentUser?.uid;
var document = _firestore.collection('tasks').doc(uid).collection('mytasks');

class Description extends StatelessWidget {

  late String title;
  late String description;

  Description({required this.title,required this.description});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'Description',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 40.0,),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
            title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40.0,horizontal: 40.0),
              margin: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 0.0),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(9.0),
              ),
              child: Text(
                description,
              ),
            )
          ],
        ),
      ),
    );
  }
}



