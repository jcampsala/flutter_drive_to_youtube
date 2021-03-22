import 'package:flutter/material.dart';
import 'models/video_file.dart';

enum Process { uploading, downloading, idle }

void showFullPath(String path, BuildContext context) {
  final snackBar = SnackBar(content: Text(path), duration: Duration(seconds: 2),);
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

List<VideoFile> getSelectedVideoFiles(List<String> ids, List<VideoFile> vFiles) {
  List<VideoFile> selected = [];
  for(String id in ids) {
    selected.add(vFiles.firstWhere((file) => file.id == id));
  }
  return selected;
}