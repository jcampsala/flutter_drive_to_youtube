import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/video_file_tile.dart';
import 'package:flutter/material.dart';

class TopHorizontalScroll extends StatelessWidget {
  final List<VideoFile> files;
  
  const TopHorizontalScroll({
    Key key,
    this.files
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          itemBuilder: (context, index) {
            return VideoFileTile(file: files[index], selected: false);
          }
      )
    );
  }
}