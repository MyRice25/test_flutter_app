import 'dart:io';

import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart' hide Trans;
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';
import '../constants/app_colors.dart';
import '../constants/image_paths.dart';
import 'AppButton.dart';

class GalleryBottomSheet extends StatefulWidget {
  ScrollController? controller;
  Function(List<AssetEntity>) onTapSend;
  int limitCnt;
  String sendText;
  bool onlyImage;
  GalleryBottomSheet(
      {super.key,
      this.controller,
      required this.onTapSend,
      this.limitCnt = 10,
      this.sendText = "",
      this.onlyImage = false});

  @override
  State<GalleryBottomSheet> createState() => _GalleryBottomSheet();
}

class _GalleryBottomSheet extends State<GalleryBottomSheet> {
  final List<AssetEntity> _media = [];
  late AssetPathEntity album;

  late Future albumFuture;

  final gridController = DragSelectGridViewController();
  final Set<int> selectedIndexes = <int>{};
  final key = GlobalKey();
  int? startTarget;
  bool isStart = false;
  final Set<int> _trackTaped = <int>{};

  int page = 0;
  bool isLast = false;
  bool isLoading = false;

  _detectTapedItem(PointerEvent event) {
    if (!isStart || getSelectedCount() >= widget.limitCnt) return;
    final RenderBox box = key.currentContext!.findRenderObject()! as RenderBox;
    final result = BoxHitTestResult();
    Offset local = box.globalToLocal(event.position);
    if (box.hitTest(result, position: local)) {
      for (final hit in result.path) {
        /// temporary variable so that the [is] allows access of [index]
        final target = hit.target;
        print(target);
        if (target is _MediaItem) {
          if (_trackTaped.isNotEmpty &&
              _trackTaped.first != target.index! &&
              _trackTaped.last != target.index!) {
            startTarget ??= target.index!;
          }
          _trackTaped.clear();
          if (startTarget! < target.index!) {
            for (int i = startTarget!; i <= target.index!; i++) {
              if (!selectedIndexes.contains(i)) {
                if (getSelectedCount() < widget.limitCnt) {
                  _trackTaped.add(i);
                } else {
                  break;
                }
              }
            }
          } else if (startTarget! > target.index!) {
            for (int i = target.index!; i <= startTarget!; i++) {
              if (!selectedIndexes.contains(i)) {
                if (getSelectedCount() < widget.limitCnt) {
                  _trackTaped.add(i);
                } else {
                  break;
                }
              }
            }
          } else {
            _trackTaped.add(target.index!);
          }
          _selectIndex();
        }
      }
    }
  }

  _selectIndex() {
    setState(() {});
  }

  int getSelectedCount() {
    Set<int> tempSet = <int>{};
    tempSet.addAll(selectedIndexes);
    tempSet.addAll(_trackTaped);
    return tempSet.length;
  }

  void _clearSelection(PointerUpEvent event) {
    selectedIndexes.addAll(_trackTaped);
    _trackTaped.clear();
    setState(() {
      isStart = false;
      startTarget = null;
    });
  }

  @override
  void initState() {
    albumFuture = initAsync();
    super.initState();
    gridController.addListener(scheduleRebuild);
    widget.controller?.addListener(getNextPhotos);
  }

  @override
  void dispose() {
    gridController.removeListener(scheduleRebuild);
    widget.controller?.removeListener(getNextPhotos);
    super.dispose();
  }

  void scheduleRebuild() => setState(() {});

  Future<List<AssetEntity>> initAsync() async {
    final PermissionState permission =
        await PhotoManager.requestPermissionExtend();
    if (permission != PermissionState.authorized) {
      return [];
    }

    List<AssetPathEntity> albums = await PhotoManager.getAssetPathList();
    int maxAlbumCnt = 0;
    int maxAlbumindex = 0;
    for (int i = 0; i < albums.length; i++) {
      int count = await albums[i].assetCountAsync;
      if (count > maxAlbumCnt) {
        maxAlbumindex = i;
        maxAlbumCnt = count;
      }
    }
    album = albums[maxAlbumindex];
    List<AssetEntity> mediaList =
        await album.getAssetListPaged(page: 0, size: 30);
    isLast = mediaList.length < 30;
    page = 1;
    if (widget.onlyImage) {
      for (int i = 0; i < mediaList.length; i++) {
        if (mediaList[i].type == AssetType.image) {
          _media.add(mediaList[i]);
        }
      }
    } else {
      _media.addAll(mediaList);
    }
    return _media;
  }

