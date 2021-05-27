import 'package:teenytinyom/app/models/pose.dart';

abstract class PosesDb {
  Future<void> putPose(Pose pose);
  List<Pose>? getPoses();
  Future<void> deletePose(int index);
}
