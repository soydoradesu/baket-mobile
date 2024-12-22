part of '_usecases.dart';

class DeletePostUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final PostRepository postRepository;

  DeletePostUseCase(this.postRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [String? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return postRepository.deletePost(args);
  }
}
