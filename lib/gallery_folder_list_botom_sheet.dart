import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_photo_gallery/gallery_logic.dart';
import 'package:flutter_photo_gallery/gallery_folder_with_items.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryFolderListBottomSheet extends StatefulWidget {
  final Function(GalleryFolderWithItems)? onSelect;
  const GalleryFolderListBottomSheet({Key? key, this.onSelect}) : super(key: key);

  @override
  _GalleryFolderListBottomSheetState createState() => _GalleryFolderListBottomSheetState();
}

class _GalleryFolderListBottomSheetState extends State<GalleryFolderListBottomSheet> {
  var v = Get.put(GalleryLogic());

  @override
  void initState() {
    super.initState();
    GalleryLogic galleryController = Get.find();
    galleryController.getFolderList();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GetBuilder<GalleryLogic>(
        builder: (logic) {
          var list = logic.galleryFolderList;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                var folder = list[index];
                return FutureBuilder<Uint8List?>(
                    future: _getThumb(folder.items),
                    builder: (context, snapshot) {
                      return ListTile(
                        onTap: () {
                          if (widget.onSelect != null) {
                            widget.onSelect!(list[index]);
                          }
                          Navigator.pop(context);
                        },
                        leading: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                          ),
                          child: snapshot.data == null
                              ? SizedBox()
                              : Image.memory(
                                  snapshot.data!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        title: Text(folder.name),
                        subtitle: Text("${folder.assetCount}"),
                      );
                    });
              });
        },
      ),
    );
  }

  Future<Uint8List?> _getThumb(List<AssetEntity> items) async {
    for (var v in items) {
      if (await v.thumbnailData != null) {
        return v.thumbnailData;
      }
    }
    return null;
  }
}
