import 'package:flutter/cupertino.dart';

class SuccessDialog extends StatelessWidget {
  final String message;
  final VoidCallback onOkPressed;

  const SuccessDialog({super.key, required this.message, required this.onOkPressed});

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: const Text(
        'Success',
        style: TextStyle(color: CupertinoColors.activeGreen),
      ),
      content: Text(message),
      actions: [
        CupertinoDialogAction(
          onPressed: onOkPressed,
          child: Text('OK'),
        ),
      ],
    );
  }
}