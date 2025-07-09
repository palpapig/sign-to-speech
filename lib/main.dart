import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ble_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter BLE Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'BLE Demo Home Page'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final BleController bleController = Get.put(BleController());

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
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
                    final name = result.device.name.isNotEmpty
                        ? result.device.name
                        : "未知设备";
                    return ListTile(
                      title: Text(name),
                      subtitle: Text(result.device.id.id),
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
