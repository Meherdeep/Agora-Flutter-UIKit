import 'dart:convert';

import 'package:agora_flutter_uikit/global/global_variable.dart';
import 'package:flutter_super_state/flutter_super_state.dart';
import 'package:http/http.dart' as http;

class AgoraTokens extends StoreModule {
  AgoraTokens({
    Store store,
    String baseUrl,
    String channelName,
  }) : super(store) {
    getToken(baseUrl, channelName);
  }

  Future<void> getToken(String baseUrl, String channelName) async {
    print('Generating Token');
    final response =
        await http.get(Uri.parse('$baseUrl/api/get/rtc/$channelName'));
    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        token.value = jsonDecode(response.body)['rtc_token'];
        uid.value = jsonDecode(response.body)['uid'];
      });
      print('Token : $token');
      print('UID : $uid');
    } else {
      print(response.reasonPhrase);
      print('Failed to generate the token : ${response.statusCode}');
    }
  }
}
