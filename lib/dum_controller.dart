import 'package:get/get.dart';

class UserController extends GetxController {
  var fullName = ''.obs;
  var email = ''.obs;

  void setUser(String name, String emailAddress) {
    fullName.value = name;
    email.value = emailAddress;
  }
}