import 'package:flutter/material.dart';
import 'main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'selectcourse.dart';

class SelectSubject extends StatefulWidget {
  const SelectSubject({Key? key}) : super(key: key);

  @override
  State<SelectSubject> createState() => _SelectSubjectState();
}

class _SelectSubjectState extends State<SelectSubject> {
  List<Icon> check = [];
  int num = 0, i = 0, inx = 0;
  List<String> subject = [];
  List<bool> checked = [];

  final _firestore = FirebaseFirestore.instance;
  String loggedInAs = '', email = '';

  void getStreamSubjects() async {
    await for (var snapshot in _firestore.collection(c).snapshots()) {
      // print(c);
      for (var su in snapshot.docs) {
        var map = su.data();
        subject = map.values.toList().cast<String>(); // cast to List<String>
        checked = List.filled(subject.length, false); // initialize checked list
        // print(map);
        // print(subject);
        // print(checked);
      }
    }
  }

  Widget buildCheck() {
    return ListView.builder(
      itemCount: subject.length,
      itemBuilder: (context, inx) {
        return CheckboxListTile(
          title: Text(subject[inx], style: TextStyle(color: Colors.black),),
          value: checked[inx],
          onChanged: (value) {
            setState(() {
              checked[inx] = value!;
              print(checked);
            });
          },
        );
      },
    );
  }

  void handleSubmit() async {
    List<String> selectedSubjects = [], level = [];
    for (int i = 0; i < checked.length; i++) {
      if (checked[i]) {
        selectedSubjects.add(subject[i]);
        level.add('Begineer');
      }
    }
    print(selectedSubjects);
    try {
      var x = await _firestore.collection('user').where('email', isEqualTo: currentUser).get();
      // print(currentUser);
      String documentId = x.docs.first.id;
      // print(documentId);
      CollectionReference collectionRef = FirebaseFirestore.instance.collection('user');  // Get a reference to the collection
      DocumentReference documentRef = collectionRef.doc(documentId);    // Use the document ID to update the document
      documentRef.update({
        'subjects': selectedSubjects,
        'level': level,
      }).then((value) {
        print("Document updated successfully.");
      }).catchError((error) {
        print("Failed to update document: $error");
      });
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(title)),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white70,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextButton(
                child: Text(
                  'Click to get available Subjects',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  getStreamSubjects();
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: buildCheck(),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: ElevatedButton(
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  handleSubmit();
                  if (currentRole == 'Student') {
                    Navigator.pushNamed(context, 'ProgressPage');
                  } else if (currentRole == 'Teacher') {
                    Navigator.pushNamed(context, 'TeacherPage');
                  }
                  setState(() {});
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

