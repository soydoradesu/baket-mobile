part of '_repositories.dart';

class PostRepositoryImpl extends PostRepository {
  final PostRemoteDataSourceImpl postRemoteDataSource;

  PostRepositoryImpl(this.postRemoteDataSource);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> getPosts(
    PostParams args,
  ) async {
    return apiCall(postRemoteDataSource.getPost(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> like(
    LikeParams args,
  ) async {
    return apiCall(postRemoteDataSource.like(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> addPost(
    ManagePostParams args,
  ) async {
    return apiCall(postRemoteDataSource.addPost(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> editPost(
    ManagePostParams args,
  ) async {
    return apiCall(postRemoteDataSource.editPost(args));
  }

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> deletePost(
    String args,
  ) async {
    return apiCall(postRemoteDataSource.deletePost(args));
  }
}
