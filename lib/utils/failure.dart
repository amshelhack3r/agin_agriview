abstract class Failure implements Exception {
  final String message;
  Failure({this.message});

  bool shouldShow();

  @override
  String toString() => this.message;
}

class ApiException extends Failure {
  final message;
  ApiException(this.message) : super(message: message);

  @override
  bool shouldShow() => false;
}

class MySocketException extends Failure {
  static String get msg => 'Check Internet Connection';

  MySocketException() : super(message: msg);
  @override
  bool shouldShow() => true;
}

class UserFriendlyException extends Failure {
  final message;
  UserFriendlyException(this.message) : super(message: message);

  @override
  bool shouldShow() => true;
}
