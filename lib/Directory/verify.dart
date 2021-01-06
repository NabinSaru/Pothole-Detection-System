import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/GlobalVar.dart';
import 'package:new_project/Directory/signup.dart';
import 'package:new_project/Pages/maplocation.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final auth = FirebaseAuth.instance;
  FirebaseUser user;
  Timer timer;

  void makeServerconn() async{
    user = await auth.currentUser();
    user.sendEmailVerification();
  }

  @override
  void initState(){
    makeServerconn();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final theme = Theme.of(context);
      return Scaffold(
        appBar: AppBar(
          title: Text("Verify Email"),
          backgroundColor: theme.primaryColor,
        ),
        body: ListView(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            GlobalVar.isLoading?SpinKitPouringHourglass(color: Colors.white,size: 50.0,):SizedBox(
              height: 10,
            ),
            Center(
              child:Padding(
                padding:EdgeInsets.all(16.0),
                child: Text(
                  'An email has been sent to $email please verify your email.',textAlign: TextAlign.center,style: TextStyle(fontSize: 18),),
              ),
            ),
            Center(
              child:Padding(
                padding:EdgeInsets.all(16.0),
                child:RaisedButton(
                child: Text('Resend Email Verification'),
                onPressed: (){
                    GlobalVar.isLoading=true;
                    auth.createUserWithEmailAndPassword(email: email, password: password).then((_){
                      GlobalVar.isLoading=false;
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyScreen()));
                  });
                },
                padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 40),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                color: theme.buttonColor,
                ),
              ),
            ),
          ],
        ),
      );


  }

  Future<void> checkEmailVerified() async {
    user = await auth.currentUser();
    await user.reload();
    if (user.isEmailVerified) {
      GlobalVar.userLabel = user.email;
      timer.cancel();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyMap()));
    }
  }
}