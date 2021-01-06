import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_project/Developers.dart';
import 'package:new_project/Directory/connection.dart';
import 'package:new_project/Directory/signin.dart';
import 'package:new_project/GlobalVar.dart';
import 'package:new_project/Pages/maplocation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_project/main.dart';

class AppDrawer extends StatelessWidget {
  var _email;
  Widget _createHeader() {
    print(GlobalVar.userLabel);
    if (GlobalVar.userLabel==null){
      _email="Pothole Detection System";
    }
    else _email=GlobalVar.userLabel;

    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image:  AssetImage('assets/menu.gif'))),
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child:Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children:[Icon(Icons.verified_user,color: Colors.red,
                    size: 24,),Text(" "+_email,
                  style: TextStyle(
                      color: Color(0xFF2E3E52),
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500))],))]));
  }

  Widget _createDrawerItem(
      {IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(text),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(),
          _createDrawerItem(icon: Icons.pin_drop, text: 'Go to potholes map',onTap: (){
              Navigator.push(context, MaterialPageRoute(builder:  (context)=>MyMap()));}),
          _createDrawerItem(icon: Icons.image, text: 'Upload Sample',onTap: ()
          {Navigator.push( context, MaterialPageRoute(builder:  (context)=>CameraHome()));}),

          Divider(color: Color(0xFF2E3E52),),
          _createDrawerItem(
              icon: Icons.collections_bookmark, text: 'About Developers',onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DeveloperInfo()));
          }),
          Divider(color: Color(0xFF2E3E52),),
          _createDrawerItem(
              icon: Icons.keyboard_tab, text: 'Log Out',onTap: () async {
            try{
              await FirebaseAuth.instance.signOut();
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyApp()));
            }
            catch(err){
              print(err);
            }
          }),

          Divider(color: Color(0xFF2E3E52),),
          _createDrawerItem(icon: Icons.exit_to_app, text: 'Close the program',
              onTap: ()
              {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }),
          ListTile(
            title: Text('Version 0.0.1'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}