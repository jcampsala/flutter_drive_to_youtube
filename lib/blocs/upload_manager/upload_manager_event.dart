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
  final String attr;
  final dynamic value;

  const SaveFormChanges({
    this.attr,
    this.value
  });

  @override
  List<Object> get props => [attr, value];

  @override
  String toString() => 'SaveFormChanges: { attr: $attr, value: $value }';
}

class SaveTagChanges extends UploadManagerEvent {
  final bool add;
  final List<String> value;

  const SaveTagChanges({
    this.add,
    this.value
  });

  @override
  List<Object> get props => [add, value];

  @override
  String toString() => 'SaveTagChanges: { attr: $add, value: $value }';
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

class DeleteSelectedVideo extends UploadManagerEvent {
  final String driveId;

  const DeleteSelectedVideo({
    this.driveId,
  });

  @override
  List<Object> get props => [driveId];

  @override
  String toString() => 'DeleteSelectedVideo: { selectedIndex: $driveId }';
}

class ValidateUpload extends UploadManagerEvent {}