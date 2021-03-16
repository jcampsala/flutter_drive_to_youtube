import 'package:equatable/equatable.dart';

class VideoFile extends Equatable {
  final String id;
  final String name;
  final List<String> path;
  final String thumbnail;

  const VideoFile({ this.id, this.name, this.path, String thumbnail }) :
    this.thumbnail = thumbnail ?? '';

  @override
  List<Object> get props => [id, name, path, thumbnail];

  @override
  String toString() => 'Video File { id: $id, name: $name, path: $path, thumbnail: $thumbnail }';

  String pathToString() {
    if(path.length < 1) return 'Fuera de mi unidad';
    String res = '';
    for(String pathSlice in path.reversed) {
      res += '$pathSlice => ';
    }
    return res.substring(0, res.length - 3);
  }
}