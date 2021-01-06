import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_project/Directory/drawer.dart';
import 'package:new_project/GlobalVar.dart';

class CameraHome extends StatelessWidget {
  static const String routeName = '/connect';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pothole Registration',
      theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFFE8716D),
          primaryColor: Color(0xFF2E3E52),
          buttonColor: Color(0xFF6ADCC8),
          primaryColorDark: Color(0xFF7C8BA6)
//        primarySwatch: Colors.deepOrange,
      ),
      home: MyHomePage(title: 'Pothole Registration'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage ({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;
  LocationData _locationData;
  double long,lat;

  final String endPoint = 'http://78d17003656b.ngrok.io/pothole/';

  //this section expands push notification handler//
  String alertContent;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String status;

  @override
  initState() {
    super.initState();
    var initializationSettingsAndroid = AndroidInitializationSettings('mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future  showNotificationSuccessful() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Status About Sample',
      'Your sample was accepted.',
      platformChannelSpecifics,
      payload: 'accepted',
    );
  }

  Future  showNotificationFailed() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Status About Sample',
      'Your sample was rejected.',
      platformChannelSpecifics,
      payload: 'rejected',
    );
  }

  Future onSelectNotification(String payload) async {
    showDialog(context: context, builder: (context)=>CustomDialogBox(
      title: "SAMPLE STATUS",
      description: "Your sample submission was $payload.",
    ));
  }

  //End of notification handling.

  _currentLocation() async
  {
    Location location = new Location();

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print(_locationData);
    lat =  _locationData.latitude;
    long = _locationData.longitude;
    print(lat + long);
  }
  void responseHandler(String jsonResponse)
  {
    if(jsonResponse == "200"||jsonResponse =="200 OK"||jsonResponse=="201"||jsonResponse=="201 Created"||jsonResponse=="202"||jsonResponse=="202 Accepted")
    {
      alertContent = "Sent Successfully";
    }
    else if (jsonResponse==null)
    {
      alertContent = "Status Unknown";
    }
    else
    {
      alertContent = "Failed to send";
    }

    showDialog(context: context, builder: (context)=>CustomDialogBox(
      title: "STATUS",
      description: jsonResponse,
    ));
  }
  void _choose() async {
    File file;
    file = await ImagePicker.pickImage(
      source: ImageSource.camera,
      //source: ImageSource.gallery,
    );
    if (file != null) {
      _upload(file);
      setState(() {});
    }
  }
  void _firebaseCall(uid) async{
    try{
      var responseData = await Firestore.instance.collection("markerdetails").add(
          {
            'location': GeoPoint(lat,long),
            'creatorID': uid
          });
      showNotificationSuccessful();
      print(responseData);
    }
    catch(error){
      showNotificationFailed();
      print(error);
    }
  }
  void _upload(File file) async {
    if (file == null) return;
    _currentLocation();
    String fileName = file.path.split('/').last;
    print(fileName);
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var uid = user.uid;
    FormData data = FormData.fromMap({
      "pothole_file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "user_id":uid
      // "longitude" : long,
    });
    Dio dio = new Dio();
    GlobalVar.isLoading= true;
    try{
      await dio.post(endPoint, data: data).then((response) {
        GlobalVar.isLoading=false;
        Map <String, dynamic> jsonResponse =jsonDecode(response.toString());
        String status = "Result of submission: ${jsonResponse['status']}";

        String updateChk = "${jsonResponse['status']}";
        responseHandler(status);
        if(updateChk =="pothole has been detected")
        {
          _firebaseCall(uid);
        }

      }).catchError((error) {
        GlobalVar.isLoading=false;
        Map <String, dynamic> respo =jsonDecode(error);
        String status = "Result of submission: ${respo['status']}";
        print(error);
        responseHandler(status);
      });
    }
    catch(err){
      print(err);
      responseHandler("Something went wrong, try again later");
    }
    GlobalVar.isLoading=false;
    Navigator.push( context, MaterialPageRoute(builder:  (context)=>CameraHome()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GlobalVar.isLoading?SpinKitPouringHourglass(color: Colors.white,size: 50.0,):Text('Upload your sample...'),
          ],
        ),

      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 15.0,right:(MediaQuery.of(context).size.width*0.5 -45)),
        child: FloatingActionButton(
          onPressed: () async {
            _choose();
          },
          tooltip: 'Add a photo',
          child: Icon(Icons.add),
        ),
      ),
      endDrawer: AppDrawer(),
    );
  }
}
class CustomDialogBox extends StatelessWidget {
  final String title, buttonTxt, description;
  final Image image;
  CustomDialogBox({this.title,this.description,this.buttonTxt,this.image});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      backgroundColor: Colors.transparent,
      child:dialogContent(context),
    );}
  dialogContent(BuildContext context)
  {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              top: 100,
              bottom: 16,
              left: 16,
              right: 16
          ),
          margin: EdgeInsets.only(
              top: 16
          ),
          decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(17),
              boxShadow: [BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0,10.0)
              )]
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(title,style: TextStyle(fontSize: 24.0,fontWeight: FontWeight.w700,color: Colors.black),),
              SizedBox(height: 24),
              Text(description,style: TextStyle(fontSize: 16.0,color: Colors.black),),
              SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: FlatButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text("close",style: TextStyle(color: Colors.black),),),
              )
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 16,
          right: 16,
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            radius: 48,
            backgroundImage: AssetImage('assets/bell.gif'),
          ),
        )
      ],
    );

  }
}
