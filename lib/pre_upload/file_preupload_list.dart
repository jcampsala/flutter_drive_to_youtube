import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:drive_to_youtube/pre_upload/file_details_card.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/pre_upload/top_horizontal_scroll.dart';
import 'package:drive_to_youtube/uploading/uploading_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:math';

class FilePreUploadList extends StatefulWidget {
  final List<VideoFile> files;
  final DriveApiBloc driveApiBloc;

  const FilePreUploadList({Key key, this.files, this.driveApiBloc}) : super(key: key);

  @override
  _FilePreUploadListState createState() => _FilePreUploadListState();
}

class _FilePreUploadListState extends State<FilePreUploadList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UploadManagerBloc, UploadManagerState>(
        builder: (context, state) {
          if (state is UploadManagerReady && state.youtubeDataList.length > 0) {
            return Stack(
              children: [
                Column(children: [
                  Container(
                      constraints: BoxConstraints.tightFor(
                          width: MediaQuery.of(context).size.width,
                          height: min(
                              150, MediaQuery.of(context).size.height * 0.3)),
                      child: TopHorizontalScroll(
                        files: state.youtubeDataList,//widget.files,
                        selectedIndex: state.selectedIndex,
                      )),
                  Divider(
                    indent: 15,
                    endIndent: 15,
                  ),
                  Expanded(
                    child: Container(
                        child: FileDetailsCard(
                      file: widget.files[state.selectedIndex],
                      ytData: state.youtubeDataList[state.selectedIndex],
                    )),
                  )
                ]),
                Positioned(
                  bottom: 30,
                  right: 30,
                  child: MaterialButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 10,
                      color: Colors.redAccent,
                      onPressed: () => _showConfirmationDialog(context),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text(
                              'Upload all ',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Icon(
                              Icons.file_upload,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )),
                ),
              ],
            );
          } else if(state is UploadManagerReady && state.youtubeDataList.length < 1) {
            WidgetsBinding.instance
                .addPostFrameCallback((_) => Navigator.of(context).pop());
            return Container();
          } else if (state is UploadManagerUninitialized) {
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
            ));
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

  Future<void> _showConfirmationDialog(BuildContext upperContext) async {
    bool confirmed = false;
    return showDialog<String>(
      context: upperContext,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload selected videos'),
          content: Container(
            child: Text('All selected videos (${widget.files.length}) will be uploaded with the provided youtube settings. Are you sure?'),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.red,
              child: Text('Confirm', style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              onPressed: () {
                confirmed = true;
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Colors.grey,
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      if(confirmed) {
        // TODO this needs complete rework, a validation should take place first and then should the upload data be passed to driveApiBloc
        List<YoutubeData> youtubeData = BlocProvider.of<UploadManagerBloc>(upperContext).youtubeDataList;
        widget.driveApiBloc.add(UploadSelected(youtubeData: youtubeData));
        Navigator.push(
            upperContext, MaterialPageRoute(builder: (routeContext) => UploadingPage(driveApiBloc: widget.driveApiBloc,)));
      }
    });
  }
}
