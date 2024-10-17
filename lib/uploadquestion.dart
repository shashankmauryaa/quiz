import 'package:flutter/material.dart';
import 'main.dart';
import 'teacheruploads.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UploadQuestion extends StatefulWidget {
  const UploadQuestion({Key? key}) : super(key: key);

  @override
  State<UploadQuestion> createState() => _UploadQuestionState();
}

class _UploadQuestionState extends State<UploadQuestion> {
  final _formKey = GlobalKey<FormState>();
  String _question = '', _answer = '', option1 = '', option2 = '', option3 = '';

  final _firestore = FirebaseFirestore.instance;

  void handleSubmit() async {
    //print(selectedSubject);
    try {
      var x = await _firestore.collection(selectedSubject).get();
      _firestore.collection(selectedSubject).add({'Question' : _question, 'Answer' : _answer, 'Option1': option1, 'Option2': option2, 'Option3' : option3})
          .then((value) {
            print("Question uploaded successfully.");
          }).catchError((error) {
            print("Failed to upload question: $error");
          });
    }
    catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text(title)),
          backgroundColor: Colors.teal
      ),
      backgroundColor: Colors.white70,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  validator: (val){  if(val==null||val.isEmpty){return 'Please enter a question';}return null;},
                  onChanged: (val){setState(() {
                    _question = val;
                  });
                  setState(() { });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Question',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  validator: (val){  if(val==null||val.isEmpty){return 'Please enter an answer';}return null;},
                  onChanged: (val){setState(() {
                    _answer = val;
                  });
                  setState(() { });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Answer',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  validator: (val){  if(val==null||val.isEmpty){return 'Please enter an incorrect answer 1';}return null;},
                  onChanged: (val){setState(() {
                    option1 = val;
                  });
                  setState(() { });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Incorrect Answer 1',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  validator: (val){  if(val==null||val.isEmpty){return 'Please enter an incorrect answer 2';}return null;},
                  onChanged: (val){setState(() {
                    option2 = val;
                  });
                  setState(() { });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Incorrect Answer 2',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextFormField(
                  textAlign: TextAlign.left,
                  validator: (val){  if(val==null||val.isEmpty){return 'Please enter an incorrect answer 3';}return null;},
                  onChanged: (val){setState(() {
                    option3 = val;
                  });
                  setState(() { });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Incorrect Answer 3',
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                      //print('Question: $_question');
                      //print('Answer: $_answer');
                      //print('Option1: $option1');
                      //print('Option2: $option2');
                      //print('Option3: $option3');
                      handleSubmit();
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TeacherPage()));
                  },
                  child: Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}