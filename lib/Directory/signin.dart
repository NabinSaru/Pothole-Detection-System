import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_project/Directory/forgetEmail.dart';
import 'package:new_project/GlobalVar.dart';
import 'package:new_project/Pages/maplocation.dart';
import 'package:new_project/main.dart';

bool _isHidden = true;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;
FirebaseUser user;

class _LoginPageState extends State<LoginPage> {
  Container buildTitle(ThemeData theme) {
    return Container(
      height: 60.0,
      padding: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.bottomCenter,
      child: Text('SIGNIN',style: TextStyle(fontSize: 18,color: theme.primaryColorDark),
      ),
    );
  }
  String email,_password;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
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
                              key:Key('email-field'),
                              validator: (input){
                                Pattern pattern =
                                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                RegExp regex = new RegExp(pattern);
                                if (!regex.hasMatch(input))
                                  return 'Enter Valid Email';
                                else
                                  return null;
                              },
                              onSaved: (input)=>email=input,
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
                              key:Key('password-field'),
                              validator: (input){
                                if (input.length<8)
                                  return 'Password should be of at least 8 characters';
                                else
                                  return null;
                              },
                              onSaved: (input)=>_password=input,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: '',
                                hintStyle: TextStyle(color: theme.primaryColorDark),
                                  prefixIcon: Icon(Icons.lock,size: 20,),
                                  suffixIcon: IconButton(
                                    iconSize: 16,
                                    onPressed: _toggleVisibility,
                                    icon: _isHidden ? Icon(Icons.visibility_off) : Icon(Icons.visibility),
                                  )
                              ),
                                obscureText: _isHidden,

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
                                  AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: _password);
                                  user = result.user;
                                  if(user.isEmailVerified){
                                  GlobalVar.userLabel = user.email;
                                  Navigator.push(context,MaterialPageRoute(builder: (context)=>MyMap()));
                                  }
                                  else{
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text("user not verified",textAlign: TextAlign.center,),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Color(0xFF7C8BA6),
                                    ));
                                  }

                                }
                                catch(error){
                                  print(error.message);
                                  String Notify;
                                  if(error.message=="There is no user record corresponding to this identifier. The user may have been deleted."){
                                    Notify = "User not found, please check your credentials";
                                  }
                                  else if(error.message=="The password is invalid or the user does not have a password."){
                                    Notify = "Email and Password don't match, please check your credentials";
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
                            child: Text('Sign In'),
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            color: theme.buttonColor,
                          ),) ,
                          // SizedBox(

                          SizedBox(
                            height: 18.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FlatButton(
                                child: Text('Forgot Password?'),
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(builder: (context) => ResetScreen()),
                                ),
                              )
                            ],
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

  @override
  void initState() {
    super.initState();
    getUser().then((user) {
      if (user != null) {
        if(user.isEmailVerified){
          GlobalVar.userLabel = user.email;
          Navigator.push(context,MaterialPageRoute(builder: (context)=>MyMap()));
        }
      }
    });
  }

  Future<FirebaseUser> getUser() async {
    return await _auth.currentUser();
  }

}
