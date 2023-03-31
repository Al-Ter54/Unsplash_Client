import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_client/bloc/unsplash_bloc.dart';
import 'package:unsplash_client/bloc/unsplash_event.dart';
import 'package:unsplash_client/bloc/unsplash_state.dart';
import 'package:unsplash_client/widget/unsplash_item.dart';

import '../model/unsplash_image.dart';

class UnsplashListPage extends StatelessWidget {
  const UnsplashListPage({Key? key}) : super(key: key);

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
              onPressed: () => bloc.add(UnsplashEventClear()),
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
    switch (state.runtimeType) {
      case UnsplashStateEmpty:
        return const Center(child: Text("List is empty"));
      case UnsplashStateLoading:
        return const Center(child: CircularProgressIndicator());
      case UnsplashStateError:
        return const Center(child: Text("Something went wrong"));
      case UnsplashStateData:
        return _imageList(
          bloc: bloc,
          images: (state as UnsplashStateData).images,
        );
      default:
        return const Text("Wrong state detected?");
    }
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
            itemCount: images.length,
            itemBuilder: (context, index) {
              return UnsplashItem(image: images[index]);
            }),
      ),
    );
  }
}
