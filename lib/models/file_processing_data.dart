import 'package:equatable/equatable.dart';
import 'package:drive_to_youtube/utils.dart';

class FileProcessingData extends Equatable {
  final String fileId;
  final Process process;
  final String displayError;
  final dynamic error;

  const FileProcessingData(this.fileId, { Process process, String displayError, dynamic error }) :
        this.process = process ?? Process.idle,
        this.displayError = displayError ?? '',
        this.error = error ?? '';

  @override
  List<Object> get props => [fileId, process, displayError, error];

  @override
  String toString() => 'File Procesing Data { fileId: $fileId, process: $process, displayError: $displayError, error: $error }';

  FileProcessingData copyWith({Process process, String displayError, dynamic error}) {
    return new FileProcessingData(
      fileId,
      process: process ?? this.process,
      displayError: displayError ?? this.displayError,
      error: error ?? this.error
    );
  }
}