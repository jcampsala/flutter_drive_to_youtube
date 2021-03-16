import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:drive_to_youtube/top_horizontal_scroll.dart';
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
                  Text('Fetching video files...')
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.file_upload),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => TopHorizontalScroll(files: BlocProvider.of<DriveApiBloc>(context).filesCache,)))
      ),
    );
  }
}