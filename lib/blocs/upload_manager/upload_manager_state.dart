import 'package:drive_to_youtube/models/playlist_data.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:equatable/equatable.dart';

abstract class UploadManagerState extends Equatable {
  const UploadManagerState();

  @override
  List<Object> get props => [];
}

class UploadManagerUninitialized extends UploadManagerState {}

class UploadManagerReady extends UploadManagerState {
  final List<YoutubeData> youtubeDataList;
  final List<PlayListData> playlists;
  final int selectedIndex;

  const UploadManagerReady({
    this.youtubeDataList,
    this.playlists,
    this.selectedIndex
  });

  @override
  List<Object> get props => [youtubeDataList, playlists, selectedIndex];

  @override
  String toString() => 'UploadManagerReady: { youtubeDataList: $youtubeDataList, playlists: $playlists selectedIndex: $selectedIndex }';
}

class UploadManagerError extends UploadManagerState {}