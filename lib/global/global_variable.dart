import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<dynamic>> users = ValueNotifier([]);

ValueNotifier<bool> isButtonVisible = ValueNotifier(false);

ValueNotifier<bool> visible = ValueNotifier(true);

RtcEngine engine;
