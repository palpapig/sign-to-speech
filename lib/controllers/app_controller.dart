import 'package:get/get.dart';

class AppController extends GetxController {
  // 是否启用语音朗读
  var ttsEnabled = true.obs;

  void toggleTTS(bool value) {
    ttsEnabled.value = value;
  }
}
