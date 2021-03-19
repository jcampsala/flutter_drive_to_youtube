import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/file_details_card.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/top_horizontal_scroll.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class FilePreuploadList extends StatefulWidget {
  final List<VideoFile> files;

  const FilePreuploadList({Key key, this.files}) : super(key: key);

  @override
  _FilePreuploadListState createState() => _FilePreuploadListState();
}

class _FilePreuploadListState extends State<FilePreuploadList> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UploadManagerBloc, UploadManagerState>(
        builder: (context, state) {
          if(state is UploadManagerReady) {
           return Column(
               children: [
                 Container(
                     constraints: BoxConstraints.tightFor(
                         width: MediaQuery.of(context).size.width,
                         height: min(150, MediaQuery.of(context).size.height * 0.3)
                     ),
                     child: TopHorizontalScroll(files: widget.files, selectedIndex: state.selectedIndex,)
                 ),
                 Divider(
                   indent: 15,
                   endIndent: 15,
                 ),
                 Expanded(
                   child: Container(
                       child: FileDetailsCard(file: widget.files[state.selectedIndex], ytData: state.youtubeDataList[state.selectedIndex],)
                   ),
                 )
               ]
           );
          } else if(state is UploadManagerUninitialized) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: CircularProgressIndicator(),
                    ),
                    Text('Initializing upload manager...')
                  ],
                )
            );
          } else {
            return Center(
              child: Text('Error initializing upload manager!'),
            );
          }
        },
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
}