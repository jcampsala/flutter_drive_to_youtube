import 'package:flutter/material.dart';

void showFullPath(String path, BuildContext context) {
  final snackBar = SnackBar(content: Text(path), duration: Duration(seconds: 2),);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}