import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_event.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_state.dart';
import 'package:drive_to_youtube/models/file_processing_data.dart';
import 'package:drive_to_youtube/models/playlist_data.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:drive_to_youtube/models/youtube_data.dart';
import 'package:flutter/services.dart';
import 'package:googleapis/drive/v3.dart' as driveV3;
import 'package:googleapis/youtube/v3.dart' as ytV3;
import 'package:googleapis_auth/auth_browser.dart';
import 'package:drive_to_youtube/utils.dart' as utils;

class DriveApiBloc extends Bloc<DriveApiEvent, DriveApiState> {
  final ClientId id = ClientId('515168489445-t91kf9hih4vfh26eqbn5r9bebd30gln1.apps.googleusercontent.com', '8WZqw16s-YwcrfKGuUe7woS2');
  final List<String> scopes = [driveV3.DriveApi.driveScope, /*ytV3.YouTubeApi.youtubeUploadScope*/ ytV3.YouTubeApi.youtubeScope];
  driveV3.DriveApi drive;
  ytV3.YouTubeApi youtube;

  List<VideoFile> filesCache = [];
  List<String> selectedFiles = [];

  DriveApiBloc() : super(DAUninitialized());

  @override
  Stream<DriveApiState> mapEventToState(DriveApiEvent event) async* {
    if(event is InitDriveApi) {
      yield* _mapInitDriveApiToState(event);
    } else if(event is FetchVideoFiles) {
      yield* _mapFetchVideoFilesToState();
    } else if(event is DownloadVideoFile) {
      yield* _mapDownloadVideoFileToState(event);
    } else if(event is UpdateSelected) {
      yield* _mapUpdateSelectedToState(event);
    } else if(event is BulkSelect) {
      yield* _mapBulkSelectToState(event);
    } else if(event is UploadSelected) {
      yield* _mapUploadSelectedToState(event);
    }
  }

  Stream<DriveApiState> _mapInitDriveApiToState(InitDriveApi event) async* {
    try {
      if(drive != null && youtube != null) {
        yield DAReady(files: filesCache, selected: selectedFiles);
      } else {
        var httpClient = await _googleAuth(auto: event.auto);
        yield DALoggingIn();
        if(httpClient != null && await _initGoogleApis(httpClient)) {
          filesCache = []; selectedFiles = [];
          yield DAReady(files: filesCache, selected: selectedFiles);
          add(FetchVideoFiles());
        } else if(event.auto) {
          yield DAUninitialized();
        } else {
          yield DAInitializationError();
        }
      }
    } catch(e) {
      print('Error in _mapInitDriveApiToState: $e');
    }
  }

  Future<AutoRefreshingAuthClient> _googleAuth({bool auto = false}) async {
    print('Initializing API');
    BrowserOAuth2Flow flow = await createImplicitBrowserFlow(id, scopes);
    var httpClient = await flow.clientViaUserConsent(immediate: true).catchError((e) async {
      if(auto) {
        print('Auto init failed');
        return null;
      } else {
        print('Immediate login failed! ==> $e');
        print('Try login with popup');
        return await flow.clientViaUserConsent();
      }
    });
    //httpClient.close();
    flow.close();
    return httpClient;
  }

  Future<bool> _initGoogleApis(dynamic httpClient) async {
    try {
      drive = driveV3.DriveApi(httpClient);
      youtube = ytV3.YouTubeApi(httpClient);
      return true;
    } catch(e) {
      print('Error in _initGoogleApis: $e');
      return false;
    }
  }

