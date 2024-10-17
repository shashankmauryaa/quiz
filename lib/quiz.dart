import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String question;
  final List<String> options;
  Question(this.question, this.options);
}

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {

  final _firestore = FirebaseFirestore.instance;

  List<Question> questions = [];
  Random random = Random();
  String Q = '';
  List<String> O = [];

  @override
  void initState() {
    super.initState();
    getDocuments();
  }

  List<Icon> check = [];
  int num = 0;

  void getDocuments() async {
    final ques = await _firestore.collection('Operating Systems').get();
    for(var v in ques.docs){
      String question = v.data()['Question'];
      List<String> options = [
        v.data()['Option1'],
        v.data()['Option2'],
        v.data()['Option3'],
        v.data()['Answer']
      ];
      questions.add(Question(question, options));
      // print(v.data()['Question']);
      // print(question);
      // print(options);
    }
    //print(questions);
    Question randomQuestion = questions[random.nextInt(questions.length)];
    Q = randomQuestion.question; // display the random question
    O = randomQuestion.options;

  }
  // this works too
  void getDocuments2() {
    FirebaseFirestore.instance.collection('Operating Systems').get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc.data()); // display the data in each document
      });
    });
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
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Text(
                  Q,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),


          Row(
            children: check,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(15.0),
              child: TextButton(
                //color: Colors.red,
                child: Text(
                  'getdocs',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  getDocuments();
                  setState(() { });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}