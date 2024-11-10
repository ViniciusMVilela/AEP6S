import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import '../lib/services/spam_filter_service.dart';

void main() {
  final dio = Dio();
  final dioAdapter = DioAdapter(dio: dio);
  const url = 'https://eu.altcha.org/api/v1/classify?apiKey=key_1jiqcn4euRgJnfHkKMFBd';

  group('SpamFilterService', () {
    test('Retorna classificação de spam com sucesso', () async {
      final expectedResponse = {"classification": "Not Spam", "score": 0.1};
      
      dioAdapter.onPost(
        url,
        (request) => request.reply(200, expectedResponse),
        data: {
          "email": "teste@exemplo.com",
          "text": "This is a test message",
          "ipAddress": "auto",
          "timeZone": "Europe/London"
        },
      );

      final result = await SpamFilterService.checkSpam(
        email: "teste@exemplo.com",
        text: "This is a test message",
      );

      expect(result, expectedResponse);
    });

    test('Retorna erro de classificação ao lançar exceção', () async {
      dioAdapter.onPost(
        url,
        (request) => request.throws(
          500,
          DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(path: url),
              statusCode: 500,
            ),
          ),
        ),
        data: {
          "email": "teste@exemplo.com",
          "text": "This is a test message",
          "ipAddress": "auto",
          "timeZone": "Europe/London"
        },
      );

      final result = await SpamFilterService.checkSpam(
        email: "teste@exemplo.com",
        text: "This is a test message",
      );

      expect(result, {"classification": "Erro na classificação", "score": 0.0});
    });
  });
}
