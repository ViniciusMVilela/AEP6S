import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/component/dialog/error_dialog.dart';
import 'dart:convert';

import 'package:mobile/model/user.dart';
import 'package:mobile/screens/forgot_password_screen.dart';
import 'package:mobile/screens/register.screen.dart';
import 'package:mobile/screens/spam_filter_screen.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> login() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'login': _loginController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _navigateToResultScreen(response);
      } else {
        _handleError(response);
      }
    } catch (e) {
      _showErrorDialog('Erro ao conectar ao servidor. Tente novamente mais tarde.');
    }
  }

  void _navigateToResultScreen(http.Response response) {
    final responseData = json.decode(response.body);
    final token = responseData['token'];
    final user = User.fromJson(responseData['users']);

    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => SpamFilterScreen(),
      ),
    );
  }

  void _handleError(http.Response response) {
    final responseData = json.decode(response.body);
    _showErrorDialog(responseData['error'] ?? 'Falha no login. Verifique suas credenciais.');
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => ErrorDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Login'),
      ),
      child: Stack(
        children: [
          Container(color: CupertinoColors.systemBackground),
          Container(
            padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 20),
                CupertinoTextField(
                  controller: _loginController,
                  keyboardType: TextInputType.emailAddress,
                  placeholder: "E-mail or Username",
                  padding: const EdgeInsets.all(16),
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  placeholder: "Password",
                  padding: const EdgeInsets.all(16),
                ),
                Container(
                  height: 55,
                  alignment: Alignment.centerRight,
                  child: CupertinoButton(
                    child: const Text("Forgot password?"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ForgotPasswordScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton.filled(
                    onPressed: login,
                    child: Center(
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 60,
                  alignment: Alignment.centerLeft,
                  child: CupertinoButton(
                    color: CupertinoColors.systemGrey,
                    onPressed: _navigateToRegisterScreen,
                    child: Center(
                      child: Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CupertinoColors.black,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToRegisterScreen() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}