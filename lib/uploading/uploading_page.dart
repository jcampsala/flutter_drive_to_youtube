import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:drive_to_youtube/uploading/updatable_video_file_mini_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class UploadingPage extends StatelessWidget {
  final DriveApiBloc driveApiBloc;

  const UploadingPage({Key key, this.driveApiBloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DriveApiBloc, DriveApiState>(
      cubit: driveApiBloc,
      builder: (context, state) {
        if (state is DAProcessing) {
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
                  return UpdatableVideoFileMiniTile(
                      file: state.files[index],
                      processData: state.fileProcessingData[index]);
                },
              ),
            ),
          );
        } else if (state is DAProcessEnded) {
          return Scaffold(
              body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  constraints: BoxConstraints.tightFor(
                      height: MediaQuery.of(context).size.height * 0.1),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(bottom: 15),
                        child: Text('All videos uploaded to Youtube'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          driveApiBloc.add(ResetFlow());
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        color: Colors.red,
                        child: Text(
                          'Return',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  )),
              Divider(indent: 15, endIndent: 15,),
              Container(
                constraints: BoxConstraints.tightFor(
                    height: MediaQuery.of(context).size.height * 0.8),
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
                    //Process p = state.activeFileIndex == index ? state.process : Process.idle;
                    return UpdatableVideoFileMiniTile(
                        file: state.files[index],
                        processData: state.fileProcessingData[index]);
                  },
                ),
              ),
            ],
          ));
        } else {
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
