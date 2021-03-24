import 'package:drive_to_youtube/models/file_processing_data.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:flutter/material.dart';
import 'package:drive_to_youtube/utils.dart';

class UpdatableVideoFileMiniTile extends StatelessWidget {
  final YoutubeData file;
  final FileProcessingData processData;

  const UpdatableVideoFileMiniTile({Key key, this.file, this.processData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
          boxShadow: processData.process == Process.error
              ? [
                  BoxShadow(
                    color: Colors.redAccent,
                    blurRadius: 5.0,
                    spreadRadius: 5.0,
                    offset: Offset(0.0, 0.0), // shadow direction: bottom right
                  )
                ]
              : processData.process == Process.completed
                  ? [
                      BoxShadow(
                        color: Colors.lightGreenAccent,
                        blurRadius: 5.0,
                        spreadRadius: 5.0,
                        offset:
                            Offset(2.0, 2.0), // shadow direction: bottom right
                      )
                    ]
                  : processData.process != Process.idle
                      ? [
                          BoxShadow(
                            color: Colors.blueAccent,
                            blurRadius: 3.0,
                            spreadRadius: 0.0,
                            offset: Offset(
                                2.0, 2.0), // shadow direction: bottom right
                          )
                        ]
                      : [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3.0,
                            spreadRadius: 0.0,
                            offset: Offset(2.0, 2.0),
                          )
                        ] // shadow direction: bottom right
          ),
      child: Container(
          constraints: BoxConstraints.tightFor(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          child: Stack(
            children: [
              Container(
                  child: file.thumbnail.length > 0
                      ? FadeInImage.assetNetwork(
                          placeholder: 'assets/img_not_found.png',
                          image: file.thumbnail,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.asset('assets/img_not_found.png',
                          fit: BoxFit
                              .fitHeight) //Icon(Icons.ondemand_video, size: 36),
                  ),
              processData.process == Process.uploading
                  ? Container(
                      constraints: BoxConstraints.tightFor(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                      ),
                      color: Color.fromARGB(100, 255, 255, 255),
                      child: Center(
                        child: LinearProgressIndicator(),
                      ),
                    )
                  : processData.process == Process.downloading
                      ? Container(
                          constraints: BoxConstraints.tightFor(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                          color: Color.fromARGB(100, 255, 255, 255),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(),
              processData.process == Process.error
                  ? Positioned(
                      top: 50,
                      left: 50,
                      child: MaterialButton(
                        child: Text('Show error'),
                        onPressed: () {
                          print(processData.error);
                          print(processData.displayError);
                        },
                      ))
                  : Container()
            ],
          )),
    );
  }
}
