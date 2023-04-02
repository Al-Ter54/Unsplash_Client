import 'package:unsplash_client/bloc/unsplash_event.dart';
import 'package:unsplash_client/bloc/unsplash_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unsplash_client/service/unsplash_service.dart';

class UnsplashBloc extends Bloc<UnsplashEvent, UnsplashState> {
  UnsplashBloc({
    required this.service,
  }) : super(UnsplashStateEmpty()) {
    on<UnsplashEventInit>(_onInit);
    on<UnsplashEventFirstLoad>(_onFirstLoad);
    on<UnsplashEventLoad>(_onLoad);
    on<UnsplashEventFirstSearch>(_onFirstSearch);
    on<UnsplashEventSearch>(_onSearch);
    on<UnsplashEventClear>(_onClear);
    on<UnsplashEventEmulateError>(_onEmulateError);
  }

  final UnsplashService service;
  bool endOfResults = false;

  Future<void> _onInit(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    emit(UnsplashStateEmpty());
  }

  Future<void> _onFirstLoad(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    try {
      emit(UnsplashStateLoading(true));
      final images = await service.getFirst();
      if(images.isEmpty){
        emit(UnsplashStateEmpty());
      } else {
        endOfResults = false;
        emit(UnsplashStateData(images));
      }
    } catch (_) {
      emit(UnsplashStateError());
    }
  }

  Future<void> _onLoad(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    try {
      emit(UnsplashStateLoading(false));
      await Future.delayed(const Duration(seconds: 2));
      final images = await service.getNext();
      if(images.isEmpty){
        endOfResults = true;
      }
        emit(UnsplashStateData(images));
    } catch (_) {
      emit(UnsplashStateError());
    }
  }

  Future<void> _onFirstSearch(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    try {
      emit(UnsplashStateLoading(true));
      final images = await service.getFirstSearch(
        query: (event as UnsplashEventFirstSearch).query,
      );
      if(images.isEmpty){
        emit(UnsplashStateEmpty());
      } else {
        endOfResults = false;
        emit(UnsplashStateData(images));
      }
    } catch (_) {
      emit(UnsplashStateError());
    }
  }

  Future<void> _onSearch(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    try {
      emit(UnsplashStateLoading(false));
      await Future.delayed(const Duration(seconds: 2));
      final images = await service.getNextSearch(
        query: (event as UnsplashEventSearch).query,
      );
      if(images.isEmpty){
        endOfResults = true;
      }
      emit(UnsplashStateData(images));
    } catch (_) {
      emit(UnsplashStateError());
    }
  }

  Future<void> _onClear(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    try {
      endOfResults = false;
      emit(UnsplashStateLoading(true));
      emit(UnsplashStateEmpty());
    } catch (_) {
      emit(UnsplashStateError());
    }
  }

  Future<void> _onEmulateError(
    UnsplashEvent event,
    Emitter<UnsplashState> emit,
  ) async {
    emit(UnsplashStateError());
  }
}
