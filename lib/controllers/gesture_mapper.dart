import '../models/hand_pose.dart';
import '../models/gesture_result.dart';

class GestureMapper {
  GestureResult mapToResult(HandPose pose) {
    String resultText;

    if (pose.fingers["finger_0"] == true && pose.fingers["finger_1"] == false) {
      resultText = "你好";
    } else {
      resultText = "未知";
    }

    return GestureResult(text: resultText, timestamp: pose.timestamp);
  }
}
