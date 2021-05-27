import 'package:hive/hive.dart';
import 'package:teenytinyom/app/models/pose.dart';
import 'package:teenytinyom/app/services/poses_db.dart';

class HivePosesService implements PosesDb {
  final Box<Pose> posesBox;

  HivePosesService(this.posesBox);

  @override
  List<Pose>? getPoses() {
    if (posesBox.isNotEmpty) {
      return posesBox.values.toList();
    }
  }

  @override
  Future<void> putPose(Pose pose) async {
    posesBox.add(pose);
    // getPoses();
  }
}
