abstract class Failure implements Exception {
  final Map<String, dynamic> message;
  Failure({this.message});

  bool shouldShow();

  @override
  String toString() => "${this.runtimeType.toString()}: $message";
}

class ApiException extends Failure {
  final message;
  ApiException(this.message) : super(message: message);

  @override
  bool shouldShow() => false;
}

class MySocketException extends Failure {
  static Map get msg => {'status': 500, 'message': 'Check Internet Connection'};

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
