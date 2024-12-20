part of '_repositories.dart';

abstract class PostRepository {
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> get(PostParams args);
}
