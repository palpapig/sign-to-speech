import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  final FlutterTts _tts = FlutterTts();
  bool _isReady = false; // ✅ 标记是否绑定完成

  TTSHelper() {
    _initTTS();
  }

  Future<void> _initTTS() async {
    // ✅ 打印可用引擎（调试用）
    var engines = await _tts.getEngines;
    print("📢 可用TTS引擎: $engines");

    // ✅ 设置参数
    await _tts.setLanguage("zh-CN");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    // ✅ 监听启动回调
    _tts.setStartHandler(() {
      print("✅ TTS 已开始工作");
      _isReady = true;
    });

    // ✅ 强制绑定引擎（不会真的播报）
    await _tts.speak("语音引擎初始化");
    await _tts.stop();
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    // ✅ 如果还没绑定，先初始化
    if (!_isReady) {
      print("⚠️ TTS 还未准备好，尝试初始化...");
      await _initTTS();
    }

    await _tts.stop(); // 防止叠音
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
