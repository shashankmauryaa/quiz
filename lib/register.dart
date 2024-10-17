import 'package:flutter/material.dart';
import 'home.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  List subs = [], lvl = [];

  late User loggedInUser;

  @override
  initState(){
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async{
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        // print(loggedInUser.email);
      }
    }
    catch(e){
      print(e);
    }
  }

  static String id = "HomePage";

  final _key = GlobalKey<FormState>();

  String email='', password='', welcomeText = '', loggingInAs = '';
  void changetoteacher(){
    welcomeText = 'Welcome Teacher';
    loggingInAs = 'Teacher';
  }
  void changetostudent(){
    welcomeText = 'Welcome Student';
    loggingInAs = 'Student';
  }
  bool state = false; //visibility

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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: TextButton(
                          onPressed: (){
                            setState(() {
                              state=true;
                              changetostudent();
                            });
                            },
                          child: Image.asset('images/student.jpg')
                      )),
                      Expanded(child: TextButton(
                          onPressed: (){
                            setState(() {
                              state=true;
                              changetoteacher();
                            });
                            },
                          child: Image.asset('images/teacher.jpg')
                      )),
                    ],
                  ),
                ),
                Expanded(flex: 2,
                    child: Visibility(visible: state,
                      child: Form(
                        key: _key,
                        child: Column(
                          children: <Widget>[
                            Padding(padding: const EdgeInsets.only(top: 10.0)),
                            Text(welcomeText, style: TextStyle(color: Colors.tealAccent, fontSize: 25),),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 8),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                validator: (val){  if(val==null||val.isEmpty){return 'Please enter some text';}return null;},
                                onChanged: (val){  setState(() => email = val);},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter username',
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
                              padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                              child: TextFormField(
                                obscureText: true,
                                textAlign: TextAlign.center,
                                validator: (val){  if(val==null||val.isEmpty){return 'Please enter some text';}return null;},
                                onChanged: (val){setState(() => password = val);},
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Enter password',
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
                            Align(
                              alignment: Alignment.bottomRight,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_key.currentState!.validate()){
                                    setState(() {
                                      showSpinner = true;
                                    });
                                    // print(email);
                                    // print(password);
                                    try {
                                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                                      _firestore.collection('user').add({'email' : email, 'role' : loggingInAs, 'subjects': subs, 'level': lvl});
                                      // print(loggingInAs);
                                      if(newUser!=null){
                                        if (loggingInAs == 'Student') {
                                          Navigator.pushNamed(context, 'CourseSelect');
                                        } else if (loggingInAs == 'Teacher') {
                                          Navigator.pushNamed(context, 'CourseSelect');
                                        }
                                      }
                                      setState(() {
                                        showSpinner = false;
                                        currentUser = email;
                                        currentRole = loggingInAs;
                                      });
                                    }
                                    catch(e){
                                      print(e);
                                    }
                                  }
                                  //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProgressPage()));
                                }, // onPressed
                                child: Text(
                                  'SignUp',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                  ),
                                ),/*color: Colors.blueAccent,textColor: Colors.white,*/
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}