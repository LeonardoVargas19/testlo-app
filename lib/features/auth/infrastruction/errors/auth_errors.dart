class WrongCredentials implements Exception {}

class InvalidToken implements Exception {}
class ConnectionTimeout implements Exception {}
class CustomErro implements Exception {
  final String messages;
  final int errorCode;

  CustomErro( this.messages,  this.errorCode);
  

}
