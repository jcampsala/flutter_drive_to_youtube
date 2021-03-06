import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:drive_to_youtube/pre_upload/video_file_mini_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/upload_manager/upload_manager_barrel.dart';
import 'dart:math';

class TopHorizontalScroll extends StatelessWidget {
  //final List<VideoFile> files;
  final List<YoutubeData> files;
  final int selectedIndex;

  const TopHorizontalScroll({Key key, this.files, this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: files.length,
        itemBuilder: (context, index) {
          return Container(
              padding: EdgeInsets.all(15),
              constraints: BoxConstraints.tightFor(
                  width: max(MediaQuery.of(context).size.width * 0.15, 150)),
              child: GestureDetector(
                onTap: () => BlocProvider.of<UploadManagerBloc>(context).add(UpdateSelectedIndex(selectedIndex: index)),
                child: VideoFileMiniTile(file: files[index], selected: index == selectedIndex),
              ));
        });
  }
}
