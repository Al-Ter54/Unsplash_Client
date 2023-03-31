import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_client/bloc/unsplash_bloc.dart';
import 'package:unsplash_client/service/unsplash_service.dart';
import 'package:unsplash_client/widget/unsplash_list_page.dart';

void main() {
  runApp(
    MyApp(
      service: UnsplashService(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.service});

  final UnsplashService service;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<UnsplashBloc>(
      create: (_) => UnsplashBloc(service: service),
      child: MaterialApp(
        title: 'Unsplash Client',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Unsplash Client'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: UnsplashListPage(),
    );
  }
}
