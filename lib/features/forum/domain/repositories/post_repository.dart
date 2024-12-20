part of '_repositories.dart';

abstract class PostRepository {
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getPosts(
    PostParams args,
  );

  Future<Either<Failure, Parsed<Map<String, dynamic>>>> like(
    LikeParams args,
  );
}
