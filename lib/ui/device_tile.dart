import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../controllers/ble_controller.dart';

class DeviceTile extends StatelessWidget {
  final ScanResult result;

  const DeviceTile({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final bleController = Get.find<BleController>();
    final name = result.device.platformName.isNotEmpty
        ? result.device.platformName
        : "未知设备";

    return ListTile(
      title: Text(name),
      subtitle: Text(result.device.remoteId.str),
      onTap: () => bleController.connectToDevice(result.device),
    );
  }
}
