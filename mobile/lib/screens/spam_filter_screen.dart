import 'package:flutter/material.dart';
import '../services/spam_filter_service.dart';

class SpamFilterScreen extends StatefulWidget {
  const SpamFilterScreen({super.key});

  @override
  _SpamFilterScreenState createState() => _SpamFilterScreenState();
}

class _SpamFilterScreenState extends State<SpamFilterScreen> {
  final _emailController = TextEditingController();
  final _textController = TextEditingController();
  String _classification = '';
  double _score = 0.0;
  bool _isLoading = false;

  Future<void> _checkSpam() async {
    setState(() => _isLoading = true);

    final result = await SpamFilterService.checkSpam(
      email: _emailController.text,
      text: _textController.text,
    );

    setState(() {
      _classification = result['classification'] ?? 'Erro';
      _score = result['score']?.toDouble() ?? 0.0;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phishing Email Filter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: const InputDecoration(labelText: 'Email Body'),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _checkSpam,
                    child: const Text('Classify as Phishing Email'),
                  ),
            const SizedBox(height: 16.0),
            Text(
              'Classificação: $_classification\nScore: $_score',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
