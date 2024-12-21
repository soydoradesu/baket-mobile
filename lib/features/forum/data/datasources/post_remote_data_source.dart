part of '_datasources.dart';

abstract class PostRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> getPost(PostParams args);
  Future<Parsed<Map<String, dynamic>>> like(LikeParams args);
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

    LoggerService.i(response['results'].toString());

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

  @override
  Future<Parsed<Map<String, dynamic>>> like(LikeParams args) async {
    final uri = Uri.parse('${args.url}/${args.uuid}');

    dynamic response = await args.request.postJson(
      uri.toString(),
      '',
    );

    LoggerService.i(response.toString());

    if (response['status'] != 'Successfully liked' &&
        response['status'] != 'Successfully unliked') {
      throw response['detail'] ?? response.toString();
    }

    return Parsed.fromDynamicData(
      200,
      response,
    );
  }
}
