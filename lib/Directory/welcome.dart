import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_project/Directory/signin.dart';
import 'package:new_project/Directory/signup.dart';
import 'package:new_project/Pages/maplocation.dart';


class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Pothole Detection System'),
      ),
      body:
          Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,

                  children: <Widget>[
                    SizedBox(
                      height: 32,
                    ),
                    Image(
                      image:AssetImage('assets/iii.png') ,
                      height: 250,
                      width: 250,
                      alignment: Alignment.center,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8,horizontal: 80),
                      child:RaisedButton(
                        child: Text('SIGN IN'),
                        onPressed: SignInNav,
                        padding: const EdgeInsets.symmetric(vertical: 12.0,horizontal: 40),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                        color: theme.buttonColor,
                      ),),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 80),
                      child: RaisedButton(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: theme.buttonColor,
                            child: SizedBox(width: 240,child:Text('SIGN UP',textAlign: TextAlign.center,)),
                            onPressed: SignUpNav,
                          ),
                    )],
                    ),
                );

  }
  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        if(user.isEmailVerified){
          print(user.email);
          Navigator.push(context,MaterialPageRoute(builder: (context)=>MyMap()));
        }
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }
  void SignInNav(){
    Navigator.push(context,MaterialPageRoute(builder:(context)=>LoginPage(),fullscreenDialog: true));
  }

  void SignUpNav(){
    Navigator.push(context,MaterialPageRoute(builder:(context)=>SignupPage(),fullscreenDialog: true));
  }
}
