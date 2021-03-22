import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:equatable/equatable.dart';

abstract class DriveApiEvent extends Equatable {
  const DriveApiEvent();

  @override
  List<Object> get props => [];
}

class InitDriveApi extends DriveApiEvent {
  final bool auto;

  const InitDriveApi({
    this.auto,
  });

  @override
  List<Object> get props => [auto];

  @override
  String toString() => 'InitDriveApi: { auto: $auto }';
}

class FetchVideoFiles extends DriveApiEvent {}

class DownloadVideoFile extends DriveApiEvent {
  final String fileId;
  final String fileName;

  const DownloadVideoFile({
    this.fileId,
    this.fileName
  });

  @override
  List<Object> get props => [fileId, fileName];

  @override
  String toString() => 'DownloadVideo: { id: $fileId, name: $fileName }';
}

class UpdateSelected extends DriveApiEvent {
  final String selectedId;

  const UpdateSelected({
    this.selectedId,
  });

  @override
  List<Object> get props => [selectedId];

  @override
  String toString() => 'UpdateSelected: { selectedId: $selectedId }';
}

class BulkSelect extends DriveApiEvent {
  final bool select;

  const BulkSelect({
    this.select,
  });

  @override
  List<Object> get props => [select];

  @override
  String toString() => 'BulkSelect: { select: $select }';
}

class UploadSelected extends DriveApiEvent {
  final List<YoutubeData> youtubeData;

  const UploadSelected({
    this.youtubeData,
  });

  @override
  List<Object> get props => [youtubeData];

  @override
  String toString() => 'UploadSelected: { videos to upload: ${youtubeData.length} }';
}