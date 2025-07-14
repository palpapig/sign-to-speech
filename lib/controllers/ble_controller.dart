import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

final hm10ServiceUUID = Guid("0000ffe0-0000-1000-8000-00805f9b34fb");
final hm10CharacteristicUUID = Guid("0000ffe1-0000-1000-8000-00805f9b34fb");

class BleController extends GetxController {
  var scanResults = <ScanResult>[].obs;
  var isScanning = false.obs;
  var receivedMessages = <String>[].obs;

  var isConnected = false.obs;
  BluetoothCharacteristic? hm10Characteristic;
  BluetoothDevice? connectedDevice;

  void startScan() {
    scanResults.clear();
    isScanning.value = true;

    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    FlutterBluePlus.scanResults.listen((results) {
      scanResults.assignAll(results);
    });

    FlutterBluePlus.isScanning.listen((scanning) {
      isScanning.value = scanning;
    });
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
    isScanning.value = false;
  }

  Future<bool> connectToDevice(BluetoothDevice device) async {
    try {
      // 断开旧连接
      if (connectedDevice != null) {
        await connectedDevice!.disconnect();
        isConnected.value = false;
      }

      await device.connect();
      connectedDevice = device;

      final services = await device.discoverServices();
      for (var service in services) {
        if (service.uuid == hm10ServiceUUID) {
          for (var c in service.characteristics) {
            if (c.uuid == hm10CharacteristicUUID) {
              hm10Characteristic = c;

              // 设置 notify 监听
              if (c.properties.notify && !c.isNotifying) {
                await c.setNotifyValue(true);
              }

              c.onValueReceived.listen((value) {
                final str = String.fromCharCodes(value);
                receivedMessages.add("收到: $str");
              });

              break;
            }
          }
        }
      }

      isConnected.value = true;
      Get.snackbar('连接成功', '设备已连接: ${device.remoteId.str}');
      return true;
    } catch (e) {
      Get.snackbar('连接失败', e.toString());
      return false;
    }
  }

  Future<void> sendMessage(String text) async {
    try {
      final bytes = text.codeUnits;
      if (hm10Characteristic != null && hm10Characteristic!.properties.write) {
        await hm10Characteristic!.write(bytes, withoutResponse: true);
        receivedMessages.add("发送: $text");
      } else {
        Get.snackbar('发送失败', '找不到可写特征');
      }
    } catch (e) {
      Get.snackbar('发送失败', e.toString());
    }
  }

  Future<void> disconnect() async {
    try {
      if (connectedDevice != null) {
        await connectedDevice!.disconnect();
        connectedDevice = null;
        hm10Characteristic = null;
        isConnected.value = false;
        receivedMessages.clear();
        Get.snackbar("已断开", "设备连接已断开");
      }
    } catch (e) {
      Get.snackbar("断开失败", e.toString());
    }
  }
}
