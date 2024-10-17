import 'package:flutter/material.dart';
import 'package:quiz/selectsubject.dart';
import 'main.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

List globalCourse = [];
String c = '';

class SelectCourse extends StatefulWidget {
  const SelectCourse({Key? key}) : super(key: key);

  @override
  State<SelectCourse> createState() => _SelectCourseState();
}

class _SelectCourseState extends State<SelectCourse> {

  List<Icon> check = [];
  int num = 0, i = 0;
  List course = [];

  final _firestore = FirebaseFirestore.instance;
  String loggedInAs = '', email = '';

  void getStreamCourse() async {
    await for (var snapshot in _firestore.collection('courses').snapshots()) {  //this listens actively to changes
      for(var co in snapshot.docs){
        var map = co.data();
        course = map.values.toList();
        globalCourse = map.values.toList();
        print(course);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getStreamCourse();
  }

  Widget buildButtons() {
    return ListView.builder(
      itemCount: course.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
          onPressed: () {
            c = course[index];
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectSubject()));
          },
          child: Text(course[index]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(title)),
          backgroundColor: Colors.teal
      ),
      backgroundColor: Colors.white70,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded( flex: 1,
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextButton(
                //textColor: Colors.white,
                //color: Colors.green,
                child: Text(
                  'Click to get available Courses',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                  ),
                ),
                onPressed: () {
                  getStreamCourse();
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(flex: 5,
            child: buildButtons(),
          ),
        ],
      ),
    );
  }
}