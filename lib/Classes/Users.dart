abstract class Users{
  late int id;
  late String username;
  late String password;

  void createUser();
  bool verifyPassword();

}


class Student extends Users{
  late int approval;

  @override
  void createUser(){
    
  }

  @override
  bool verifyPassword(){

    return false;
  }
}