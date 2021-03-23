import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:drive_to_youtube/uploading/updatable_video_file_mini_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:drive_to_youtube/utils.dart';

class UploadingPage extends StatelessWidget {
  final DriveApiBloc driveApiBloc;

  const UploadingPage({Key key, this.driveApiBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriveApiBloc, DriveApiState>(
      cubit: driveApiBloc,
      builder: (context, state) {
        if(state is DAProcessing) {
          return Scaffold(
            body: Container(
              child: GridView.builder(
                padding: EdgeInsets.all(20),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    mainAxisExtent: 200,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30),
                itemCount: state.files.length,
                itemBuilder: (context, index) {
                  Process p = state.activeFileIndex == index ? state.process : Process.idle;
                  return UpdatableVideoFileMiniTile(
                      file: state.files[index],
                      process: p
                  );
                },
              ),
            ),
          );
        } else if(state is DAReady) {
          return Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text('All videos uploaded to Youtube'),
                ),
                MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  color: Colors.red,
                  child: Text('Return', style: TextStyle(color: Colors.white),),
                ),
              ],
            )
          );
        }
        else {
          print('Unknown state $state');
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}