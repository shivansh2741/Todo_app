import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/authorize/auth_screen.dart';
import 'add_todo.dart';
import 'description.dart';

FirebaseAuth _firebase = FirebaseAuth.instance;
String uid = '';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    setState(() {
      uid = _firebase.currentUser!.uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return const AuthScreen();
              },),);
            },
          ),
        ],

        backgroundColor: Colors.orangeAccent,
        title: const Text(
          'TODO',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 0.0,),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('tasks')
                .doc(uid)
                .collection('mytasks')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              final document = snapshot.data!.docs;

              if (document.isNotEmpty) {
                return ListView.builder(
                  itemCount: document.length,
                  itemBuilder: (context, index) {
                    var time =document[index]['timestamp'];
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                            return Description(title: document[index]['title'],
                            description: document[index]['description'],);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 30.0,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(9.0),
                          ),
                          alignment: Alignment.center,
                          height: 80.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      document[index]['title'],
                                      style: GoogleFonts.roboto(),
                                    ),
                                    Container(
                                      child: Text(DateFormat.yMd().add_jm().format(time.toDate()),
                                      style: const TextStyle(
                                        color: Colors.white30,
                                      ),),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('tasks')
                                          .doc(uid)
                                          .collection('mytasks')
                                          .doc(document[index]['time'])
                                          .delete();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No Tasks currently',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w300,
                      fontSize: 20.0,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return const AddTask();
          }));
        },
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
