import 'package:drive_to_youtube/models/video_file.dart';
import 'package:equatable/equatable.dart';

abstract class DriveApiState extends Equatable {
  const DriveApiState();

  @override
  List<Object> get props => [];
}

class DAUninitialized extends DriveApiState {}

class DAReady extends DriveApiState {
  final List<VideoFile> files;
  final List<String> selected;

  const DAReady({
    this.files,
    this.selected
  });

  @override
  List<Object> get props => [files, selected];

  @override
  String toString() => 'DAReady: { numer of files: ${files.length}, selected files: $selected }';
}

class DAInitializationError extends DriveApiState {}

class DALoggingIn extends DriveApiState {}

class DAFetching extends DriveApiState {
  final int fileCount;

  const DAFetching({
    this.fileCount,
  });

  @override
  List<Object> get props => [fileCount];

  @override
  String toString() => 'DAFetching: { number of files: $fileCount }';
}

class DADownloading extends DriveApiState {
  final String fileName;

  const DADownloading({
    this.fileName
  });

  @override
  List<Object> get props => [fileName];

  @override
  String toString() => 'DADownloading: { name: $fileName }';
}

class DAUploading extends DriveApiState {
  final String fileName;

  const DAUploading({
    this.fileName
  });

  @override
  List<Object> get props => [fileName];

  @override
  String toString() => 'DAUploading { name: $fileName }';
}