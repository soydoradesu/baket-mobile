part of '_datasources.dart';

abstract class PostRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> getPost(PostParams args);
}

class PostRemoteDataSourceImpl extends PostRemoteDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> getPost(PostParams args) async {
    final uri = Uri.parse(
      '${args.url}?q=${args.query}&limit=${args.limit}&page=${args.page}',
    );

    dynamic response = await args.request.get(uri.toString());

    if (response['results'] == null) {
      throw response['detail'] ?? response.toString();
    }

    List<PostModel> posts = [];

    for (var i = 0; i < response['results'].length; i++) {
      posts.add(PostModel.fromJson(response['results'][i]));
    }

    response['results'] = posts;

    return Parsed.fromDynamicData(
      200,
      response,
    );
  }
}
