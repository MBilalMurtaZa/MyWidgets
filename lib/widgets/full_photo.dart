import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/txt.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../utils/utils.dart';

class FullPhotoView extends StatelessWidget {
  final bool isAsset, isSingleImage;
  final String titleText;
  final List<String> images;
  final BoxDecoration? backgroundDecoration;
  final PageController? pageController;
  final Function(int)? onPageChanged;
  final PreferredSizeWidget? appBar;
  final ImageErrorWidgetBuilder? errorWidget;
  final LoadingBuilder? loadingBuilder;


  const FullPhotoView({
    super.key,
    this.isAsset = false,
    this.isSingleImage = true,
    this.titleText = 'Media Preview',
    this.images = const [],
    this.backgroundDecoration,
    this.pageController,
    this.onPageChanged,
    this.appBar,
    this.errorWidget,
    this.loadingBuilder,

  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar??AppBar(
        title: Text(titleText),
      ),
      body: isSingleImage ? _buildSingleImagePreview() : _buildMultiImageView(),
    );
  }

  _buildSingleImagePreview() {
    return PhotoView(
      imageProvider: buildProvider(),
      loadingBuilder: loadingBuilder??loadingBuilderWidget,
      initialScale: PhotoViewComputedScale.contained * 0.8,
      errorBuilder: errorWidget??(context, url, error) => const Icon(Icons.error),
      heroAttributes: PhotoViewHeroAttributes(tag: images.first),
      backgroundDecoration: backgroundDecoration,
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

  _buildMultiImageView() {
    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      builder: (BuildContext context, int index) {
        if(isAsset){
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(images[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: images[index][index]),
            errorBuilder: errorWidget??(context, url, error) => const Icon(Icons.error),
          );
        }else{
          return PhotoViewGalleryPageOptions(
            imageProvider: NetworkImage(images[index]),
            initialScale: PhotoViewComputedScale.contained * 0.8,
            heroAttributes: PhotoViewHeroAttributes(tag: images[index]),
            errorBuilder: errorWidget??(context, url, error) => const Icon(Icons.error),
          );
        }

      },
      itemCount: images.length,

      loadingBuilder: loadingBuilder??loadingBuilderWidget,
      backgroundDecoration: backgroundDecoration,
      pageController: pageController,
      onPageChanged: onPageChanged,
    );
  }

  Widget loadingBuilderWidget(BuildContext context, ImageChunkEvent? event) {
    return Center(
      child: SizedBox(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(
          value: event == null ? 0 : event.cumulativeBytesLoaded / ((event.expectedTotalBytes??1).toInt()),
        ),
      ),
    );
  }
}