  Stream<DriveApiState> _mapFetchVideoFilesToState({fromCache = false, fromJson = false}) async* {
    // TODO: check if this ever gets triggered
    if(fromCache && filesCache.length > 0) yield DAReady(files: filesCache, selected: selectedFiles);
    // TODO: load from json shoul only be available for testing purposes (avoid calling DriveApi)
    else if(fromJson) {
      String jsonData = await rootBundle.loadString('dummy_data.json');
      Object objectData = json.decode(jsonData);
      List<VideoFile> files = [];
      for(var e in objectData) {
        VideoFile vFile = new VideoFile(
            id: e['id'],
            name: e['name'],
            path: e['path'].cast<String>(),
            thumbnail: e['thumbnail'],
            driveLink: e['driveLink'],
            size: e['size']
        );
        files.add(vFile);
        filesCache = files;
      }
      yield DAReady(files: filesCache, selected: selectedFiles);
    } else {
      int fileCount = 0;
      yield DAFetching(fileCount: fileCount);
      var driveFiles = await drive.files.list(q: "mimeType contains 'video'", $fields: "files(id, name, parents, thumbnailLink, webViewLink, size)");
      List<VideoFile> files = [];
      for(driveV3.File file in driveFiles.files) {
        var fileJson = file.toJson();
        fileJson['path'] = [];
        await _recursiveParent(fileJson, fileJson['parents'] != null ? fileJson['parents'][0] : null, drive);
        VideoFile vFile = new VideoFile(
          id: fileJson['id'],
          name: fileJson['name'],
          path: fileJson['path'].cast<String>(),
          thumbnail: fileJson['thumbnailLink'],
          driveLink: fileJson['webViewLink'],
          size: fileJson['size']
        );
        files.add(vFile);
        fileCount += 1;
        yield DAFetching(fileCount: fileCount);
      }
      filesCache = files;

      yield DAReady(files: filesCache, selected: selectedFiles);
    }
  }

  Future<void> _recursiveParent(var file, String parentId, driveV3.DriveApi drive) async {
    if(parentId != null) {
      driveV3.File parentFolder = await drive.files.get(parentId, $fields: "id, name, parents");
      file['path'].add(parentFolder.name);
      String nextId = parentFolder.parents != null ? parentFolder.parents[0] : null;
      return await _recursiveParent(file, nextId , drive);
    } else {
      return 1;
    }
  }

  Stream<DriveApiState> _mapDownloadVideoFileToState(DownloadVideoFile event) async* {
    yield DADownloading(fileName: event.fileName);
    try {
      driveV3.Media media = await drive.files.get(event.fileId, downloadOptions: driveV3.DownloadOptions.fullMedia);
      yield DAUploading(fileName: event.fileName);
      print('Current media: ${media.length} bytes');
      /*await drive.files.create(new driveV3.File()..name = event.fileName,
          uploadMedia: media,
          uploadOptions: driveV3.UploadOptions.resumable);*/

      ytV3.VideoSnippet snippet = new ytV3.VideoSnippet();
      snippet.title = event.fileName;
      snippet.description = 'The description';
      snippet.tags = ['tag1', 'tag2'];
      ytV3.VideoStatus status = new ytV3.VideoStatus();
      status.privacyStatus = 'private';
      ytV3.Video video = new ytV3.Video();
      video.snippet = snippet;
      video.status = status;

      await youtube.videos.insert(video, ['snippet', 'status'], uploadMedia: media);
    } catch(e) {
      print('Error in _mapDownloadVideoFileToState: $e');
    }
    selectedFiles = [];
    yield DAReady(files: filesCache, selected: selectedFiles);
    //add(FetchVideoFiles());
  }

  Stream<DriveApiState> _mapUpdateSelectedToState(UpdateSelected event) async* {
    yield DAFetching();
    int find = selectedFiles.indexWhere((id) => id == event.selectedId);
    if(find < 0) selectedFiles.add(event.selectedId);
    else selectedFiles.removeAt(find);
    yield DAReady(files: filesCache, selected: selectedFiles);
  }

  Stream<DriveApiState> _mapBulkSelectToState(BulkSelect event) async* {
    yield DAFetching();
    selectedFiles = [];
    if(event.select) {
      for(VideoFile f in filesCache) selectedFiles.add(f.id);
    }
    yield DAReady(files: filesCache, selected: selectedFiles);
  }

