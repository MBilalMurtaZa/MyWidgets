import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/txt.dart';
import 'package:photo_view/photo_view.dart';

import '../utils/utils.dart';

class FullPhotoView extends StatelessWidget {
  final bool isAsset, isSingleImage;
  final String titleText;
  final List<String> images;

  const FullPhotoView({
    Key? key,
    this.isAsset = false,
    this.isSingleImage = true,
    this.titleText = 'Media Preview',
    this.images = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titleText),
      ),
      body: isSingleImage ? _buildSingleImagePreview() : _buildMultiImageView(),
    );
  }

  _buildSingleImagePreview() {
    return PhotoView(
      imageProvider: buildProvider(),
      loadingBuilder: buildLoading,
    );
  }

  buildProvider() {
    return isAsset ? AssetImage(images.first) : NetworkImage(images.first);
  }

  Widget buildLoading(context, event) => Center(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 20.0,
                height: 20.0,
                child: Platform.isAndroid
                    ? CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Clr.colorPrimary),
                      )
                    : CircleAvatar(
                        backgroundColor: Clr.colorWhite,
                        child: CupertinoActivityIndicator(
                          color: Clr.colorPrimary,
                        ),
                      ),
              ),
              Txt('Opening ${event == null ? 0 : double.parse((event.cumulativeBytesLoaded / event.expectedTotalBytes).toString()).toStringAsFixed(0)}'),
            ],
          ),
        ),
      );

  _buildMultiImageView() {}
}
