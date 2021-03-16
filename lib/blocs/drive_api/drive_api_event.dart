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