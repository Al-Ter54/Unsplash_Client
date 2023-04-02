import 'package:flutter/material.dart';
import 'package:unsplash_client/model/unsplash_image.dart';

import 'full_screen_image.dart';

class UnsplashItem extends StatelessWidget {
  const UnsplashItem({Key? key, required this.image}) : super(key: key);
  final UnsplashImage image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: FullScreenImage(
            disposeLevel: DisposeLevel.low,
            child: Hero(tag: 'hero-image-${image.id}',
            child: Image.network(image.urls?.small ?? "")),
          ),
        ),
      ),
    );
  }
}
