import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'utils.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VideoFileTile extends StatelessWidget {
  final VideoFile file;
  final bool selected;

  const VideoFileTile({Key key, this.file, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /*onTap: () => BlocProvider.of<DriveApiBloc>(context)
          .add(DownloadVideoFile(fileId: file.id, fileName: file.name)),*/
      onTap: () => BlocProvider.of<DriveApiBloc>(context)
          .add(UpdateSelected(selectedId: file.id)),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.blueAccent,
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                    offset: Offset(0.0, 0.0), // shadow direction: bottom right
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 3.0,
                    spreadRadius: 0.0,
                    offset: Offset(2.0, 2.0), // shadow direction: bottom right
                  )
                ],
        ),
        child: Stack(
          children: [
            Container(
              constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.8),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1.0),
                  borderRadius: BorderRadius.circular(5)),
              child: Container(
                child: file.thumbnail.length > 0
                    ? Image.network(
                        file.thumbnail,
                        fit: BoxFit.fitHeight,
                      )
                    : Icon(Icons.ondemand_video, size: 36),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  constraints: BoxConstraints.tightFor(
                      width: MediaQuery.of(context).size.width,
                      height:
                          min(50, MediaQuery.of(context).size.height * 0.05)),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(200, 220, 220, 220),
                    border:
                        Border(top: BorderSide(color: Colors.grey, width: 1.0)),
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text(file.name),
                  )),
            ),
            Positioned(
                right: 2,
                top: 2,
                child: Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(150, 255, 255, 255),
                      borderRadius: BorderRadius.circular(5)),
                  child: IconButton(
                      padding: EdgeInsets.all(1),
                      icon: Icon(Icons.folder_open),
                      onPressed: () =>
                          showFullPath(file.pathToString(), context)),
                ))
          ],
        ),
      ),
    );
  }
}
