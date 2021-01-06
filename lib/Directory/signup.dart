import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_project/Directory/passwordStrength.dart';
import 'package:new_project/Directory/signin.dart';
import 'package:new_project/Directory/PasswordStrengthGUI.dart';
import 'package:new_project/Directory/verify.dart';
import 'package:new_project/GlobalVar.dart';

bool _isHidden = true;
String email,password;
class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  Container buildTitle(ThemeData theme) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.bottomCenter,
      child: Text('SIGNUP',style: TextStyle(fontSize: 18,color: theme.primaryColorDark),
      ),
    );
  }
  final auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void _toggleVisibility(){
      setState(() {
        _isHidden = !(_isHidden);
      });
    }
    return Scaffold(

        appBar: AppBar(
          title: Text("Pothole Detection System"),
        ),
        body: Form(
          key: _formkey,
          child:ListView(
            padding: const EdgeInsets.fromLTRB(16.0,kToolbarHeight,16.0,16.0),
            children: <Widget>[
              Align(
                child:SizedBox(
                    width: 320.0,
                    child:Card(
                      color: theme.primaryColor,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          buildTitle(theme),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: TextFormField(
                              validator: (input){
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(input))
                                  return 'Enter Valid Email';
                                else
                                  return null;
                              },
                              onChanged: (input){
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(input))
                                  return 'Enter Valid Email';
                                else
                                  return null;
                              },
                              onSaved: (input){
                                email=input;
                                },
                              decoration: InputDecoration(
                                labelText: 'Email',
                                hintText: 'your@email.com',
                                hintStyle: TextStyle(color: theme.primaryColorDark),
                                prefixIcon: Icon(Icons.email,size: 20,),
                              ),
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: TextFormField(
                              validator: (input){
                                if (input.length<8)
                                  return 'Password should be of at least 8 characters';
                                else if(estimatePasswordStrength(input)<0.8)
                                  return 'Enter strong password';
                                else
                                  return null;
                              },
                              onChanged: (String value) {
                                setState(() {
                                  password = value.trim();
                                });
                              },
                              onSaved: (input)=>setState(() {
                                password = input.trim();
                              }),

                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Password',
                                hintStyle: TextStyle(color: theme.primaryColorDark),
                                prefixIcon: Icon(Icons.lock,size: 20,),
                                suffixIcon: IconButton(
                                  iconSize: 16,
                                  onPressed: _toggleVisibility,
                                  icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                ),
                              ),
                              obscureText: _isHidden

                            ),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                          SizedBox(
                            width: 270,
                            child: FlutterPasswordStrength(
                                password: password,
                                strengthCallback: (strength){
                                  debugPrint(strength.toString());
                                }
                            ),
                          ),

                          SizedBox(
                            height: 18.0,
                          ),
                          Builder(builder: (context)=>RaisedButton(
                            onPressed: () async {
                              final formState=_formkey.currentState;
                              if(_formkey.currentState.validate()){
                                //TODO Login in firebase
                                formState.save();
                                try{
                                  GlobalVar.userLabel=email;
                                  auth.createUserWithEmailAndPassword(email: email, password: password).then((_){
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => VerifyScreen()));
                                  });
                                  // AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(email:_email,password:_password);
                                  // FirebaseUser user = result.user;
                                  // user.sendEmailVerification();
                                  // Navigator.of(context).pop();
                                  // Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>LoginPage()));
                                }
                                catch(error){
                                  print(error.message);
                                  String Notify;
                                  if(error.message=="The email address is already in use by another account.") {
                                    Notify =
                                    "This email is already registered";
                                  }
                                  else {
                                    Notify="Something went wrong.";
                                  }
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(Notify,textAlign: TextAlign.center,),
                                    duration: Duration(seconds: 3),
                                    backgroundColor: Color(0xFF7C8BA6),
                                  ));
                                }
                              }},
                            child: Text('Sign Up'),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: theme.buttonColor,
                          ),) ,
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('By Signing up you agree with our terms and conditions.'
                              ,style: TextStyle(color: theme.primaryColorDark,),textAlign: TextAlign.center,),
                          ),
                          SizedBox(
                            height: 18.0,
                          ),
                        ],
                      ),
                    )
                ),
              ),

            ],

          ),
        )
    );
  }
}