import 'package:photo_manager/photo_manager.dart';

class GalleryFolderWithItems {
  String name;
  int assetCount;
  AssetPathEntity? assetPathEntity;
  List<AssetEntity> items;
  GalleryFolderWithItems({
    this.assetPathEntity,
    required this.items,
    required this.name,
    required this.assetCount,
  });
}
