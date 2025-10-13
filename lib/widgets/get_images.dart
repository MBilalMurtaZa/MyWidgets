// This file is part of a Flutter package created by Bilal MurtaZa.
// Purpose: This file contains get images.

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_widgets/widgets/txt.dart';
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
  final Duration imageLoadingDelay;
  final Color loadingBgColor;
  final Widget? errorWidget;

  const GetImage({super.key,
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
    this.appBar,
    this.imageLoadingDelay = const Duration(milliseconds: 100),
    this.loadingBgColor = Colors.transparent,
    this.errorWidget
  });

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
            : buildFutureBuilderImage(),
      ),
    );
  }

  FutureBuilder<dynamic> buildFutureBuilder() {
    return FutureBuilder(
            future: Future.delayed(imageLoadingDelay),
            builder: (context, asyncSnapshot) {
              if(asyncSnapshot.connectionState != ConnectionState.done){
                return Container(
                  height: height,
                  width: width,
                  decoration: pBoxDecoration(
                    borderRadius: borderRadius ??
                        BorderRadius.circular(radius ?? Siz.defaultRadius),
                  ),
                  child: LoadingPro(
                    valueColor: loadingColor ?? Clr.colorPrimary,
                  ),
                );
              }
              return CachedNetworkImage(
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
                );
            }
          );
  }

  Widget buildFutureBuilderImage() {
    return FutureBuilder(
        future: Future.delayed(imageLoadingDelay),
        builder: (context, asyncSnapshot) {
          return CachedNetworkImage(
            imageUrl: imagePath ?? defaultImage,
            imageBuilder: (context, provider) {
              return Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: fit,
                  ),
                ),
              );
            },
            progressIndicatorBuilder: (context, url, downloadProgress) {
              double progress = downloadProgress.progress != null && downloadProgress.progress! > 0.0 && downloadProgress.progress! < 1.0? downloadProgress.progress! : 0.0;
              return Center(
                child: CircleAvatar(
                  backgroundColor: loadingBgColor,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: height,
                        width: width,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4,
                          color: loadingColor,
                        ),
                      ),
                      Txt('${(progress * 100).toStringAsFixed(0)}%', fontSize: 12, textColor: Clr.colorPrimary),
                    ],
                  ),
                ),
              );
            },
            errorWidget: (context, url, error) => errorWidget??Container(
              height: height,
              width: width,
              decoration: pBoxDecoration(
                borderRadius: borderRadius ??
                    BorderRadius.circular(radius ?? Siz.defaultRadius),
              ),
              child: Image.asset(defaultImage, width: width, height: height,fit: fit,),
            ),
          );
        }
    );
  }
}
