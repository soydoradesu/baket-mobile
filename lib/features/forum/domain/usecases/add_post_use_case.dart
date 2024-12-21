part of '_usecases.dart';

class AddPostUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, AddPostParams> {
  final PostRepository postRepository;

  AddPostUseCase(this.postRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [AddPostParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return postRepository.addPost(args);
  }
}
