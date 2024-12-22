part of '_repositories.dart';

class ReplyRepositoryImpl extends ReplyRepository {
  final ReplyRemoteDataSourceImpl replyRemoteDataSourceImpl;

  ReplyRepositoryImpl(this.replyRemoteDataSourceImpl);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getReplies(
    ReplyParams args,
  ) async {
    return apiCall(replyRemoteDataSourceImpl.getReply(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> like(
    LikeParams args,
  ) async {
    return apiCall(replyRemoteDataSourceImpl.like(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> addReply(
    ManageReplyParams args,
  ) async {
    return apiCall(replyRemoteDataSourceImpl.addReply(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> deleteReply(
    String args,
  ) async {
    return apiCall(replyRemoteDataSourceImpl.deleteReply(args));
  }
}

