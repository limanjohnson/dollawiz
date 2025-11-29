import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});


  Future<String?> _authUser(LoginData data) async {
    return null;
  }

  Future<String?> _recoverPassword(String email) async {
    return null;
  }

  Future<String?> _signupUser(SignupData data) async {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
        onLogin: _authUser,
        onRecoverPassword: _recoverPassword,
        onSignup: _signupUser,
        theme: LoginTheme(
          primaryColor: Color(0xFF627d59),
          cardTheme: CardTheme(
            color: Color(0xFFFFFFFF),
            elevation: 15,
          ),
          buttonTheme: LoginButtonTheme(
            backgroundColor: Color(0xFF627d59),
          )
        ) ,
    );
  }
}

