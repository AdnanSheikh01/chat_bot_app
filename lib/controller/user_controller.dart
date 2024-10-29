import 'package:get/get.dart';

class UserController extends GetxController {
  var userFullName = ''.obs;
  var userEmail = ''.obs;

  void setUserDetails(String fullName, String email) {
    userFullName.value = fullName;
    userEmail.value = email;
  }
}
