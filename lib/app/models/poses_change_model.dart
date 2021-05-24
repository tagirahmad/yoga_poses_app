import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';
import 'package:teenytinyom/app/models/pose.dart';
import 'package:teenytinyom/app/services/poses_db.dart';
import 'package:teenytinyom/app/services/poses_loader.dart';

class PosesChangeModel extends ChangeNotifier {
  PosesChangeModel({
    this.poses = const [],
    this.savedPoses = const [],
    required this.isLoading,
    required this.posesDb,
    required this.posesLoader,
  });

  final ValueNotifier<bool> isLoading;
  List<Pose> poses;
  List<Pose> savedPoses;
  final PosesDb posesDb;
  final PosesLoader posesLoader;

  Future<void> loadPoses() async {
    try {
      var previewPoses = await posesLoader.loadPreviewImages();
      var zoomedPoses = await posesLoader.loadZoomedImages();
      var poseList = [];
      for (var pair in zip([previewPoses, zoomedPoses])) {
        poseList.add(Pose(preview: pair[0], zoomed: pair[1]));
      }

      poses = List.from(poseList);

      final posesFromDb = posesDb.getPoses();
      var savedPosesList = [];
      if (posesFromDb != null) {
        savedPosesList = [...posesFromDb];
        savedPoses = List.from(savedPosesList);
      }

      isLoading.value = false;

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  void savePose(Pose pose) {
    var poseList = [...savedPoses];
    poseList.add(pose);
    savedPoses = List.from(poseList);
    posesDb.putPose(pose);
    notifyListeners();
  }
}
