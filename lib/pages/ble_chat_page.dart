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
                  final raw = bleController.receivedMessages[index];

                  // 转换：传感器数据（假设是以逗号分隔的小数）
                  List<double> sensorData = raw
                      .split(',')
                      .map((e) => double.tryParse(e.trim()) ?? 0.0)
                      .toList();

                  final result = gestureService.process(sensorData);

                  // 如果开启朗读，就说出来
                  if (appController.ttsEnabled.value) {
                    ttsHelper.speak(result.text);
                  }

                  return ListTile(
                    title: Text("原始: $raw"),
                    subtitle: Text("识别: ${result.text}"),
                  );
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
