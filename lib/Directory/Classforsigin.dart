class FieldValidator {
  static String validateEmail(String value) {
    if (value.isEmpty) return 'Enter valid Email!';

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    }

    return null;
  }

  static String validatePassword(String value) {
    if (value.isEmpty) return 'Enter Password!';

    if (value.length < 8) {
      return 'Password should be of at least 8 characters';
    }
    return null;
  }
}