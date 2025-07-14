class HandPose {
  final Map<String, bool> fingers; // 指头弯曲状态
  final String direction; // 例如: up/down/left/right
  final DateTime timestamp;

  HandPose({
    required this.fingers,
    required this.direction,
    required this.timestamp,
  });
}
