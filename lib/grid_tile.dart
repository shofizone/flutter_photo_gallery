import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_photo_gallery/selected_image_logic.dart';
import 'package:get/get.dart';
import 'package:photo_manager/photo_manager.dart';

class GalleryGridTile extends StatelessWidget {
  final AssetEntity assetEntity;
  final bool allowMultiSelect;

  GalleryGridTile({
    required this.assetEntity,
    required this.allowMultiSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SelectedImageLogic>(
      builder: (logic) {
        bool selected = logic.selectedImagesIds.contains(assetEntity.id);
        return FutureBuilder<Uint8List?>(
            future: assetEntity.thumbData,
            builder: (context, snapshot) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                ),
                child: LayoutBuilder(builder: (context, constraint) {
                  return Stack(
                    children: [
                      snapshot.data == null
                          ? Center()
                          : Image.memory(
                              snapshot.data!,
                              height: constraint.maxHeight,
                              width: constraint.maxWidth,
                              fit: BoxFit.cover,
                              gaplessPlayback: true,
                            ),
                      Container(
                        decoration: BoxDecoration(
                          border: selected
                              ? Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Center(),
                      ),
                      Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(2),
                          onTap: () {
                            logic.handleImageSelect(
                              assetEntity,
                              allowMultiSelect: allowMultiSelect,
                            );
                          },
                          child: Center(),
                        ),
                      ),
                    ],
                  );
                }),
              );
            });
      },
    );
  }
}
