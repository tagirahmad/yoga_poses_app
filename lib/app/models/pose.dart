import 'package:hive/hive.dart';

part 'pose.g.dart';

@HiveType(typeId: 0)
class Pose {
  Pose({required this.preview, required this.zoomed});

  @HiveField(0)
  final String preview;
  @HiveField(1)
  final String zoomed;
}
