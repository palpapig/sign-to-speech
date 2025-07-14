import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  final FlutterTts _tts = FlutterTts();

  TTSHelper() {
    _tts.setLanguage("zh-CN"); // 中文语音
    _tts.setSpeechRate(0.5); // 语速（0.0 ~ 1.0）
    _tts.setVolume(1.0); // 音量（0.0 ~ 1.0）
    _tts.setPitch(1.0); // 音调（0.5 ~ 2.0）
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;
    await _tts.stop(); // 停止之前的语音（避免重复）
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
