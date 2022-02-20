
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../my_widgets.dart';
import '../utils/utils.dart';
import 'loading.dart';


class GetImage extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final BoxFit fit;
  final double radius;
  final bool isAssets;
  final Color? imageColor, loadingColor;
  final BorderRadius? borderRadius;
  const GetImage({Key? key, this.imagePath = '', this.width = Siz.profileImageSize, this.height = Siz.profileImageSize, this.fit = BoxFit.cover, this.radius = Siz.defaultRadius, this.isAssets = false, this.imageColor, this.borderRadius, this.loadingColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageUrl = imagePath.isEmpty?'assets/images/logo_dark.png':imagePath;
    bool isAsset = isAssets;
    if(imagePath.isEmpty){
      isAsset = true;
    }
    return ClipRRect(
      borderRadius: borderRadius??BorderRadius.circular(radius),
      child: isAsset
          ?
      SizedBox(
        height: height, width: width,
        child: Image.asset(imageUrl, color: imageColor, width: width, height: height, fit: fit,),
      )
          :
      CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(image: DecorationImage(image: imageProvider, fit: fit,),),
        ),
        placeholder: (context, url) => Container(
          height: height,
          width: width,
          decoration: pBoxDecoration(
            borderRadius: borderRadius??BorderRadius.circular(radius),
          ),
          child: LoadingPro(valueColor: loadingColor??Clr.colorPrimary,),
        ),
        errorWidget: (context, url, error) =>
            Container(
              height: height,
              width: width,
              decoration: pBoxDecoration(
                borderRadius: borderRadius??BorderRadius.circular(radius),
              ),
              child: const Icon(Icons.error),
            ),
      ),
    );
  }
}