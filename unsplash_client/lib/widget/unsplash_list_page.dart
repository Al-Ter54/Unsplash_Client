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
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    _textEditingController.dispose();
    super.dispose();
  }

  void _loadMore() async {
    final bloc = context.read<UnsplashBloc>();
    if (_controller.position.extentAfter == 0 && !bloc.endOfResults) {
      if (_textEditingController.text.length > 2) {
        bloc.add(UnsplashEventSearch(_textEditingController.text));
      } else {
        bloc.add(UnsplashEventLoad());
      }
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter a search query',
                  ),
                  controller: _textEditingController,
                  onChanged: (value) {
                    if (value.length >= 2) {
                      widget.items.clear();
                      bloc.add(UnsplashEventFirstSearch(value));
                    } else {
                      bloc.add(UnsplashEventFirstLoad());
                    }
                  },
                ),
              ),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.items.clear();
                  _textEditingController.clear();
                  bloc.add(UnsplashEventFirstLoad());
                },
                child: const Text("Load"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  widget.items.clear();
                  _textEditingController.clear();
                  bloc.add(UnsplashEventClear());
                },
                child: const Text("Clear"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 4.0, left: 4.0, bottom: 8.0),
              child: ElevatedButton(
                onPressed: () => bloc.add(UnsplashEventEmulateError()),
                child: const Text("Get error"),
              ),
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
          if (_textEditingController.text.length > 2) {
            bloc.add(UnsplashEventFirstSearch(_textEditingController.text));
          } else {
            bloc.add(UnsplashEventFirstLoad());
          }
        },
        child: ListView.builder(
            itemCount: images.length + 1,
            controller: _controller,
            itemBuilder: (context, index) {
              if (index >= images.length && !bloc.endOfResults) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if (index >= images.length && bloc.endOfResults) {
                return const ColoredBox(
                  color: Colors.black12,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("End of results"),
                  ),
                );
              } else {
                return UnsplashItem(image: images[index]);
              }
            }),
      ),
    );
  }
}
