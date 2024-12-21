part of '_repositories.dart';

class PostRepositoryImpl extends PostRepository {
  final PostRemoteDataSourceImpl postRemoteDataSource;

  PostRepositoryImpl(this.postRemoteDataSource);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getPosts(
      PostParams args) async {
    return apiCall(postRemoteDataSource.getPost(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>>
      like(LikeParams args) async {
    return apiCall(postRemoteDataSource.like(args));
  }
}
