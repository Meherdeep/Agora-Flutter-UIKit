import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<dynamic>> users = ValueNotifier([]);

ValueNotifier<List<dynamic>> mutedUsers = ValueNotifier([]);

ValueNotifier<List<dynamic>> videoDisabledUsers = ValueNotifier([]);

ValueNotifier<bool> isButtonVisible = ValueNotifier(false);

ValueNotifier<bool> visible = ValueNotifier(true);

RtcEngine engine;

ValueNotifier<String> token = ValueNotifier(null);

ValueNotifier<int> uid = ValueNotifier(0);

ValueNotifier<int> speakerUid = ValueNotifier(0);

ValueNotifier<int> maxUid = ValueNotifier(0);

ValueNotifier<int> localUid = ValueNotifier(0);

bool isActiveSpeakerEnabled = false;

bool isVideoUnPinned = true;
