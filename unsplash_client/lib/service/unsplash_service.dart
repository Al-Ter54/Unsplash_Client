import 'package:dio/dio.dart';
import 'package:unsplash_client/model/unsplash_image.dart';

class UnsplashService {
  UnsplashService();

  final dio = Dio();
  final baseUrl = "https://api.unsplash.com";
  final accessKey = "a3A8bX6fV-2ha3E3SU7sCSNaYvsOr6w0OXCRwNTh1eo";
  final secretKey = "swcuS4mz8qF1C08Qf7LbblkWQM-xWjw_Mh3cGgLbwKA";
  final pageCount = 10;
  int page = 1;

  Future<List<UnsplashImage>> _getList() async {
    final List<UnsplashImage> images = [];
    final response = await dio.get(
      "$baseUrl/photos",
      queryParameters: {
        "client_id": accessKey,
        "page": page,
        "per_page": pageCount
      },
    );
    if (response.statusCode == 200) {
      final data = response.data;
      for (var json in data) {
        images.add(UnsplashImage.fromJson(json));
      }
    }
    return images;
  }

  Future<List<UnsplashImage>> _getSearchList({query = ''}) async {
    final List<UnsplashImage> images = [];
    final response = await dio.get(
      "$baseUrl/search/photos",
      queryParameters: {
        "client_id": accessKey,
        "page": page,
        "per_page": pageCount,
        "query": query,
      },
    );
    if(response.statusCode == 200){
      final data = response.data;
      for (var json in data["results"]) {
        images.add(UnsplashImage.fromJson(json));
      }
    }
    return images;
  }

  Future<List<UnsplashImage>> getNext() async {
    ++page;
    return _getList();
  }

  Future<List<UnsplashImage>> getFirst() async {
    page = 1;
    return _getList();
  }

  Future<List<UnsplashImage>> getNextSearch({query = ''}) async {
    ++page;
    return _getSearchList(query: query);
  }

  Future<List<UnsplashImage>> getFirstSearch({query = ''}) async {
    page = 1;
    return _getSearchList(query: query);
  }
}
