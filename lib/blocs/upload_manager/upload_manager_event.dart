import 'package:drive_to_youtube/models/video_file.dart';
import 'package:equatable/equatable.dart';

abstract class UploadManagerEvent extends Equatable {
  const UploadManagerEvent();

  @override
  List<Object> get props => [];
}

class InitUploadManager extends UploadManagerEvent {
  final List<VideoFile> files;

  const InitUploadManager({
    this.files,
  });

  @override
  List<Object> get props => [files];

  @override
  String toString() => 'InitUploadManager: { number of files: ${files.length} }';
}

class SaveFormChanges extends UploadManagerEvent {
  final int fileIndex;
  final String attr;
  final dynamic value;

  const SaveFormChanges({
    this.fileIndex,
    this.attr,
    this.value
  });

  @override
  List<Object> get props => [fileIndex, attr, value];

  @override
  String toString() => 'SaveFormChanges: { fileIndex: $fileIndex, attr: $attr, value: $value }';
}

class UpdateSelectedIndex extends UploadManagerEvent {
  final int selectedIndex;

  const UpdateSelectedIndex({
    this.selectedIndex,
  });

  @override
  List<Object> get props => [selectedIndex];

  @override
  String toString() => 'UpdateSelectedIndex: { selectedIndex: $selectedIndex }';
}