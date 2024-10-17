import 'package:flutter/material.dart';
import 'package:quiz/uploadquestion.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

String selectedSubject = '';

class TeacherPage extends StatefulWidget {
  const TeacherPage({Key? key}) : super(key: key);

  @override
  State<TeacherPage> createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  int indx = 0;
  List subjects = [], levels = [];

  void getsubslvl() async {
    final role = await _firestore.collection('user').where('email',isEqualTo:currentUser).get();
    for(var ro in role.docs){
      subjects = ro.data()['subjects'];
      levels = ro.data()['level'];
      // print(subjects);
      // print(levels);
    }
  }

  @override
  void initState() {
    super.initState();
    getsubslvl();
    buildTable();
  }

  Widget buildTable() {
    final List<DataColumn> columns = [
      DataColumn(label: Text('Subject')),
      DataColumn(label: Text('Level')),
      DataColumn(label: Text('Action')),
    ];
    final List<DataRow> rows = subjects.asMap().entries.map((entry) {
      final index = entry.key;
      final subject = entry.value;
      final level = levels[index];
      return DataRow(cells: [
        DataCell(Text(subject)),
        DataCell(Text(level)),
        DataCell(
          ElevatedButton(
            onPressed: () {
              setState(() {
                showSpinner = true;
              });
              selectedSubject = subject;
              // print(selectedSubject);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => UploadQuestion()));
              setState(() {
                showSpinner = false;
              });
            },
            child: Text('Upload Question'),
          ),
        ),
      ]);
    }).toList();
    return DataTable(columns: columns, rows: rows);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(title: Center(child: Text(title)),
            backgroundColor: Colors.teal
        ),
        backgroundColor: Colors.white70,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Welcome
              Expanded(flex:1,child: Align(alignment: Alignment.bottomCenter,child: Column(
                children: [
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Text(
                    'WELCOME ',
                    style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 30,
                        fontWeight: FontWeight. w700
                    ),
                  ),
                  Text(
                    currentUser,
                    style: TextStyle(
                        color: Colors.tealAccent,
                        fontSize: 25
                    ),
                  )
                ],
              )
              )),
              // Display Current Levels
              Expanded(flex:4, child: buildTable()),
              // Logout and Refresh
              Expanded(flex:1,child: Align(alignment: Alignment.bottomCenter, child: Column(
                children: [
                  ElevatedButton(onPressed: () {
                    getsubslvl();
                    setState(() {
                      buildTable();
                    });
                  },
                    child: Text('Refresh', style: TextStyle(fontSize: 19.0), ),//color: Colors.blueAccent,textColor: Colors.white
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pop(context);
                    },
                    child: Text('Logout', style: TextStyle(fontSize: 20.0), ),//color: Colors.blueAccent,textColor: Colors.white
                  ),
                ],
              ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}