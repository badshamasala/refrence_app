import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ShowNetworkImage extends StatelessWidget {
  final String imgPath;
  final double? imgWidth;
  final double? imgHeight;
  final BoxFit? boxFit;
  final String placeholderImage;
  const ShowNetworkImage(
      {Key? key,
      required this.imgPath,
      this.imgWidth,
      this.imgHeight,
      this.boxFit,
      this.placeholderImage = "assets/images/placeholder.jpg"})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    /* print(
        "---------ShowNetworkImage---------\nimgPath => $imgPath\nimgWidth => $imgWidth\nimgHeight => $imgHeight"); */
    return FadeInImage(
      fit: boxFit ?? BoxFit.contain,
      width: (imgWidth ?? MediaQuery.of(context).size.width),
      height: (imgHeight ?? 200),
      fadeInDuration: const Duration(milliseconds: 700),
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInCurve: Curves.easeIn,
      image: CachedNetworkImageProvider(imgPath),
      placeholder: AssetImage(placeholderImage),
      placeholderFit: boxFit ?? BoxFit.contain,
      placeholderErrorBuilder: (context, url, error) => Image(
        image: AssetImage(placeholderImage),
        width: (imgWidth ?? MediaQuery.of(context).size.width),
        height: (imgHeight ?? 200),
        fit: boxFit ?? BoxFit.contain,
      ),
      imageErrorBuilder: (context, url, error) => Image(
        image: AssetImage(placeholderImage),
        width: (imgWidth ?? MediaQuery.of(context).size.width),
        height: (imgHeight ?? 200),
        fit: boxFit ?? BoxFit.contain,
      ),
    );
  }
}
