import 'package:drive_to_youtube/file_details_card.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/top_horizontal_scroll.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class FilePreuploadList extends StatefulWidget {
  final List<VideoFile> files;

  const FilePreuploadList({Key key, this.files}) : super(key: key);

  @override
  _FilePreuploadListState createState() => _FilePreuploadListState();
}

class _FilePreuploadListState extends State<FilePreuploadList> {
  int fileIndex;

  @override
  void initState() {
    fileIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width,
                  height: min(150, MediaQuery.of(context).size.height * 0.3)
              ),
              child: TopHorizontalScroll(files: widget.files, fileTapEvent: updateSelectedFile, selectedIndex: fileIndex,)
          ),
          Divider(
            indent: 15,
            endIndent: 15,
          ),
          Expanded(
            child: Container(
              child: FileDetailsCard(file: widget.files[fileIndex],)
            ),
          )
        ]
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(top: 10),
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          child: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
    );
  }

  void updateSelectedFile(int index) {
    setState(() {
      fileIndex = index;
    });
  }
}