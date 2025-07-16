import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../controllers/ble_controller.dart';
import '../controllers/app_controller.dart';
import '../controllers/gesture_service.dart';
import '../utils/tts_helper.dart';

class BleChatPage extends StatelessWidget {
  final BluetoothDevice device;

  const BleChatPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final bleController = Get.find<BleController>();
    final appController = Get.find<AppController>();
    final TextEditingController messageController = TextEditingController();
    final GestureService gestureService = GestureService();
    final TTSHelper ttsHelper = TTSHelper();

    return Scaffold(
      appBar: AppBar(
        title: Text("连接中：${device.platformName}"),
        actions: [
          // ✅ 新增一个测试语音按钮
          IconButton(
            icon: const Icon(Icons.volume_up),
            tooltip: "测试语音朗读",
            onPressed: () {
              ttsHelper.speak("测试语音朗读，您好，这是一个测试。");
            },
          ),
          const SizedBox(width: 8),
          Obx(
            () => Row(
              children: [
                const Text("语音朗读"),
                Switch(
                  value: appController.ttsEnabled.value,
                  onChanged: appController.toggleTTS,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: bleController.receivedMessages.length,
                itemBuilder: (context, index) {
                  final rawChunk = bleController.receivedMessages[index];

                  // ✅ 交给 GestureService 拼帧 + 解析
                  final result = gestureService.processRawChunk(rawChunk);

                  if (result != null) {
                    // ✅ 完整帧解析成功，语音朗读
                    if (appController.ttsEnabled.value) {
                      ttsHelper.speak(result.text);
                    }

                    return ListTile(
                      title: Text("✅ 完整帧: $rawChunk"),
                      subtitle: Text("识别: ${result.text}"),
                    );
                  } else {
                    // ✅ 还在拼接中，先显示碎片
                    return ListTile(
                      title: Text("碎片: $rawChunk"),
                      subtitle: const Text("等待完整帧..."),
                    );
                  }
                },
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(labelText: '输入消息'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = messageController.text.trim();
                    if (message.isNotEmpty) {
                      bleController.sendMessage(message);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
