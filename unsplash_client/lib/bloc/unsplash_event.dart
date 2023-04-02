abstract class UnsplashEvent {}

class UnsplashEventInit extends UnsplashEvent {}

class UnsplashEventFirstLoad extends UnsplashEvent {}

class UnsplashEventLoad extends UnsplashEvent {}

class UnsplashEventFirstSearch extends UnsplashEvent {
  final String query;

  UnsplashEventFirstSearch(this.query);
}

class UnsplashEventSearch extends UnsplashEvent {
  final String query;

  UnsplashEventSearch(this.query);
}

class UnsplashEventClear extends UnsplashEvent {}

class UnsplashEventEmulateError extends UnsplashEvent {}
