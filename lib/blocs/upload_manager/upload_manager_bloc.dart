import 'package:bloc/bloc.dart';
import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:flutter/cupertino.dart';

class UploadManagerBloc extends Bloc<UploadManagerEvent, UploadManagerState> {
  List<YoutubeData> youtubeDataList = [];
  int selectedIndex = 0;

  UploadManagerBloc() : super(UploadManagerUninitialized());

  @override
  Stream<UploadManagerState> mapEventToState(UploadManagerEvent event) async* {
    if(event is InitUploadManager) {
      yield* _mapInitUploadManagerToState(event);
    } else if(event is SaveFormChanges) {
      yield* _mapSaveFormChangesToState(event);
    } else if(event is SaveTagChanges) {
      yield* _mapSaveTagChangesToState(event);
    } else if(event is UpdateSelectedIndex) {
      yield* _mapUpdateSelectedIndexToState(event);
    }
  }

  Stream<UploadManagerState> _mapInitUploadManagerToState(InitUploadManager event) async* {
    try {
      youtubeDataList = []; selectedIndex = 0;
      for(VideoFile v in event.files) {
        YoutubeData yData = new YoutubeData(
          name: v.name,
          description: '',
          tags: [],
          formKey: new GlobalKey<FormState>()
        );
        youtubeDataList.add(yData);
        yield UploadManagerReady(youtubeDataList: youtubeDataList, selectedIndex: selectedIndex);
      }
    } catch(e) {
      print('Error in _mapInitUploadManagerToState: $e');
    }
  }

  Stream<UploadManagerState> _mapSaveFormChangesToState(SaveFormChanges event) async* {
    youtubeDataList[event.fileIndex] = youtubeDataList[event.fileIndex].updateByName(event.attr, event.value);
    // TODO: check this messy logic, it is not recognized as new state when updating youtubeDataList array
    yield UploadManagerReady(youtubeDataList: [], selectedIndex: selectedIndex);
    yield UploadManagerReady(youtubeDataList: youtubeDataList, selectedIndex: selectedIndex);
  }

  Stream<UploadManagerState> _mapSaveTagChangesToState(SaveTagChanges event) async* {
    youtubeDataList[selectedIndex] = youtubeDataList[selectedIndex].updateTags(event.add, event.value);
    // TODO: check this messy logic, it is not recognized as new state when updating youtubeDataList array
    yield UploadManagerReady(youtubeDataList: [], selectedIndex: selectedIndex);
    yield UploadManagerReady(youtubeDataList: youtubeDataList, selectedIndex: selectedIndex);
  }

  Stream<UploadManagerState> _mapUpdateSelectedIndexToState(UpdateSelectedIndex event) async* {
    selectedIndex = event.selectedIndex;
    yield UploadManagerReady(youtubeDataList: youtubeDataList, selectedIndex: selectedIndex);
  }

}