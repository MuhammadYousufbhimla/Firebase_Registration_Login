import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;

  Future signup1() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);
      // ScaffoldMessenger.of(context).showSnackBar(

      //   SnackBar(content: Text("Sucessfully Register.You Can Login Now",style: TextStyle(color: Colors.black),),
      //          duration: Duration(seconds: 20),
      //   )
      // );
      //  Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightBlue,
        body: SafeArea(
            child: ListView(
          children: [
            videocard(context),
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.10,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                )),

            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.black,
                  labelText: 'Email',
                  errorText: _validate ? 'Email Can\'t Be Empty' : null,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                controller: password,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  labelText: 'Password',
                  errorText: _validate ? 'Password Can\'t Be Empty' : null,
                ),
              ),
            ),

            // Register and Cancel button
            Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05)),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Container(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    primary: Colors.grey,
                    minimumSize: Size(MediaQuery.of(context).size.height * 0.08,
                        MediaQuery.of(context).size.width * 0.07),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
              Container(
                height: 40,
                width: 100,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    primary: Color.fromARGB(255, 234, 100, 90),
                    minimumSize: Size(MediaQuery.of(context).size.height * 0.07,
                        MediaQuery.of(context).size.width * 0.07),
                  ),
                  onPressed: () {
                    setState(() {
                      email.text.isEmpty ? _validate = true : _validate = false;
                      password.text.isEmpty
                          ? _validate = true
                          : _validate = false;
                      signup1();
                      email.text = "";
                      password.text = "";
                    });
                  },
                  child: Text(
                    "Register",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
            ])
          ],
        )));
  }
}

Widget videocard(context) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.9,
    margin: EdgeInsets.only(
      top: MediaQuery.of(context).size.height * 0.01,
      bottom: MediaQuery.of(context).size.height * 0.01,
      left: MediaQuery.of(context).size.height * 0.02,
      right: MediaQuery.of(context).size.height * 0.02,
    ),
    padding: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.03),
    decoration: BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 5,
          blurRadius: 7,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          "My First Youtube video",
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
        ),
      ),
      Padding(padding: EdgeInsets.all(05)),
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.18,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.circular(08),
            //   image: DecorationImage(
            //   fit: BoxFit.fill,
            //   image: AssetImage("assets/L5.png"),
            // )
          ))
    ]),
  );
}
