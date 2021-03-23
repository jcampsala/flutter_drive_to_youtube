import 'package:equatable/equatable.dart';

class PlayListData extends Equatable {
  final String id;
  final String name;

  const PlayListData(this.id, this.name );

  @override
  List<Object> get props => [id, name];

  @override
  String toString() => 'Play list data { id: $id, name: $name }';
}