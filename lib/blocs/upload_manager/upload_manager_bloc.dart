import 'package:bloc/bloc.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_barrel.dart';
import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/models/playlist_data.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

class UploadManagerBloc extends Bloc<UploadManagerEvent, UploadManagerState> {
  DriveApiBloc _driveApiBloc;
  List<YoutubeData> youtubeDataList = [];
  List<PlayListData> playlists = [];
  int selectedIndex = 0;

  UploadManagerBloc({@required DriveApiBloc driveApiBloc})
      : assert(driveApiBloc != null),
        _driveApiBloc = driveApiBloc,
        super(UploadManagerUninitialized());

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
    } else if(event is DeleteSelectedVideo) {
      yield* _mapDeleteSelectedVideoToState(event);
    } else if(event is ValidateUpload) {
      yield* _mapValidateUploadToState();
    }
  }

  Stream<UploadManagerState> _mapInitUploadManagerToState(InitUploadManager event) async* {
    try {
      youtubeDataList = []; selectedIndex = 0; playlists = [];
      for(VideoFile v in event.files) {
        YoutubeData yData = new YoutubeData(
          v.id,
          name: v.name,
          description: '',
          tags: [],
          formKey: new GlobalKey<FormState>(),
          thumbnail: v.thumbnail,
          visibility: 'private',
          playListId: ''
        );
        youtubeDataList.add(yData);
        // TODO: remove comment. Added to avoid calling YT api
        //playlists = await _driveApiBloc.getUserPlayLists();
        //playlists.add(new PlayListData('', '-'));
        yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
      }
    } catch(e) {
      print('Error in _mapInitUploadManagerToState: $e');
    }
  }

  Stream<UploadManagerState> _mapSaveFormChangesToState(SaveFormChanges event) async* {
    youtubeDataList[selectedIndex] = youtubeDataList[selectedIndex].updateByName(event.attr, event.value);
    // Same state with empty array is returned to force Bloc to recognize state change
    yield UploadManagerReady(youtubeDataList: [], playlists: playlists, selectedIndex: selectedIndex);
    yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
  }

  Stream<UploadManagerState> _mapSaveTagChangesToState(SaveTagChanges event) async* {
    youtubeDataList[selectedIndex] = youtubeDataList[selectedIndex].updateTags(event.add, event.value);
    // Same state with empty array is returned to force Bloc to recognize state change
    yield UploadManagerReady(youtubeDataList: [], playlists: playlists, selectedIndex: selectedIndex);
    yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
  }

  Stream<UploadManagerState> _mapUpdateSelectedIndexToState(UpdateSelectedIndex event) async* {
    selectedIndex = event.selectedIndex;
    yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
  }

  Stream<UploadManagerState> _mapDeleteSelectedVideoToState(DeleteSelectedVideo event) async* {
    youtubeDataList.removeWhere((e) => e.driveId == event.driveId);
    if(selectedIndex == youtubeDataList.length) selectedIndex -= 1;
    _driveApiBloc.add(UpdateSelected(selectedId: event.driveId));
    yield UploadManagerReady(youtubeDataList: [], playlists: playlists, selectedIndex: selectedIndex);
    yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
  }

  Stream<UploadManagerState> _mapValidateUploadToState() async* {
    List<int> errors = [];
    int index = 0;
    for(YoutubeData yData in youtubeDataList) {
      if(yData.name.length < 1) errors.add(index);
      index += 1;
    }
    if(errors.length > 0) {
      print('There are errors');
      yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
    } else {
      print('All ok');
      yield UploadManagerReady(youtubeDataList: youtubeDataList, playlists: playlists, selectedIndex: selectedIndex);
    }
    _driveApiBloc.add(UploadSelected(youtubeData: youtubeDataList));
  }

}