import 'dart:io';
import 'package:collection/collection.dart';
import 'package:flutter_photo_gallery/gallery_folder_with_items.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryLogic extends GetxController {
  static GalleryLogic get to => Get.find<GalleryLogic>();
  List<GalleryFolderWithItems> galleryFolderList = [];
  GalleryFolderWithItems? _selectedGalleryFolderWithItems;

  @override
  onInit() async {
    super.onInit();
    getItems();
  }

  GalleryFolderWithItems? get selectedGalleryFolderWithItems =>
      _selectedGalleryFolderWithItems;

  onSelectFolderListItem(GalleryFolderWithItems v) {
    _selectedGalleryFolderWithItems = v;
    update();
  }

  getItems() async {
    if (!(Platform.isAndroid || Platform.isIOS)) {
      return;
    }
    List<GalleryFolderWithItems> assetPathEntityList = [];
    var pathList = await getFolderList();
    for (var folder in pathList) {
      final assetCount = await folder.assetCountAsync;
      final List<AssetEntity> assetList = assetCount == 0
          ? []
          : (await folder.getAssetListRange(start: 0, end: assetCount));
      var galleryFolderWithItems = GalleryFolderWithItems(
        assetPathEntity: folder,
        items: assetList,
        assetCount: assetCount,
        name: folder.name,
      );
      assetPathEntityList.add(galleryFolderWithItems);
    }
    galleryFolderList = assetPathEntityList;
    _selectedGalleryFolderWithItems ??= assetPathEntityList.firstOrNull;
    update();
  }

  Future<List<AssetPathEntity>> getFolderList() async {
    try {
      var list = await PhotoManager.getAssetPathList(
          type: RequestType.image); // RequestType.video for video
      update();
      return list;
    } catch (e) {
      return [];
    }
  }
}
