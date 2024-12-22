part of '_usecases.dart';

class DeleteReplyUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, String> {
  final ReplyRepository replyRepository;

  DeleteReplyUseCase(this.replyRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [String? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return replyRepository.deleteReply(args);
  }
}
