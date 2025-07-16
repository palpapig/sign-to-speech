import '../models/hand_pose.dart';
import '../models/gesture_result.dart';

class GestureMapper {
  GestureResult mapToResult(HandPose pose) {
    String resultText = "未知";

    // ✅ 示例1: 食指直、其他弯曲 + 手掌向上 → 你好
    if (pose.fingers["index"] == true &&
        pose.fingers["thumb"] == false &&
        pose.fingers["middle"] == false &&
        pose.fingers["ring"] == false &&
        pose.fingers["pinky"] == false &&
        pose.direction == "upward") {
      resultText = "你好";
    }

    // ✅ 示例2: 所有手指伸直 + 手掌向下 → 再见
    if (pose.fingers.values.every((f) => f == true) &&
        pose.direction == "downward") {
      resultText = "再见";
    }

    // ✅ 示例3: 手掌水平 flat → 好的
    if (pose.direction == "flat") {
      resultText = "好的";
    }

    return GestureResult(text: resultText, timestamp: pose.timestamp);
  }
}
