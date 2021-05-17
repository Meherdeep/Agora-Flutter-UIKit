import 'dart:convert';

import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgoraTokens extends ValueNotifier<AgoraTokens> {
  AgoraTokens({
    String baseUrl,
    String channelName,
  }) : super(null) {
    getToken(baseUrl, channelName);
  }

  Future<void> getToken(String baseUrl, String channelName) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/get/rtc/$channelName'));
    if (response.statusCode == 200) {
      print(response.body);
      globals.token.value = jsonDecode(response.body)['rtc_token'];
      globals.uid.value = jsonDecode(response.body)['uid'];
      print('Token : ${globals.token.value}');
      print('UID : ${globals.uid.value}');
    } else {
      print(response.reasonPhrase);
      print('Failed to generate the token : ${response.statusCode}');
    }
  }
}
