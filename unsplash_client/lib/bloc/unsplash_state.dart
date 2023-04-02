import '../model/unsplash_image.dart';

abstract class UnsplashState {}

class UnsplashStateEmpty extends UnsplashState {}

class UnsplashStateLoading extends UnsplashState {
  final bool isFirstLoading;

  UnsplashStateLoading(this.isFirstLoading);
}

class UnsplashStateData extends UnsplashState {
  UnsplashStateData(this.images);

  final List<UnsplashImage> images;
}

class UnsplashStateError extends UnsplashState {}
