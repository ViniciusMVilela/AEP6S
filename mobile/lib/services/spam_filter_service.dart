import 'dart:convert';
import 'package:http/http.dart' as http;

class SpamFilterService {
  static const String _apiUrl = 'https://eu.altcha.org/api/v1/classify?apiKey=key_1jiqcn4euRgJnfHkKMFBd';

  static Future<Map<String, dynamic>> checkSpam({required String email, required String text}) async {
    final requestData = {
      "email": email,
      "text": text,
      "ipAddress": "auto",
      "timeZone": "Europe/London"
    };

    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestData),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"classification": "Erro na classificação", "score": 0.0};
      }
    } catch (e) {
      return {"classification": "Erro na classificação", "score": 0.0};
    }
  }
}
