import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:teenytinyom/app/constants/dimensions.dart';
import 'package:teenytinyom/app/models/pose.dart';
import 'package:teenytinyom/app/models/poses_change_model.dart';
import 'package:teenytinyom/app/modules/main/preview_image.dart';
import 'package:teenytinyom/app/services/hive_poses_service.dart';
import 'package:teenytinyom/app/services/poses_loader.dart';

class MainView extends StatefulWidget {
  MainView({required this.isLoading, required this.model});

  final bool isLoading;
  final PosesChangeModel model;

  static Widget create(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(true),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => ChangeNotifierProvider<PosesChangeModel>(
          create: (_) => PosesChangeModel(
            isLoading: isLoading,
            posesDb: HivePosesService(),
            posesLoader: PosesLoader(),
          ),
          child: Consumer<PosesChangeModel>(
            builder: (_, model, __) => MainView(
              model: model,
              isLoading: isLoading.value,
            ),
          ),
        ),
      ),
    );
  }

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  PageController _pageController = PageController();
  PageController _savedImagesPageController = PageController();
  late AutoScrollController controller = AutoScrollController();

  @override
  void initState() {
    super.initState();
    widget.model.loadPoses();

    controller = AutoScrollController(
      viewportBoundaryGetter: () =>
          Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal,
      suggestedRowHeight: 200,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
    _savedImagesPageController.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.SIDE_INDENT),
          child: widget.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.black12,
                    ),
                  ),
                )
              : LayoutBuilder(
                  builder: (context, constraints) {
                    final previewHeight = constraints.maxHeight * 0.15;
                    // final previewHeight = constraints.maxHeight * 0.25;
                    final previewWidth = constraints.maxWidth * 0.25;

                    return Column(
                      children: [
                        if (widget.model.poses.length > 0)
                          CupertinoScrollbar(
                            child: Container(
                              height: previewHeight,
                              padding: EdgeInsets.only(bottom: 15.0),
                              child: ListView.builder(
                                controller: controller,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: widget.model.poses.length,
                                itemBuilder: (context, i) {
                                  return AutoScrollTag(
                                    key: ValueKey(i),
                                    controller: controller,
                                    index: i,
                                    child: GestureDetector(
                                      onTap: () => _onPreviewImageTap(
                                        constraints: constraints,
                                        index: i,
                                        previewWidth: previewWidth,
                                      ),
                                      child: PreviewImage(
                                        imageHeight: previewHeight,
                                        imagePath:
                                            widget.model.poses[i].preview,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        else
                          SizedBox(),
                        Divider(
                          thickness: 2.0,
                          color: Colors.black12,
                        ),
                        Center(
                          child: Text(
                            'My Yoga Sequence',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Divider(
                          thickness: 2.0,
                          color: Colors.black12,
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: GridView.builder(
                              itemCount: widget.model.savedPoses.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (orientation == Orientation.portrait)
                                        ? 4
                                        : 7,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog<void>(
                                        context: context,
                                        builder: (BuildContext context) {
                                          _savedImagesPageController =
                                              PageController(
                                            initialPage: index,
                                          );
                                          return Center(
                                            child: _renderSavedZoomedImages(
                                              constraints,
                                              previewWidth,
                                              widget.model.savedPoses,
                                              _savedImagesPageController,
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    child: PreviewImage(
                                      imageHeight: previewHeight,
                                      imageWidth: previewWidth,
                                      imagePath: widget
                                          .model.savedPoses[index].preview,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ),
    );
  }

  void _animateToPic({
    required int index,
  }) {
    this.controller.scrollToIndex(
          index,
          preferPosition: AutoScrollPosition.middle,
        );
  }

  Widget _renderZoomedImages(
    BoxConstraints constraints,
    double previewWidth,
    List<Pose> poses,
    PageController controller,
  ) {
    return Container(
      height: constraints.maxHeight * 0.5,
      width: constraints.maxWidth,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: controller,
        onPageChanged: (page) => _animateToPic(index: page),
        itemBuilder: (context, index) => _zoomedImagesBuilder(
          index,
          poses: poses,
          pageController: controller,
        ),
      ),
    );
  }

  Widget _renderSavedZoomedImages(
    BoxConstraints constraints,
    double previewWidth,
    List<Pose> poses,
    PageController controller,
  ) {
    return Container(
      height: constraints.maxHeight * 0.5,
      width: constraints.maxWidth,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        controller: controller,
        itemCount: poses.length,
        itemBuilder: (context, index) => _savedZoomedImagesBuilder(
          index,
          poses: poses,
          pageController: controller,
        ),
      ),
    );
  }

  Widget _zoomedImagesBuilder(
    int index, {
    required List<Pose> poses,
    required PageController pageController,
  }) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value = 1.0;
        if (pageController.position.haveDimensions) {
          value = pageController.page! - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * size.height * 0.9,
            width: Curves.easeOut.transform(value) * size.width * 0.9,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onDoubleTap: () {
          widget.model.savePose(
            widget.model.poses[index],
          );
          final snackBar = SnackBar(content: Text('Pose saved'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        child: Image.asset(poses[index].zoomed),
      ),
    );
  }

  Widget _savedZoomedImagesBuilder(
    int index, {
    required List<Pose> poses,
    required PageController pageController,
  }) {
    final size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: pageController,
      builder: (context, child) {
        double value = 1.0;
        if (pageController.position.haveDimensions) {
          value = pageController.page! - index;
          value = (1 - (value.abs() * .5)).clamp(0.0, 1.0);
        }

        return Center(
          child: SizedBox(
            height: Curves.easeOut.transform(value) * size.height * 0.9,
            width: Curves.easeOut.transform(value) * size.width * 0.9,
            child: child,
          ),
        );
      },
      child: Image.asset(poses[index].zoomed),
    );
  }

  void _onPreviewImageTap({
    required int index,
    required double previewWidth,
    required BoxConstraints constraints,
  }) {
    _pageController = PageController(initialPage: index);

    // Animate Listview to active picture
    _animateToPic(index: index);

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: _renderZoomedImages(
            constraints,
            previewWidth,
            widget.model.poses,
            _pageController,
          ),
        );
      },
    );
  }
}
