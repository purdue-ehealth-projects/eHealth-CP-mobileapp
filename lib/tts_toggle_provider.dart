import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsToggleProvider with ChangeNotifier {
  FlutterTts flutterTts = FlutterTts();
  bool _isTtsEnabled = true;

  bool get isTtsEnabled => _isTtsEnabled;

  Future<void> toggleTts() async {
    _isTtsEnabled = !_isTtsEnabled;
    await flutterTts.setVolume(_isTtsEnabled ? 1.0 : 0.0);
    notifyListeners();
  }

  Future<void> speak(String text) async {
    if (_isTtsEnabled) {
      await flutterTts.speak(text);
    }
  }
}
