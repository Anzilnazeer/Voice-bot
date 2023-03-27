import 'dart:convert';

import 'package:http/http.dart' as http;

const apiKey = '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';
const baseUrl = 'https://api.openai.com/v1/completions';

Map<String, String> headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer $apiKey'
};

class Api {
  static sendMessage(String? message) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: headers,
      body: jsonEncode(
        {
          "model": "text-davinci-003",
          "prompt": "$message",
          "temperature": 0.9,
          "max_tokens": 150,
          "top_p": 1,
          "frequency_penalty": 0.0,
          "presence_penalty": 0.6,
          "stop": ["Human:", "AI:"]
        },
      ),
    );
    if (res.statusCode == 201) {
      var data = jsonDecode(res.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      print(res.body);
    }
  }
}
