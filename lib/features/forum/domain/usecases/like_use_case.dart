part of '_usecases.dart';

class LikeUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, LikeParams> {
  final PostRepository postRepository;

  LikeUseCase(this.postRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [LikeParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return postRepository.like(args);
  }
}
