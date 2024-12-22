part of '_datasources.dart';

abstract class PostRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> getPost(PostParams args);
  Future<Parsed<Map<String, dynamic>>> like(LikeParams args);
  Future<Parsed<Map<String, dynamic>>> addPost(ManagePostParams args);
  Future<Parsed<Map<String, dynamic>>> editPost(ManagePostParams args);
  Future<Parsed<Map<String, dynamic>>> deletePost(String args);
}

class PostRemoteDataSourceImpl extends PostRemoteDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> getPost(PostParams args) async {
    final uri = Uri.parse(
      '${args.url}?q=${args.query}&limit=${args.limit}&page=${args.page}',
    );

    LoggerService.i(uri.toString());

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

    LoggerService.i(uri.toString());

    dynamic response = await args.request.postJson(
      uri.toString(),
      '',
    );

    if (response['status'] != 'Successfully liked' &&
        response['status'] != 'Successfully unliked') {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response.toString());

    return Parsed.fromDynamicData(
      201,
      response,
    );
  }

  @override
  Future<Parsed<Map<String, dynamic>>> addPost(ManagePostParams args) async {
    final uri = Uri.parse(args.url);

    LoggerService.i(uri.toString());

    final body = {
      'content': args.content,
    };

    if (args.image != null) {
      final bytes = await args.image!.readAsBytes();
      final base64Image = base64Encode(bytes);
      body['image'] = '$base64Image.${args.image!.path.split('.').last}';
    }

    dynamic response = await args.request.postJson(
      uri.toString(),
      jsonEncode(body),
    );

    if (response['status'] != 'Successfully added post') {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response.toString());

    return Parsed.fromDynamicData(
      201,
      response,
    );
  }

  @override
  Future<Parsed<Map<String, dynamic>>> editPost(ManagePostParams args) async {
    final uri = Uri.parse(args.url);

    LoggerService.i(uri.toString());

    final body = {
      'content': args.content,
    };

    if (args.image != null) {
      if (args.image!.path.isEmpty) {
        body['image'] = 'null';
      } else {
        final bytes = await args.image!.readAsBytes();
        final base64Image = base64Encode(bytes);
        body['image'] = '$base64Image.${args.image!.path.split('.').last}';
      }
    }

    dynamic response = await args.request.postJson(
      uri.toString(),
      jsonEncode(body),
    );

    if (response['status'] != 'Successfully updated post') {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response.toString());

    return Parsed.fromDynamicData(
      201,
      response,
    );
  }

  @override
  Future<Parsed<Map<String, dynamic>>> deletePost(String args) async {
    final uri = Uri.parse('${Endpoints.deletePost}/$args');

    LoggerService.i(uri.toString());

    dynamic response = await CookieRequest().post(
      uri.toString(),
      '',
    );

    if (response['status'] != 'Successfully deleted post') {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response.toString());

    return Parsed.fromDynamicData(
      204,
      response,
    );
  }
}
