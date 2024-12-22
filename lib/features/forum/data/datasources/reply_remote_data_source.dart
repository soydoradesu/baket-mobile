part of '_datasources.dart';

abstract class ReplyRemoteDataSource {
  Future<Parsed<Map<String, dynamic>>> getReply(ReplyParams args);
  Future<Parsed<Map<String, dynamic>>> like(LikeParams args);
  Future<Parsed<Map<String, dynamic>>> addReply(ManageReplyParams args);
  Future<Parsed<Map<String, dynamic>>> deleteReply(String args);
}

class ReplyRemoteDataSourceImpl extends ReplyRemoteDataSource {
  @override
  Future<Parsed<Map<String, dynamic>>> getReply(ReplyParams args) async {
    final uri = Uri.parse(
      '${args.url}/${args.postId}?limit=${args.limit}&page=${args.page}',
    );

    LoggerService.i(uri.toString());

    dynamic response = await args.request.get(uri.toString());

    if (response['results'] == null) {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response['results'].toString());

    List<ReplyModel> replies = [];

    for (var i = 0; i < response['results'].length; i++) {
      replies.add(ReplyModel.fromJson(response['results'][i]));
    }

    response['results'] = replies;

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
  Future<Parsed<Map<String, dynamic>>> addReply(ManageReplyParams args) async {
    final uri = Uri.parse(args.url);

    LoggerService.i(uri.toString());

    dynamic response = await args.request.postJson(
      uri.toString(),
      jsonEncode({
        'content': args.content,
        'post_id': args.postId,
      }),
    );

    if (response['status'] != 'Successfully added reply') {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response.toString());

    return Parsed.fromDynamicData(
      201,
      response,
    );
  }

  @override
  Future<Parsed<Map<String, dynamic>>> deleteReply(String args) async {
    final uri = Uri.parse('${Endpoints.deleteReply}/$args');

    LoggerService.i(uri.toString());

    dynamic response = await CookieRequest().post(
      uri.toString(),
      '',
    );

    if (response['status'] != 'Successfully deleted reply') {
      throw response['detail'] ?? response.toString();
    }

    LoggerService.i(response.toString());

    return Parsed.fromDynamicData(
      204,
      response,
    );
  }
}
