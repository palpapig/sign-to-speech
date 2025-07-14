import '../models/hand_pose.dart';

class AnalogParser {
  // 将传感器模拟数据转为 HandPose 对象
  HandPose parse(List<double> analogValues) {
    // 假设10个值分别表示10个关节（从指尖到指根）
    Map<String, bool> fingerStatus = {};

    for (int i = 0; i < analogValues.length; i++) {
      fingerStatus["finger_$i"] = analogValues[i] > 500; // 可调阈值
    }

    // 方向暂时硬编码，后期可根据 IMU（方向传感器）补充
    return HandPose(
      fingers: fingerStatus,
      direction: 'neutral',
      timestamp: DateTime.now(),
    );
  }
}
