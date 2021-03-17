import 'package:bloc/bloc.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_event.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_state.dart';
import 'package:drive_to_youtube/models/video_file.dart';
import 'package:googleapis/drive/v3.dart' as driveV3;
import 'package:googleapis/youtube/v3.dart' as ytV3;
import 'package:googleapis_auth/auth_browser.dart';

class DriveApiBloc extends Bloc<DriveApiEvent, DriveApiState> {
  final ClientId id = ClientId('515168489445-t91kf9hih4vfh26eqbn5r9bebd30gln1.apps.googleusercontent.com', '8WZqw16s-YwcrfKGuUe7woS2');
  final List<String> scopes = [driveV3.DriveApi.driveScope, ytV3.YouTubeApi.youtubeUploadScope];
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
    }
  }

  Stream<DriveApiState> _mapInitDriveApiToState(InitDriveApi event) async* {
    try {
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

  Stream<DriveApiState> _mapFetchVideoFilesToState({fromCache = false}) async* {
    if(fromCache && filesCache.length > 0) yield DAReady(files: filesCache, selected: selectedFiles);
    else {
      int fileCount = 0;
      yield DAFetching(fileCount: fileCount);
      var driveFiles = await drive.files.list(q: "mimeType contains 'video'", $fields: "files(id, name, parents, thumbnailLink, webViewLink)");
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
            driveLink: fileJson['webViewLink']
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
}