import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:flutter/rendering.dart';

/*class VideoFileMiniTile extends StatelessWidget {
  final VideoFile file;
  final bool selected;

  const VideoFileMiniTile({Key key, this.file, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        boxShadow: selected
            ? [
          BoxShadow(
            color: Colors.blueAccent,
            blurRadius: 5.0,
            spreadRadius: 5.0,
            offset: Offset(0.0, 0.0), // shadow direction: bottom right
          )
        ]
            : [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 3.0,
            spreadRadius: 0.0,
            offset: Offset(2.0, 2.0), // shadow direction: bottom right
          )
        ],
      ),
      child: Container(
        constraints: BoxConstraints.tightFor(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.8),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(5)),
        child: Container(
          child: file.thumbnail.length > 0
              ? FadeInImage.assetNetwork(
            placeholder: 'assets/img_not_found.png',
            image: file.thumbnail,
            fit: BoxFit.fitHeight,
          )
              : Image.asset('assets/img_not_found.png', fit: BoxFit.fitHeight)//Icon(Icons.ondemand_video, size: 36),
        ),
      ),
    );
  }
}*/

class VideoFileMiniTile extends StatefulWidget {
  final VideoFile file;
  final bool selected;

  const VideoFileMiniTile({Key key, this.file, this.selected}) : super(key: key);

  _VideoFileMiniTileState createState() => _VideoFileMiniTileState();

}

class _VideoFileMiniTileState extends State<VideoFileMiniTile> {
  bool inside = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _manageMouseEvent(true),
      onExit: (_) => _manageMouseEvent(false),
      cursor: MaterialStateMouseCursor.clickable,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          boxShadow: widget.selected
              ? [
            BoxShadow(
              color: inside ? Colors.yellowAccent : Colors.blueAccent,
              blurRadius: 5.0,
              spreadRadius: 5.0,
              offset: Offset(0.0, 0.0), // shadow direction: bottom right
            )
          ]
              : [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 3.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Container(
          constraints: BoxConstraints.tightFor(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.circular(5)),
          child: Container(
              child: widget.file.thumbnail.length > 0
                  ? FadeInImage.assetNetwork(
                placeholder: 'assets/img_not_found.png',
                image: widget.file.thumbnail,
                fit: BoxFit.fitHeight,
              )
                  : Image.asset('assets/img_not_found.png', fit: BoxFit.fitHeight)//Icon(Icons.ondemand_video, size: 36),
          ),
        ),
      ),
    );
  }

  void _manageMouseEvent(bool enter) {
    setState(() {
      inside = enter;
    });
  }
}