  Stream<DriveApiState> _mapUploadSelectedToState(UploadSelected event) async* {
    int index = 0;
    List<FileProcessingData> processData = _buildProcessing(event.youtubeData);

    for(YoutubeData file in event.youtubeData) {

      processData[index] = processData[index].copyWith(process: utils.Process.downloading);
      yield DAProcessing(
          files: event.youtubeData,
          fileProcessingData: processData,
          activeFileIndex: index);
      print('Downloading ${file.name}...');

      driveV3.Media media;
      try {
        media = await _downloadDriveVideo(file.driveId);
      } catch(e) {
        processData[index] = processData[index].copyWith(
          process: utils.Process.error,
          error: e.toString(),
          displayError: 'Download from Drive failed!'
        );
        yield DAProcessing(
            files: event.youtubeData,
            fileProcessingData: processData,
            activeFileIndex: index);
        break;
      }

      processData[index] = processData[index].copyWith(process: utils.Process.uploading);
      yield DAProcessing(
          files: event.youtubeData,
          fileProcessingData: processData,
          activeFileIndex: index);
      print('Uploading ${file.name}...');

      Map<String, dynamic> uploadResult;
      try {
        uploadResult = await _uploadToYoutube(file, media);
      } catch(e) {
        processData[index] = processData[index].copyWith(
            process: utils.Process.error,
            error: e.toString(),
            displayError: 'Upload to Youtube failed!'
        );
        yield DAProcessing(
            files: event.youtubeData,
            fileProcessingData: processData,
            activeFileIndex: index);
        break;
      }

      if(uploadResult['success'] && file.playListId.length > 0) {
        try {
          await _insertVideoToPlayList(uploadResult['video'].id, file.playListId);
        } catch(e) {
          processData[index] = processData[index].copyWith(
              process: utils.Process.error,
              error: e.toString(),
              displayError: 'Asignation to playlist failed!'
          );
          yield DAProcessing(
              files: event.youtubeData,
              fileProcessingData: processData,
              activeFileIndex: index);
          break;
        }
      }

      processData[index] = processData[index].copyWith(process: utils.Process.completed);
      yield DAProcessing(
          files: event.youtubeData,
          fileProcessingData: processData,
          activeFileIndex: index);
      index += 1;
    }
    selectedFiles = [];
    yield DAReady(files: filesCache, selected: selectedFiles);
  }

  List<FileProcessingData> _buildProcessing(List<YoutubeData> files) {
    List<FileProcessingData> processDataList = [];
    for(YoutubeData file in files) {
      processDataList.add(new FileProcessingData(file.driveId));
    }
    return processDataList;
  }

  Future<driveV3.Media> _downloadDriveVideo(String fileId) async {
    return await drive.files.get(fileId, downloadOptions: driveV3.DownloadOptions.fullMedia);
  }

  Future<Map<String, dynamic>> _uploadToYoutube(YoutubeData youtubeData, driveV3.Media media) async {
    try {
      ytV3.VideoSnippet snippet = new ytV3.VideoSnippet();
      snippet.title = youtubeData.name;
      snippet.description = youtubeData.description;
      snippet.tags = youtubeData.tags;

      ytV3.VideoStatus status = new ytV3.VideoStatus();
      status.privacyStatus = youtubeData.visibility;

      ytV3.Video video = new ytV3.Video();
      video.snippet = snippet;
      video.status = status;

      ytV3.Video uploadedVideo = await youtube.videos.insert(video,
          ['id', 'snippet', 'status'],
          uploadMedia: media,
          uploadOptions: ytV3.UploadOptions.resumable);

      return { 'success': true, 'video': uploadedVideo };
    } catch(e) {
      print('Error while uploading to Youtube. File: ${youtubeData.name}');
      print(e);
      return { 'success': false, 'video': new ytV3.Video() };
    }

  }

  Future<ytV3.PlaylistItem> _insertVideoToPlayList(String videoId, String playListId) async {
    ytV3.PlaylistItem pItem = ytV3.PlaylistItem();
    ytV3.PlaylistItemSnippet pItemSnippet = ytV3.PlaylistItemSnippet();
    pItemSnippet.resourceId = new ytV3.ResourceId();
    pItemSnippet.resourceId.videoId = videoId;
    pItemSnippet.resourceId.kind = 'youtube#video';
    pItemSnippet.playlistId = playListId;
    pItem.snippet = pItemSnippet;
    return await youtube.playlistItems.insert(pItem, ['id, snippet']);
  }

  Future<List<PlayListData>> getUserPlayLists() async {
    List<PlayListData> playlists = [];
    ytV3.PlaylistListResponse userPlaylists = await youtube.playlists.list(['id', 'snippet'], mine: true);
    for(ytV3.Playlist pList in userPlaylists.items) {
      playlists.add(new PlayListData(pList.id, pList.snippet.title));
    }
    return playlists;
  }
}