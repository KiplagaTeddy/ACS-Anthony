import 'package:get/get.dart';

class LoginController extends GetxController {
  var username;
  var password;

login(user, pass) {
  username = user;
  password = pass;}
  if(username == 'admin' && password == '12345'){
    return true;
  } else {
    return false;
  }
}