import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/Models/UserModel.dart';
import 'package:flutter_application_1/Resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  UserModel? _user;
  final AuthMethods _authMethods = AuthMethods();

  UserModel? get getUser => _user;

  Future<void> refreshUser() async {
    UserModel user = await _authMethods.getUserDetails();
    _user = user;
    notifyListeners();
  }
}
