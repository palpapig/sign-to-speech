import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../ble_controller.dart';
import 'ble_chat_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final BleController bleController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('BLE 设备扫描'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: bleController.startScan,
              child: const Text("开始扫描"),
            ),
            const SizedBox(height: 10),
            Obx(
              () => bleController.isScanning.value
                  ? const CircularProgressIndicator()
                  : const Text("扫描完成"),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: bleController.scanResults.length,
                  itemBuilder: (context, index) {
                    final result = bleController.scanResults[index];
                    final name = result.device.platformName.isNotEmpty
                        ? result.device.platformName
                        : "未知设备";

                    return ListTile(
                      title: Text(name),
                      subtitle: Text(result.device.remoteId.str),
                      onTap: () async {
                        final success = await bleController.connectToDevice(
                          result.device,
                        );
                        if (success) {
                          Get.to(() => BleChatPage(device: result.device));
                        } else {
                          Get.snackbar(
                            "连接失败",
                            "无法连接到设备 ${result.device.remoteId.str}",
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
