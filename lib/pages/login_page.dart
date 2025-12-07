import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import '../services/auth_service.dart';
import 'dashboard_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final AuthService _authService = AuthService();

  Future<String?> _authUser(LoginData data) async {
    try {
      await _authService.signIn(
        email: data.name,
        password: data.password,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Login failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      if (data.name == null || data.password == null) {
        return 'Email and password are required';
      }
      await _authService.signUp(
        email: data.name!,
        password: data.password!,
      );
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Signup failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      await _authService.resetPassword(email);
      return null; // Success
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Password reset failed';
    } catch (e) {
      return e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _authUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const DashboardPage()),
        );
      },
      theme: LoginTheme(
        primaryColor: const Color(0xFF579C79),
        cardTheme: const CardTheme(
          color: Color(0xFFFFFFFF),
          elevation: 15,
        ),
        buttonTheme: const LoginButtonTheme(
          backgroundColor: Color(0xFF579C79),
        ),
      ),
    );
  }
}
