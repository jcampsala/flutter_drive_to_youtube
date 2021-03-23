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
        constraints:
            BoxConstraints.tightFor(width: MediaQuery.of(context).size.width),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0),
          )
        ]),
        child: Container(
            color: Colors.white,
            child: Container(
                constraints: BoxConstraints.tightFor(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height),
                child: SingleChildScrollView(
                  child: Form(
                    key: widget.ytData.formKey,
                    child: Container(
                        padding: EdgeInsets.all(15),
                        child: Container(
                          constraints: BoxConstraints.tightFor(
                              width: MediaQuery.of(context).size.width * 0.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                decoration:
                                    InputDecoration(labelText: 'File name'),
                                readOnly: true,
                                initialValue: widget.file.name,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    labelText: 'Drive path',
                                    suffix: GestureDetector(
                                      onTap: () =>
                                          _launchURL(widget.file.driveLink),
                                      child: Text('View in Drive'),
                                    )),
                                readOnly: true,
                                initialValue: widget.file.pathToString(),
                              ),
                              TextFormField(
                                  decoration:
                                      InputDecoration(labelText: 'File size'),
                                  readOnly: true,
                                  initialValue:
                                      _formatFileSize(widget.file.size)),
                              Container(
                                margin: EdgeInsets.only(top: 30),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints.tightFor(
                                          width: 50, height: 50),
                                      child: Image.asset('youtube_logo.png'),
                                    ),
                                    Text(
                                      'Youtube settings',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Video name',
                                  ),
                                  initialValue: widget.ytData.name,
                                  onChanged: (val) =>
                                      _manageChanges(context, 'name', val)),
                              TextFormField(
                                  decoration: InputDecoration(
                                    labelText: 'Video description',
                                  ),
                                  initialValue: widget.ytData.description,
                                  onChanged: (val) => _manageChanges(
                                      context, 'description', val)),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints.tightFor(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 20),
                                          child: Text(
                                            'Tags',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Container(
                                            child: Wrap(
                                          children: _buildTagField(context),
                                          alignment: WrapAlignment.center,
                                        )),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    constraints: BoxConstraints.tightFor(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4),
                                    child: Column(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 25, bottom: 15),
                                          child: Text(
                                            'Visibility',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Container(
                                          child: DropdownButton<String>(
                                              value: widget.ytData.visibility,
                                              items: <String>[
                                                'public',
                                                'private'
                                              ].map<DropdownMenuItem<String>>(
                                                  (e) {
                                                return DropdownMenuItem<String>(
                                                    value: e,
                                                    child: Row(
                                                      children: [
                                                        Text(e
                                                                .substring(0, 1)
                                                                .toUpperCase() +
                                                            e.substring(1)),
                                                        SizedBox(width: 5),
                                                        Icon(e == 'public'
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off)
                                                      ],
                                                    ));
                                              }).toList(),
                                              onChanged: (String val) =>
                                                  _manageChanges(context,
                                                      'visibility', val)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                              top: 25, bottom: 15),
                                          child: Text(
                                            'Playlist',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                        Container(
                                          child: BlocBuilder<UploadManagerBloc,
                                                  UploadManagerState>(
                                              builder: (context, state) {
                                            if (state is UploadManagerReady) {
                                              return DropdownButton<String>(
                                                  value:
                                                      widget.ytData.playListId,
                                                  items: state.playlists.map<
                                                      DropdownMenuItem<
                                                          String>>((e) {
                                                    return DropdownMenuItem<
                                                            String>(
                                                        value: e.id,
                                                        child: Text(e.name));
                                                  }).toList(),
                                                  onChanged: (String val) =>
                                                      _manageChanges(context,
                                                          'playListId', val));
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ))));
  }

  void _launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  void _manageChanges(BuildContext context, String source, String value) {
    BlocProvider.of<UploadManagerBloc>(context)
        .add(SaveFormChanges(attr: source, value: value));
  }

  List<Widget> _buildTagField(BuildContext context) {
    List<Widget> tagFields = [];
    for (String tag in widget.ytData.tags) {
      tagFields.add(Container(
        padding: EdgeInsets.all(5),
        child: Chip(
          label: Text(tag),
          onDeleted: () => BlocProvider.of<UploadManagerBloc>(context)
              .add(SaveTagChanges(add: false, value: [tag])),
        ),
      ));
    }
    // Add button inserted after tag chips
    tagFields.add(MaterialButton(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Add tag'),
              SizedBox(width: 5),
              Icon(Icons.add_circle_outline)
            ],
          ),
        ),
        onPressed: () => _showTagDialog(context)));
    return tagFields;
  }

  Future<void> _showTagDialog(BuildContext upperContext) async {
    TextEditingController _controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Add tags',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('To add multiple tags separate them with ","'),
                TextField(
                    controller: _controller,
                    autofocus: true,
                    onEditingComplete: () => Navigator.of(context).pop())
              ],
            ),
          ),
          actions: <Widget>[
            MaterialButton(
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                onPressed: () => Navigator.of(context).pop()),
          ],
        );
      },
    ).then((_) {
      String stringTags = _controller.text;
      if (stringTags.length > 0) {
        List<String> tags = stringTags.split(',');
        tags.map((e) => e.trim());
        BlocProvider.of<UploadManagerBloc>(upperContext)
            .add(SaveTagChanges(add: true, value: tags));
      }
    });
  }

  String _formatFileSize(String size) {
    // Size is in bytes
    int s = int.parse(size);
    double mb = s / (1024 * 1024);
    if (mb < 1024)
      return '${mb.toStringAsFixed(2)} MB';
    else
      return '${(mb / 2014).toStringAsFixed(2)} GB';
  }
}
