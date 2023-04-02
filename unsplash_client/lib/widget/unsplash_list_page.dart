import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_client/bloc/unsplash_bloc.dart';
import 'package:unsplash_client/bloc/unsplash_event.dart';
import 'package:unsplash_client/bloc/unsplash_state.dart';
import 'package:unsplash_client/widget/unsplash_item.dart';

import '../model/unsplash_image.dart';

class UnsplashListPage extends StatefulWidget {
  UnsplashListPage({Key? key}) : super(key: key);
  final List<UnsplashImage> items = [];

  @override
  State<UnsplashListPage> createState() => _UnsplashListPageState();
}

class _UnsplashListPageState extends State<UnsplashListPage> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  void _loadMore() async {
    final bloc = context.read<UnsplashBloc>();
    if (_controller.position.extentAfter == 0) {
      bloc.add(UnsplashEventLoad());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<UnsplashBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: () => bloc.add(UnsplashEventFirstLoad()),
              child: const Text("Load"),
            ),
            ElevatedButton(
              onPressed: () {
                widget.items.clear();
                bloc.add(UnsplashEventClear());
              },
              child: const Text("Clear"),
            ),
            ElevatedButton(
              onPressed: () => bloc.add(UnsplashEventEmulateError()),
              child: const Text("Get error"),
            ),
          ],
        ),
        BlocBuilder<UnsplashBloc, UnsplashState>(
          builder: (context, UnsplashState state) {
            return _body(
              bloc: bloc,
              state: state,
            );
          },
        ),
      ],
    );
  }

  Widget _body({
    required UnsplashBloc bloc,
    required UnsplashState state,
  }) {
    if (state is UnsplashStateEmpty) {
      return const Center(child: Text("List is empty"));
    }
    if (state is UnsplashStateLoading && state.isFirstLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is UnsplashStateError) {
      return const Center(child: Text("Something went wrong"));
    }
    if (state is UnsplashStateData) {
      widget.items.addAll(state.images);
    }
    return _imageList(
      bloc: bloc,
      images: widget.items,
    );
  }

  Widget _imageList({
    required UnsplashBloc bloc,
    required List<UnsplashImage> images,
  }) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 2));
          bloc.add(UnsplashEventFirstLoad());
        },
        child: ListView.builder(
            itemCount: images.length + 1,
            controller: _controller,
            itemBuilder: (context, index) {
              return index >= images.length
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : UnsplashItem(image: images[index]);
            }),
      ),
    );
  }
}
