part of '_usecases.dart';

class EditPostUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, ManagePostParams> {
  final PostRepository postRepository;

  EditPostUseCase(this.postRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [ManagePostParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return postRepository.editPost(args);
  }
}
