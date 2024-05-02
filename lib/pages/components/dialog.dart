import 'package:flutter/material.dart';

void showMessageDialog({required BuildContext context, required String? message}) {
  showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: AlertDialog(
              actionsAlignment: MainAxisAlignment.end,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: const Text('Close')),
              ],
              title: Text('$message'),
            ));
      });
}

void _showErrorDialog(BuildContext context, String error) {
  String message;
  switch (error) {
    case 'weak-password':
      message = 'Please choose a stronger password.';
      break;
    case 'email-already-in-use':
      message = 'An account already exists with this email address.';
      break;
    case 'invalid-email':
      message = 'Invalid email, please check your email and try again.';
      break;
    case 'too-many-requests':
      message = 'A problem occurred, Please try again later.';
      break;
    default:
      message = 'Sorry, something went wrong.';
  }
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
void showProgressionDialog({required BuildContext context}) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      });
}
