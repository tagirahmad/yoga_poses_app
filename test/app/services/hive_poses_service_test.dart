import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:teenyTinyOm/app/models/pose.dart';
import 'package:teenyTinyOm/app/services/hive_poses_service.dart';

Future<void> initHive() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  var path = Directory.current.path;

  if (!Hive.isAdapterRegistered(0)) {
    Hive.init(path + '/test/hive_testing_path');
    Hive.registerAdapter<Pose>(PoseAdapter());
  }

  await Hive.openBox<Pose>('poses');
}

void main() {
  group('HivePosesService tests', () {
    late HivePosesService hivePosesService;
    
    setUp(() async {
      await initHive();
    });

    group('HivePosesService getPoses() when there are no any poses', () {
      setUp(() {
        hivePosesService = HivePosesService(posesBox: Hive.box<Pose>('poses'));
      });

      test('HivePosesService should get non of poses', () async {
        final poses = hivePosesService.getPoses();
        expect(poses, null);
      });
    });

    group('HivePosesService getPoses() when there are few poses', () {
      late HivePosesService hivePosesService;

      setUp(() {
        hivePosesService = HivePosesService(posesBox: Hive.box<Pose>('poses'));
        hivePosesService.posesBox.addAll([
          Pose(preview: 'preview1', zoomed: 'zoomed1'),
          Pose(preview: 'preview1', zoomed: 'zoomed1'),
          Pose(preview: 'preview1', zoomed: 'zoomed1'),
        ]);
      });

      test('HivePosesService should get 3 poses', () {
        final poses = hivePosesService.getPoses();
        expect(poses!.length, 3);
      });
    });

    group('HivePosesService putPose() with a pose', () {
      late HivePosesService hivePosesService;

      setUp(() {
        hivePosesService = HivePosesService(posesBox: Hive.box<Pose>('poses'));
      });

      test('Put a pose with putPose()', () async {
        await hivePosesService.putPose(Pose(
          preview: 'preview img',
          zoomed: 'Zoomed img',
        ));

        final poses = hivePosesService.getPoses();

        expect(poses!.length, 4);
        expect(poses[3].preview, 'preview img');
        expect(poses[3].zoomed, 'Zoomed img');
      });

      test('Put two poses one by one with putPose()', () async {
        await hivePosesService.putPose(Pose(
          preview: 'preview img',
          zoomed: 'Zoomed img',
        ));

        await hivePosesService.putPose(Pose(
          preview: 'preview img2',
          zoomed: 'Zoomed img2',
        ));

        final poses = hivePosesService.getPoses();
        expect(poses!.length, 6);
        expect(poses[5].preview, 'preview img2');
        expect(poses[5].zoomed, 'Zoomed img2');
      });
    });

    tearDownAll(() {
      Hive.close();
      Hive.deleteFromDisk();
    });
  });
}
