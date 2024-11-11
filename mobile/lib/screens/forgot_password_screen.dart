import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:mobile/component/dialog/error_dialog.dart';
import 'package:mobile/screens/reset_password.screen.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  Future<void> sendResetEmail() async {
    final url = Uri.parse('http://192.168.0.24:8585/auth/forgot-password?email=${_emailController.text.trim()}');
    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ResetPasswordScreen(email: _emailController.text.trim()),
          ),
        );
      } else {
        showCupertinoDialog(
          context: context,
          builder: (context) => ErrorDialog(
            message: 'Erro ao enviar email de recuperação.',
          ),
        );
      }
    } catch (e) {
      showCupertinoDialog(
        context: context,
        builder: (context) => ErrorDialog(
          message: 'Erro ao conectar ao servidor. Tente novamente mais tarde.',
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Recover Password'),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              placeholder: "E-mail",
              padding: const EdgeInsets.all(16),
            ),
            const SizedBox(height: 20),
            CupertinoButton.filled(
              onPressed: sendResetEmail,
              child: Text("Send password recovery email"),
            ),
          ],
        ),
      ),
    );
  }
}