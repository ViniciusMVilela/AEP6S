import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spam Filter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SpamFilterScreen(),
    );
  }
}

class SpamFilterScreen extends StatefulWidget {
  @override
  _SpamFilterScreenState createState() => _SpamFilterScreenState();
}

class _SpamFilterScreenState extends State<SpamFilterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  String _classification = '';
  double _score = 0.0;
  bool _isLoading = false;

  Future<void> _checkSpam() async {
    setState(() {
      _isLoading = true;
    });

    // Dados para a requisição
    String apiUrl = 'https://eu.altcha.org/api/v1/classify?apiKey=key_1jiqcn4euRgJnfHkKMFBd';
    Map<String, dynamic> requestData = {
      "email": _emailController.text,
      "text": _textController.text,
      "ipAddress": "auto",
      "timeZone": "Europe/London" // substitua pelo fuso horário atual
    };

    // Envia a requisição POST para a API
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: json.encode(requestData),
    );

    // Processa a resposta
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      setState(() {
        _classification = responseData['classification'];
        _score = responseData['score'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _classification = 'Erro na classificação';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtro de Spam ALTCHA'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email para classificar (opcional)',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                labelText: 'Texto para classificar',
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.0),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _checkSpam,
                    child: Text('Classificar como Spam'),
                  ),
            SizedBox(height: 16.0),
            Text(
              'Classificação: $_classification\nScore: $_score',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
