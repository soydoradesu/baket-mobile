abstract class Failure implements Exception {
  Failure({
    this.title,
    this.code,
    this.message,
  });

  String? title;

  /// provide error status code
  String? code;

  /// error message
  String? message;
}

class NetworkFailure extends Failure {
  NetworkFailure({
    super.code,
    super.message,
  }) : super(
          title: 'Network Failure',
        );
}

class NotFoundFailure extends Failure {
  NotFoundFailure({
    super.code,
    super.message,
  }) : super(
          title: 'Not Found Failure',
        );
}

class BadRequestFailure extends Failure {
  BadRequestFailure({
    super.code,
    super.message,
  }) : super(
          title: 'Bad Request Failure',
        );
}

class GeneralFailure extends Failure {
  GeneralFailure({
    super.message,
  }) : super(
          title: 'General Failure',
        );
}

class TimeoutFailure extends Failure {
  TimeoutFailure({
    super.message,
  }) : super(
          title: 'Timeout Failure',
        );
}

class ArgumentFailure extends Failure {
  ArgumentFailure({
    super.message,
  }) : super(
          title: 'Argument Failure',
        );
}

class UnAuthorizeFailure extends Failure {
  UnAuthorizeFailure({
    super.message,
  }) : super(
          title: 'UnAuthorize Failure',
        );
}

class ParseFailure extends Failure {}

class EmptyFailure extends Failure {}
