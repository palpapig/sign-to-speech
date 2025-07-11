import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ble_controller.dart';
import 'pages/home_page.dart';

void main() {
  Get.put(BleController()); // ✅ 注册一次全局可用
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(title: 'BLE Demo', home: const HomePage());
  }
}
