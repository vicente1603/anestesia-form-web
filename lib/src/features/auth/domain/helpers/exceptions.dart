class BlockedUserException implements Exception {
  final String message;
  BlockedUserException([this.message = 'Usuário bloqueado']);
  @override
  String toString() => message;
}

class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'Usuário não encontrado']);
  @override
  String toString() => message;
}

class WrongPasswordException implements Exception {
  final String message;
  WrongPasswordException([this.message = 'Senha incorreta']);
  @override
  String toString() => message;
}
