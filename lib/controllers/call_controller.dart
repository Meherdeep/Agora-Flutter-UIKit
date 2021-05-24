import 'package:agora_flutter_uikit/models/call_settings.dart';
import 'package:agora_flutter_uikit/models/call_user.dart';
import 'package:flutter/material.dart';

CallController callController = CallController();

class CallController extends ValueNotifier<CallSettings> {
  CallController() : super(CallSettings(users: []));

  CallSettings copyWith({List<CallUser>? users}) {
    return CallSettings(users: users ?? value.users);
  }

  void addUser({required CallUser callUser}) {
    value = copyWith(users: [...value.users, callUser]);
  }

  void clearUsers() {
    value = copyWith(users: []);
  }

  void removeUser({required int uid}) {
    List<CallUser> tempList = <CallUser>[];
    tempList = value.users;
    for (int i = 0; i < tempList.length; i++) {
      if (tempList[i].uid == uid) {
        tempList.remove(tempList[i]);
      }
    }
    value = copyWith(users: tempList);
  }
}
