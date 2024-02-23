


class RequiresRecentLoginException implements Exception{
  @override
  String toString() {

    return 'this action requires a recent login\ntry to logout and relogin again';
  }
}