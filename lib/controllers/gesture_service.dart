import '../models/gesture_result.dart';
import '../models/hand_pose.dart';
import 'analog_parser.dart';
import 'gesture_mapper.dart';

class GestureService {
  final AnalogParser _parser = AnalogParser();
  final GestureMapper _mapper = GestureMapper();

  // ✅ 拼接缓存，防止 HM10 拆包
  String _buffer = "";

  /// 处理 BLE 原始数据 chunk，返回 GestureResult?（完整帧才返回）
  GestureResult? processRawChunk(String chunk) {
    _buffer += chunk;

    // 循环找 <...> 完整帧
    while (_buffer.contains("<") && _buffer.contains(">")) {
      final start = _buffer.indexOf("<");
      final end = _buffer.indexOf(">");

      if (end > start) {
        // ✅ 提取 <...> 里的数据
        final frame = _buffer.substring(start + 1, end).trim();
        _buffer = _buffer.substring(end + 1); // 保留剩下的

        if (frame.isNotEmpty) {
          return _processFullFrame(frame); // ✅ 完整帧解析
        }
      } else {
        break;
      }
    }
    return null; // 还没完整帧，先不返回
  }

  /// 处理完整帧 "90,0,90,90,90,0,0,0,-60" → GestureResult
  GestureResult _processFullFrame(String frame) {
    final values = frame
        .split(',')
        .map((e) => double.tryParse(e.trim()) ?? 0.0)
        .toList();

    // ✅ 容错：至少要有 8 个值 [5手指 + 3加速度]
    if (values.length < 8) {
      return GestureResult(
        text: "无效帧(长度${values.length})",
        timestamp: DateTime.now(),
      );
    }

    try {
      // ✅ 转 HandPose
      final pose = _parser.parse(values);

      // ✅ 映射为手势文字
      return _mapper.mapToResult(pose);
    } catch (e) {
      return GestureResult(text: "解析失败: $e", timestamp: DateTime.now());
    }
  }
}
