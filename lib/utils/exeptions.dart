import 'package:firebase_auth/firebase_auth.dart';

String getAuthMessage(e) {
  if (e is FirebaseException) {
    switch (e.code) {
      case 'invalid-email':
        return 'Email is not valid or badly formatted.';
      case 'wrong-password':
        return 'Incorrect credentials please try again';
      default:
        return "Please Try again";
    }
  }
  return "Please Try again";
}
