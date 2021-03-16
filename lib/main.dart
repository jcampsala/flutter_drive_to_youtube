import 'package:drive_to_youtube/blocs/drive_api/drive_api_bloc.dart';
import 'package:drive_to_youtube/blocs/drive_api/drive_api_event.dart';
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
      home: BlocProvider(
        create: (context) => DriveApiBloc()..add(InitDriveApi(auto: true)),
        child: FileGrid(),
      )
    );
  }
}
