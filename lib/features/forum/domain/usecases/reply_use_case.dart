part of '_usecases.dart';

class ReplyUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, ReplyParams> {
  final ReplyRepository replyRepository;

  ReplyUseCase(this.replyRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [ReplyParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return replyRepository.getReplies(args);
  }
}
