import 'dart:convert';

import 'package:agora_flutter_uikit/global/global_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AgoraTokens extends ValueNotifier<AgoraTokens?> {
  AgoraTokens({
    String? baseUrl,
    String? channelName,
    int? uid,
  }) : super(null) {
    getToken(baseUrl, channelName, uid);
  }

  Future<void> getToken(String? baseUrl, String? channelName, int? uid) async {
    uid == null ? uid = 0 : uid = uid;

    final response = await http
        .get(Uri.parse('$baseUrl/rtc/$channelName/publisher/uid/$uid'));
    if (response.statusCode == 200) {
      print(response.body);
      globals.token.value = jsonDecode(response.body)['rtcToken'];
      print('Token : ${globals.token.value}');
    } else {
      print(response.reasonPhrase);
      print('Failed to generate the token : ${response.statusCode}');
    }
  }
}
