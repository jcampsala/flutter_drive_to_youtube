import 'package:drive_to_youtube/models/video_file.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class FileDetailsCard extends StatefulWidget {
  final VideoFile file;

  const FileDetailsCard({Key key, this.file}) : super(key: key);

  @override
  _FileDetailsCardState createState() => _FileDetailsCardState();
}

class _FileDetailsCardState extends State<FileDetailsCard> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    print(_formKey);
    print(_formKey.currentState);
    print(_formKey.currentWidget);
    //_formKey.currentState.reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(15),
        constraints: BoxConstraints.tightFor(
          width: MediaQuery.of(context).size.width
        ),
        decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0),
          )
        ]
      ),
      child: Container(
        color: Colors.white,
        child: Container(
          constraints: BoxConstraints.tightFor(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height
          ),
          child: Form(
            key: _formKey,
            child: Container(
              padding: EdgeInsets.all(15),
              child: Container(
                constraints: BoxConstraints.tightFor(
                  width: MediaQuery.of(context).size.width * 0.5
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'File name'
                      ),
                      readOnly: true,
                      initialValue: widget.file.name,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Drive path',
                          suffix: GestureDetector(
                            onTap: () => _launchURL(widget.file.driveLink),
                            child: Text('View in Drive'),
                          )
                      ),
                      readOnly: true,
                      initialValue: widget.file.pathToString(),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            constraints: BoxConstraints.tightFor(
                                width: 50,
                                height: 50
                            ),
                            child: Image.asset('youtube_logo.png'),
                          ),
                          Text('Youtube settings', style: TextStyle(fontSize: 18),),
                        ],
                      ),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Video name',
                      ),
                      initialValue: widget.file.name,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Video description',
                      ),
                      initialValue: '',
                    ),
                  ],
                ),
              )
            ),
          ),
        )
      )
    );
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}