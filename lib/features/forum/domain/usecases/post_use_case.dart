part of '_usecases.dart';

class PostUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, PostParams> {
  final PostRepository postRepository;

  PostUseCase(this.postRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [PostParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return postRepository.get(args);
  }
}