  Future<void> getNextPhotos() async {
    if (!isLoading && (widget.controller?.position.extentAfter ?? 201) < 200) {
      isLoading = true;
      List<AssetEntity> mediaList =
          await album.getAssetListPaged(page: page, size: 30);
      page += 1;
      setState(() {
        if (widget.onlyImage) {
          for (int i = 0; i < mediaList.length; i++) {
            if (mediaList[i].type == AssetType.image) {
              _media.add(mediaList[i]);
            }
          }
        } else {
          _media.addAll(mediaList);
        }
      });
      isLast = mediaList.length < 30;
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(24), topLeft: Radius.circular(24))),
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            Center(
              child: Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                    color: AppColors.colorc8,
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
            SizedBox(height: 15),
            Expanded(
                child: FutureBuilder(
              future: albumFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: Listener(
                        onPointerDown: _detectTapedItem,
                        onPointerMove: _detectTapedItem,
                        onPointerUp: _clearSelection,
                        child: GridView.builder(
                            controller: widget.controller,
                            key: key,
                            physics:
                                isStart ? NeverScrollableScrollPhysics() : null,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                            ),
                            itemCount: _media.length,
                            itemBuilder: (context, index) {
                              return MediaItem(
                                index: index,
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedIndexes.contains(index)) {
                                      selectedIndexes.remove(index);
                                    } else {
                                      if (selectedIndexes.length <
                                          widget.limitCnt) {
                                        selectedIndexes.add(index);
                                      }
                                    }
                                  },
                                  onLongPressStart: (details) {
                                    setState(() {
                                      isStart = true;
                                      startTarget = index;
                                    });
                                  },
                                  child: Container(
                                      color: AppColors.colorf0,
                                      child: Stack(
                                        children: [
                                          Center(
                                              child: SizedBox(
                                            width: double.maxFinite,
                                            height: double.maxFinite,
                                            child: FadeInImage(
                                              fit: BoxFit.cover,
                                              placeholder: MemoryImage(
                                                  kTransparentImage),
                                              image: AssetEntityImageProvider(
                                                _media[index],
                                                isOriginal: false,
                                              ),
                                            ),
                                          )),
                                          Positioned(
                                              top: 5,
                                              left: 5,
                                              child: InkWell(
                                                onTap: () {
                                                  if (selectedIndexes
                                                      .contains(index)) {
                                                    selectedIndexes
                                                        .remove(index);
                                                  } else {
                                                    if (selectedIndexes.length <
                                                        widget.limitCnt) {
                                                      selectedIndexes
                                                          .add(index);
                                                    }
                                                  }
                                                },
                                                child: Image.asset(
                                                  selectedIndexes.contains(
                                                              index) ||
                                                          _trackTaped
                                                              .contains(index)
                                                      ? "${iconPath}ic_checked.png"
                                                      : "${iconPath}ic_unchecked.png",
                                                  width: 24,
                                                  height: 24,
                                                ),
                                              ))
                                        ],
                                      )),
                                ),
                              );
                            }),
                      ));
                }

                return Center(
                  child: SizedBox(
                    height: 10.0,
                    width: 10.0,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.appColor)),
                  ),
                );
              },
            )),
            SizedBox(
              height: 15,
            ),
            if (getSelectedCount() != 0)
              AppButton(
                  text: widget.sendText.isEmpty
                      ? "${getSelectedCount()} 보내기"
                      : widget.sendText,
                  disabled: getSelectedCount() == 0,
                  color: AppColors.appColor,
                  onTap: () {
                    List<AssetEntity> results = [];
                    for (int i = 0; i < selectedIndexes.length; i++) {
                      results.add(_media[selectedIndexes.elementAt(i)]);
                    }
                    widget.onTapSend(results);
                    Get.back();
                  }),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 15),
          ],
        ));
  }
}

class MediaItem extends SingleChildRenderObjectWidget {
  final int index;

  const MediaItem({super.child, required this.index, super.key});

  @override
  _MediaItem createRenderObject(BuildContext context) {
    return _MediaItem()..index = index;
  }

  @override
  void updateRenderObject(BuildContext context, _MediaItem renderObject) {
    renderObject.index = index;
  }
}

class _MediaItem extends RenderProxyBox {
  int? index;
}

class ViewerPage extends StatelessWidget {
  final AssetEntity asset;

  const ViewerPage(AssetEntity asset, {super.key}) : asset = asset;

  @override
  Widget build(BuildContext context) {
    DateTime? date = asset.createDateTime ?? asset.modifiedDateTime;
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back_ios),
          ),
          title: date != null ? Text(date.toLocal().toString()) : null,
        ),
        body: Container(
          alignment: Alignment.center,
          child: asset.type == AssetType.image
              ? FadeInImage(
                  fit: BoxFit.cover,
                  placeholder: MemoryImage(kTransparentImage),
                  image: AssetEntityImageProvider(asset),
                )
              : VideoProvider(
                  asset: asset,
                ),
        ),
      ),
    );
  }
}

class VideoProvider extends StatefulWidget {
  final AssetEntity asset;

  const VideoProvider({
    super.key,
    required this.asset,
  });

  @override
  _VideoProviderState createState() => _VideoProviderState();
}

class _VideoProviderState extends State<VideoProvider> {
  VideoPlayerController? _controller;
  File? _file;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initAsync();
    });
    super.initState();
  }

  Future<void> initAsync() async {
    try {
      _file = await widget.asset.file;
      if (_file != null) {
        _controller = VideoPlayerController.file(_file!);
        _controller?.initialize().then((_) {
          setState(() {});
        });
      }
    } catch (e) {
      print("Failed : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null || !_controller!.value.isInitialized
        ? Container()
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _controller!.value.isPlaying
                        ? _controller!.pause()
                        : _controller!.play();
                  });
                },
                child: Icon(
                  _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
              ),
            ],
          );
  }
}
