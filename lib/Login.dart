import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login_register/Home.dart';
import 'package:login_register/Register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late String email;
  late String password;
  FirebaseAuth auth = FirebaseAuth.instance;

    Future Login(context) async {
      try {
        var user = await auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (user != null) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          print("Password invalid ");
        }
      } catch (e) {
        print(e);
      }
    }

    bool _validate = false;
       String date = "";
DateTime selectedDate = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.lightGreenAccent,
        appBar: AppBar(
          title: Text('Login'),
        ),
        body: SafeArea(
            child: ListView(
          children: [
            Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.10,
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 36,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold),
                )),

            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.03,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                onChanged: (value) {
                  email = value;
                },
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
        fillColor: Colors.white,
                  labelText: 'Email',
                  errorText: _validate ? 'Email Can\'t Be Empty' : null,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.02,
                  left: MediaQuery.of(context).size.width * 0.05,
                  right: MediaQuery.of(context).size.width * 0.05),
              child: TextField(
                onChanged: (value) {
                  password = value;
                },
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black),
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
                        MaterialPageRoute(builder: (context) => Register()));
                  },
                  child: Text(
                    "Register",
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
                    Login(context);
                  },
                  child: Text(
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                ),
              ),
            ])
          ],
        )));
  }

 

}


