import '../models/hand_pose.dart';
import '../models/gesture_result.dart';
import 'analog_parser.dart';
import 'gesture_mapper.dart';

class GestureService {
  final AnalogParser _parser = AnalogParser();
  final GestureMapper _mapper = GestureMapper();

  GestureResult process(List<double> rawSensorData) {
    // 使用 AnalogParser 解析为 HandPose
    HandPose pose = _parser.parse(rawSensorData);

    // 使用 GestureMapper 映射为 GestureResult
    return _mapper.mapToResult(pose);
  }
}
