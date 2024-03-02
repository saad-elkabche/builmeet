




class EmailAlreadyInUse implements Exception{


  @override
  String toString() {
    return 'email_exist';
  }
}