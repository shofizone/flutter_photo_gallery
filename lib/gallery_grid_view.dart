import 'package:flutter/material.dart';
import 'package:flutter_photo_gallery/grid_tile.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryGridView extends StatelessWidget {
  final List<AssetEntity> itemList;
  final bool allowMultiSelect;
  GalleryGridView({
    required this.itemList,
    this.allowMultiSelect = true,
  });
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 1,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: itemList.length,
      itemBuilder: (context, index) {
        return GalleryGridTile(
          assetEntity: itemList[index],
          allowMultiSelect: allowMultiSelect,
        );
      },
    );
  }
}
