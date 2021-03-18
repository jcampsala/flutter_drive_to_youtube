import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/file_preupload_list.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/utils.dart';
import 'package:drive_to_youtube/video_file_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DriveApiBloc, DriveApiState>(
        builder: (context, state) {
          if(state is DAUninitialized) {
            return Container(
              child: Center(
                child: ElevatedButton(
                  child: Text('Login to Drive'),
                  onPressed: () {
                    BlocProvider.of<DriveApiBloc>(context).add(InitDriveApi(auto: false));
                  },
                ),
              ),
            );
          } else if(state is DAReady) {
            return Container(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
                top: 10
              ),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30),
                itemCount: state.files.length,
                itemBuilder: (context, index) {
                  return VideoFileTile(
                    file: state.files[index],
                    selected: state.selected.contains(state.files[index].id)
                  );
                },
              ),
            );
          } else if(state is DAInitializationError) {
            return Container(
              color: Colors.red,
              child: Center(
                child: Text('Error in Drive Api inizialization'),
              ),
            );
          } else if(state is DALoggingIn) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircularProgressIndicator(),
                  ),
                  Text('Logging in...')
                ],
              )
            );
          } else if(state is DAFetching) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 10),
                    child: CircularProgressIndicator(),
                  ),
                  Text('Fetching video files... (${state.fileCount})')
                ],
              )
            );
          } else if(state is DADownloading) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: CircularProgressIndicator(),
                    ),
                    Text('Downloading ${state.fileName}...')
                  ],
                )
            );
          } else if(state is DAUploading) {
            return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: CircularProgressIndicator(),
                    ),
                    Text('Uploading ${state.fileName}...')
                  ],
                )
            );
          } else {
            return Center(
              child: Text('Unknow state => $state'),
            );
          }
        },
      ),
      floatingActionButton: BlocBuilder<DriveApiBloc, DriveApiState>(
        builder: (context, state) {
          if(state is DAReady && state.selected.length > 0) {
            return FloatingActionButton(
              backgroundColor: Colors.red,
                child: Icon(Icons.file_upload),
                onPressed: () {
                  List<VideoFile> files = getSelectedVideoFiles(
                      BlocProvider.of<DriveApiBloc>(context).selectedFiles,
                      BlocProvider.of<DriveApiBloc>(context).filesCache);
                  /*Navigator.push(
                      context, MaterialPageRoute(builder: (context) => FilePreuploadList(files: files)));*/
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => BlocProvider<UploadManagerBloc>(
                    create: (context) => UploadManagerBloc()..add(InitUploadManager(files: files)),
                    child: FilePreuploadList(files: files),
                  )));
                }
            );
          } else {
            return Container();
          }
        },
      )
    );
  }
}