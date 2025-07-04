// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains get images.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../my_widgets.dart';
import '../utils/utils.dart';
import 'full_photo.dart';
import 'loading.dart';

class GetImage extends StatelessWidget {
  final String? imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  final double? radius;
  final bool isAssets;
  final Color? imageColor, loadingColor;
  final BorderRadius? borderRadius;
  final GestureTapCallback? onTap;
  final BoxDecoration? backgroundDecoration;
  final PageController? pageController;
  final Function(int)? onPageChanged;
  final PreferredSizeWidget? appBar;

  const GetImage(
      {super.key,
      this.imagePath,
      this.width = Siz.profileImageSize,
      this.height = Siz.profileImageSize,
      this.fit = BoxFit.cover,
      this.radius,
      this.isAssets = false,
      this.imageColor,
      this.borderRadius,
      this.loadingColor,
      this.onTap,
      this.backgroundDecoration,
      this.pageController,
      this.onPageChanged,
      this.appBar});

  static String defaultImage = 'assets/default.png';
  static bool defImageIsAsset = true;

  @override
  Widget build(BuildContext context) {
    bool isAsset = isAssets;
    if (imagePath == null) {
      isAsset = true;
    }
    return GestureDetector(
      onTap: onTap ??
          (Static.defaultImageClick
              ? () {
                  pSetRout(
                    page: () => FullPhotoView(
                      images: [imagePath ?? defaultImage],
                      isAsset: isAsset,
                      isSingleImage: true,
                      backgroundDecoration: backgroundDecoration,
                      onPageChanged: onPageChanged,
                      pageController: pageController,
                      appBar: appBar,
                    ),
                  );
                }
              : null),
      child: ClipRRect(
        borderRadius:
            borderRadius ?? BorderRadius.circular(radius ?? Siz.defaultRadius),
        child: isAsset
            ? SizedBox(
                height: height,
                width: width,
                child: Image.asset(
                  imagePath ?? defaultImage,
                  color: imageColor,
                  width: width,
                  height: height,
                  fit: fit,
                ),
              )
            : CachedNetworkImage(
                imageUrl: imagePath ?? defaultImage,
                imageBuilder: (context, imageProvider) => Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: fit,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  height: height,
                  width: width,
                  decoration: pBoxDecoration(
                    borderRadius: borderRadius ??
                        BorderRadius.circular(radius ?? Siz.defaultRadius),
                  ),
                  child: LoadingPro(
                    valueColor: loadingColor ?? Clr.colorPrimary,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: height,
                  width: width,
                  decoration: pBoxDecoration(
                    borderRadius: borderRadius ??
                        BorderRadius.circular(radius ?? Siz.defaultRadius),
                  ),
                  child: Image.asset(defaultImage, width: width, height: height,fit: fit,),
                ),
              ),
      ),
    );
  }
}
