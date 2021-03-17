import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/video_file_mini_tile.dart';
import 'package:flutter/material.dart';

class TopHorizontalScroll extends StatelessWidget {
  final List<VideoFile> files;
  final Function fileTapEvent;
  final int selectedIndex;

  const TopHorizontalScroll({Key key, this.files, this.fileTapEvent, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(15),
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width * 0.15),
              child: GestureDetector(
                onTap: () => fileTapEvent(index),
                child: VideoFileMiniTile(file: files[index], selected: index == selectedIndex),
              ));
        });
  }
}
