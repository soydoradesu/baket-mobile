part of '_usecases.dart';

class AddReplyUseCase
    implements UseCase<Parsed<Map<String, dynamic>>, ManageReplyParams> {
  final ReplyRepository replyRepository;

  AddReplyUseCase(this.replyRepository);

  @override
  Future<Either<Failure, Parsed<Map<String, dynamic>>>> execute(
      [ManageReplyParams? args]) async {
    if (args == null) return Left(ArgumentFailure());
    return replyRepository.addReply(args);
  }
}
