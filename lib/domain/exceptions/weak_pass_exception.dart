



class WeakPassException implements Exception{

  @override
  String toString() {
    return 'The password provided is too weak.';
  }
}