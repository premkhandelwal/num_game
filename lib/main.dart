import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:num_game/bloc/activity_bloc.dart';
import 'package:num_game/repositories/activity_repo.dart';
import 'package:num_game/screen/home_page.dart';

void main() {
  runApp( MyApp(activityRepo: ActivityRepo(),));
}

class MyApp extends StatelessWidget {
  final ActivityRepo activityRepo;
  const MyApp({
    Key? key,
    required this.activityRepo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers:[ BlocProvider(
      create:    (context) => ActivityBloc(activityRepo: activityRepo))],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
