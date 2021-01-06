import 'package:new_project/Directory/Classforsigin.dart';
 import 'package:test/test.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

void main() {
  var path = "http://78d17003656b.ngrok.io/pothole/";
  test('Empty Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter valid Email!');
  });

  test('Invalid Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter valid Email!');
  });

  test('Valid Email Test', () {
    var result = FieldValidator.validateEmail('sandeshadhikari92@gmail.com');
    expect(result, null);
  });

  test('Empty Password Test', () {
    var result = FieldValidator.validatePassword('');
    expect(result, 'Enter Password!');
  });

  test('Invalid Password Test', () {
    var result = FieldValidator.validatePassword('123');
    expect(result, 'Password should be of at least 8 characters');
  });

  test('Valid Password Test', () {
    var result = FieldValidator.validatePassword('password123');
    expect(result, null);
  });

  //Image file with no pothole --> 200 ok status
 test('file send',() async {
    var dio = Dio();
    var formData =  FormData.fromMap({

      "pothole_file": await MultipartFile.fromFile("assets/nabin.png",filename: "nabin.png"),
      "user_id":"asdasd12s",

    });
    Response response = await dio.post(path, data: formData);
    var result = response.statusMessage;
    expect(result, 'OK');
  });

 //Image file with pothole image
  test('file and Image send',() async {
    var dio = Dio();
    var formData =  FormData.fromMap({
      "pothole_file": await MultipartFile.fromFile("assets/pothole.jpg",filename: "pothole.jpg"),
      "user_id":"asdasd12s",
    });
    Response response = await dio.post(path, data: formData);
    var result = response.statusMessage;
    expect(result, 'Created');
  });

  //File other than image (eg .txt) -=>> 400 Bad Request
  test('Different file',() async {
    String status;
    var dio = Dio();
    var formData =  FormData.fromMap({

      "pothole_file": await MultipartFile.fromFile("assets/sandesh.txt",filename: "sandesh.txt"),
      "user_id":"asdasd12s",

    });
      await dio.post(path, data: formData).then((response){

      Map <String, dynamic> jsonResponse =jsonDecode(response.toString());
      String status = "Result of submission: ${jsonResponse['status']}";

        }).catchError((error) {
          status=error.toString();
      print(status);
  });
      expect(status,'DioError [DioErrorType.RESPONSE]: Http status error [400]');
});

  test('file pdf',() async {
    var dio = Dio();
    Response response;
    dio.options.headers['content-Type'] = 'application/json';
    var data = jsonEncode(<String,String>{
      'test':'test'
    });
    var formData =  new FormData.fromMap({
      "file": await MultipartFile.fromFile("assets/NSE_2_Certificate.pdf",filename: "NSE_2_Certificate.pdf"),
    });
    try{
    response = await dio.post(path, data:formData,onSendProgress:(int sent,int total){
      print("$sent $total");
    });
    } on DioError catch (e) {
      print(e.response.data);
      print(e.response.headers);
      print(e.response.request);
    }
    var result = response.statusMessage;

    expect(result, 'Created');
  });

}
