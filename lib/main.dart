import 'package:drive_to_youtube/blocs/drive_api/drive_api_bloc.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_event.dart';
import 'package:drive_to_youtube/blocs/upload_manager/upload_manager_barrel.dart';
import 'package:drive_to_youtube/file_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drive to Youtube',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DriveApiBloc>(
            create: (context) => DriveApiBloc()..add(InitDriveApi(auto: true)),
          ),
          BlocProvider<UploadManagerBloc>(
            create: (context) => UploadManagerBloc(),
          )
        ],
        child: FileGrid(),
      )
    );
  }
}
