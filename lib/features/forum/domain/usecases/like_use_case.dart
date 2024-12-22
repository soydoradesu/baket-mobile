part of '_usecases.dart';

class LikeUseCase implements UseCase<Parsed<Map<String, dynamic>>, LikeParams> {
  final PostRepository postRepository;
  final ReplyRepository replyRepository;

  LikeUseCase(
    this.postRepository,
    this.replyRepository,
  );

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [LikeParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    
    if (args.isPost) return postRepository.like(args);
    return replyRepository.like(args);
  }
}
