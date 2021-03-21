import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FileDetailsCard extends StatefulWidget {
  final VideoFile file;
  final YoutubeData ytData;

  const FileDetailsCard({Key key, this.file, this.ytData}) : super(key: key);

  @override
  _FileDetailsCardState createState() => _FileDetailsCardState();
}

class _FileDetailsCardState extends State<FileDetailsCard> {

  @override
  void initState() {
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
            key: widget.ytData.formKey,
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
                        initialValue: widget.ytData.name,
                        onChanged: (val) => _manageChanges(context, 'name', val)
                    ),
                    TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Video description',
                        ),
                        initialValue: widget.ytData.description,
                        onChanged: (val) => _manageChanges(context, 'description', val)
                    ),
                    Container(
                      child: Text('Tags'),
                    ),
                    Flexible(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _buildTagField(context)
                        )
                    )
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

  void _manageChanges(BuildContext context, String source, String value) {
    int selectedIndex = BlocProvider.of<UploadManagerBloc>(context).selectedIndex;
    BlocProvider.of<UploadManagerBloc>(context).add(SaveFormChanges(
        fileIndex: selectedIndex,
        attr: source,
        value: value
    ));
  }

  List<Widget> _buildTagField(BuildContext context) {
    List<Widget> tagFields = [];
    for(String tag in widget.ytData.tags) {
      tagFields.add(
        Chip(
          label: Text(tag),
          onDeleted: () => BlocProvider.of<UploadManagerBloc>(context).add(SaveTagChanges(add: false, value: [tag])),
        ),
      );
    }
    // Add button inserted after tag chips
    tagFields.add(
        MaterialButton(
            child: Row(
              children: [
                Text('Add tag'),
                Icon(Icons.add_circle_outline)
              ],
            ),
            onPressed: () => _showTagDialog(context)
        )
    );
    return tagFields;
  }

  Future<void> _showTagDialog(BuildContext upperContext) async {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add tags'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('To add multiple tags separate them with ","'),
                TextField(controller: _controller,)
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Add'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    ).then((_) {
      String stringTags = _controller.text;
      if(stringTags.length > 0) {
        List<String> tags = stringTags.split(',');
        tags.map((e) => e.trim());
        BlocProvider.of<UploadManagerBloc>(upperContext).add(SaveTagChanges(
            add: true,
            value: tags
        ));
      }
    });
  }
}