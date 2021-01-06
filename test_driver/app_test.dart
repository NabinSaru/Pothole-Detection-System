import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group("Flutter Auth App Test", () {
    final signInNav = find.byValueKey("SignInButton");
    final emailField = find.byValueKey("email-field");
    final passwordField = find.byValueKey("password-field");
    final signInButton = find.text("Sign in");



    FlutterDriver driver;
    setUpAll(()async{
      driver = await FlutterDriver.connect();
    });

    tearDownAll(()async{
      if(driver != null) {
        driver.close();
      }
    });

    test("login fails with incorrect email and password, provides snackbar feedback",() async{
      await driver.tap(signInNav);
      await driver.tap(emailField);
      await driver.tap(emailField);
      await driver.enterText("test@testmail.com");
      await driver.tap(passwordField);
      await driver.enterText("testtest");
      await driver.tap(signInButton);


      await driver.waitUntilNoTransientCallbacks();

    });

    test("logs in with correct email and password",() async {
      await driver.tap(signInNav);
      await driver.tap(emailField);
      await driver.enterText("san@gmail.com");
      await driver.tap(passwordField);
      await driver.enterText("asdfghjkl");
      await driver.tap(signInButton);


      await driver.waitUntilNoTransientCallbacks();

    });




  });
}