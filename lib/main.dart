import 'package:flutter/material.dart';
import 'package:quiz/selectsubject.dart';
import 'package:quiz/home.dart';
import 'package:quiz/register.dart';
import 'package:quiz/studentprogress.dart';
import 'package:quiz/quiz.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz/firebase_options.dart';
import 'package:quiz/selectcourse.dart';
import 'package:quiz/teacheruploads.dart';

String currentUser ='', currentRole ='', title = 'Q U I Z';
bool showSpinner = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Quiz_App());
}
//void main() =>  runApp(const Quiz_App());

class Quiz_App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'HomePage',
      routes: {
        'HomePage': (context) => HomePage(),
        'ProgressPage': (context) => ProgressPage(),
        'RegisterPage': (context) => RegisterPage(),
        'QuizPage': (context) => QuizPage(),
        'CourseSelect': (context) => SelectCourse(),
        'SubjectSelectStudent': (context) => SelectSubject(),
        'TeacherPage': (context) => TeacherPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}