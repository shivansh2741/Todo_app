import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';


FirebaseAuth _firebase = FirebaseAuth.instance;

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController =TextEditingController();

  void addTasktoFirebase()async{
    var uid = await _firebase.currentUser!.uid;
    var time = DateTime.now();
    await FirebaseFirestore.instance.collection('tasks').doc(uid).collection('mytasks').doc(time.toString()).set({
      'title':_titleController.text,
      'description': _descriptionController.text,
      'time': time.toString(),
      'timestamp':time,
    });
    Fluttertoast.showToast(msg: 'Task Added');
    _titleController.clear();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add task'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                border: OutlineInputBorder(),
                label: Text('Enter Title...'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              autofocus: false,
              maxLines: 10,
              minLines: 1,
              controller: _descriptionController,
              decoration: const InputDecoration(
                fillColor: Colors.black38,
                filled: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.0, vertical: 0.0),
                border: OutlineInputBorder(),
                label: Text('Enter Description...'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.orangeAccent;
                      }
                      return Colors.orange; // Use the component's default.
                    },
                  ),
                ),
                onPressed: () {
                  addTasktoFirebase();
                },
                child: const Text(
                  'Add Task',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
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
