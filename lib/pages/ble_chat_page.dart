import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../ble_controller.dart';

class BleChatPage extends StatelessWidget {
  final BluetoothDevice device;

  const BleChatPage({super.key, required this.device});

  @override
  Widget build(BuildContext context) {
    final bleController = Get.find<BleController>();
    final TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text("连接中：${device.platformName}")),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: bleController.receivedMessages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(bleController.receivedMessages[index]),
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
