




class WrongPassword implements Exception{

  @override
  String toString() {
    return 'Wrong password provided for that user.';
  }
}