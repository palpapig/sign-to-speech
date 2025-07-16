import '../models/hand_pose.dart';

class AnalogParser {
  HandPose parse(List<double> analogValues) {
    if (analogValues.length < 11) {
      throw ArgumentError("需要至少11个传感器数据（5手指角度 + 3加速度 + 3姿态角）");
    }

    // ✅ 前5是手指角度，接近0是直，大角度弯曲
    final fingers = <String, bool>{
      "thumb": isStraight(analogValues[0]),
      "index": isStraight(analogValues[1]),
      "middle": isStraight(analogValues[2]),
      "ring": isStraight(analogValues[3]),
      "pinky": isStraight(analogValues[4]),
    };

    // ✅ 后面三个是姿态角 Pitch/Roll/Yaw
    final pitch = analogValues[8]; // 俯仰角（手抬高/低）
    final roll = analogValues[9]; // 横滚角（左右倾斜）
    final yaw = analogValues[10]; // 偏航角（手指朝向）

    // ✅ 根据姿态角计算手掌朝向
    final direction = _determineDirection(pitch, roll, yaw);

    return HandPose(
      fingers: fingers,
      direction: direction,
      timestamp: DateTime.now(),
    );
  }

  /// ✅ 判断角度是否认为“伸直”
  bool isStraight(double angle) {
    // 绝对值小于 30° 认为是直
    return angle.abs() < 30.0;
  }

  /// ✅ 只用 Pitch/Roll/Yaw 判断手掌方向
  String _determineDirection(double pitch, double roll, double yaw) {
    if (pitch.abs() < 20 && roll.abs() < 20) {
      return "flat"; // 手掌水平
    }
    if (pitch > 45) return "downward"; // 手掌向下
    if (pitch < -45) return "upward"; // 手掌向上
    if (roll > 45) return "tilt-right"; // 手右倾
    if (roll < -45) return "tilt-left"; // 手左倾

    // yaw 主要看手指朝向
    if (yaw.abs() > 160) return "backward-facing"; // 手指反向
    if (yaw.abs() < 20) return "forward-facing"; // 手指正向

    return "neutral";
  }
}
