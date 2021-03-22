import 'package:equatable/equatable.dart';

class VideoFile extends Equatable {
  final String id;
  final String name;
  final List<String> path;
  final String thumbnail;
  final String driveLink;
  final String size;

  const VideoFile({ this.id, this.name, this.path, String thumbnail, this.driveLink, this.size }) :
    this.thumbnail = thumbnail ?? '';

  @override
  List<Object> get props => [id, name, path, thumbnail, driveLink, size];

  @override
  String toString() => 'Video File { id: $id, name: $name, path: $path, thumbnail: $thumbnail, driveLink: $driveLink, size: $size }';

  String pathToString() {
    if(path.length < 1) return 'Outside my drive';
    String res = '';
    for(String pathSlice in path.reversed) {
      res += '$pathSlice => ';
    }
    return res.substring(0, res.length - 3);
  }
}