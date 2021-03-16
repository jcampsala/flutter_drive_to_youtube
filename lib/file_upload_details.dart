import 'package:drive_to_youtube/models/video_file.dart';
import 'package:flutter/material.dart';

class FileUploadDetails extends StatelessWidget {
  final List<VideoFile> selectedFiles;

  const FileUploadDetails({
    Key key,
    this.selectedFiles
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Here selecte files should appear'),
      ),
    );
  }
}