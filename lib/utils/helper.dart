library password_manager.globals;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

String baseUrl = 'https://paman-api.herokuapp.com/api/v1';

showSnackbar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

customPushReplaceNavigator(BuildContext context, Widget destination) {
  return Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => destination));
}

customPushRemoveNavigator(BuildContext context, Widget destination) {
  return Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => destination), (route) => false);
}

customPushOnlyNavigator(BuildContext context, Widget destination) {
  return Navigator.push(
      context, MaterialPageRoute(builder: (context) => destination));
}

copyData(BuildContext context, String data, String label) {
  Clipboard.setData(ClipboardData(text: data)).then((value) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$label berhasil di copy'))));
}

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          CircularProgressIndicator(),
          Text("Menghapus data...")
        ]),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      });
}
