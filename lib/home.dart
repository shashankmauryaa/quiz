import 'package:flutter/material.dart';
import 'package:quiz/teacheruploads.dart';
import 'studentprogress.dart';
import 'register.dart';
import 'main.dart';
import 'selectcourse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  static String id = "HomePage";

  final _key = GlobalKey<FormState>();

  String email='', password='', welcomeText = '', loggedInAs = '', loggingInAs = '';
  void changetoteacher(){
    welcomeText = 'Welcome Teacher';
    loggingInAs = 'Teacher';
  }
  void changetostudent(){
    welcomeText = 'Welcome Student';
    loggingInAs = 'Student';
  }
  void getRole() async {
    final role = await _firestore.collection('user').where('email',isEqualTo:email).get();
    for(var ro in role.docs){
      loggedInAs = ro.data()['role'];   // getting individual key
      // print(loggedInAs);
      currentRole = loggedInAs;
    }
  }

  bool state = false; // visibility

  @override
  void initState() {
    super.initState();
    getRole();
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
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(flex: 1,
                  child: Row(
                    children: <Widget>[
                      Expanded(child: TextButton(onPressed: (){setState(() {state=true; changetostudent();});},child: Image.asset('images/student.jpg'))),
                      Expanded(child: TextButton(onPressed: (){setState(() {state=true; changetoteacher();});},child: Image.asset('images/teacher.jpg')))
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
                            Text(welcomeText, style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight. w700)),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 10),
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                textAlign: TextAlign.center,
                                validator: (val){  if(val==null||val.isEmpty){return 'Please enter some text';}return null;},
                                onChanged: (val){setState(() {
                                  email = val;
                                });
                                  setState(() {
                                    currentUser = email;
                                  });
                                  },
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
                              padding: const EdgeInsets.only(top: 8.0),
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
                            Row(
                              children: <Widget>[
                                Text('  New user?', style: TextStyle(color: Colors.black, fontSize: 15,),),
                                TextButton(onPressed: (){if (_key.currentState!.validate()){ print(email); print(password);}
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RegisterPage()));
                                }, child: Text('SignUp', style: TextStyle(color: Colors.blueAccent, fontSize: 15,))),
                              ],
                            ),
                            Align(
                                alignment: Alignment.bottomRight,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_key.currentState!.validate()){
                                      setState(() {
                                        showSpinner = true;
                                      });
                                      getRole();
                                      // print(email);
                                      // print(password);
                                      try {
                                        final newUser = await _auth
                                            .signInWithEmailAndPassword(
                                            email: email, password: password);
                                        // print(loggedInAs);
                                        // print(loggingInAs);
                                        if(newUser!=null) {
                                          if(loggedInAs == loggingInAs) {
                                            if (loggedInAs == 'Student') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProgressPage()));
                                            } else
                                            if (loggedInAs == 'Teacher') {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                      TeacherPage()));
                                            }
                                          } else { // TODO: invalid credentials
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage()));
                                          }
                                        }
                                        setState(() {
                                          showSpinner = false;
                                        });
                                      }
                                      catch(e){
                                        print(e);
                                      }
                                    }
                                    //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProgressPage()));
                                    }, // onPressed
                                  child: Text(
                                    'LogIn',
                                    style: TextStyle(
                                        fontSize: 20.0
                                    ),
                                  ),
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