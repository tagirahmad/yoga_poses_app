import 'package:hive/hive.dart';
import 'package:teenytinyom/app/models/pose.dart';
import 'package:teenytinyom/app/services/poses_db.dart';

class HivePosesService implements PosesDb {
  static final HivePosesService _singleton = HivePosesService._internal();
  late Box<Pose> _posesBox;

  factory HivePosesService({required Box<Pose> posesBox}) {
    _singleton._posesBox = posesBox;
    return _singleton;
  }

  HivePosesService._internal();

  Box<Pose> get posesBox => _posesBox;

  @override
  List<Pose>? getPoses() {
    if (_posesBox.isNotEmpty) {
      return _posesBox.values.toList();
    }
  }

  @override
  Future<void> putPose(Pose pose) async {
    _posesBox.add(pose);
  }
}
