part of '_repositories.dart';

abstract class ReplyRepository {
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getReplies(
    ReplyParams args,
  );

  Future<Either<Failure, Parsed<Map<String, dynamic>>>> like(
    LikeParams args,
  );

  Future<Either<Failure, Parsed<Map<String, dynamic>>>> addReply(
    ManageReplyParams args,
  );

  Future<Either<Failure, Parsed<Map<String, dynamic>>>> deleteReply(
    String args,
  );
}
