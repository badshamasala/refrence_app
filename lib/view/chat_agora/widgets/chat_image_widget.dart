import 'package:agora_chat_sdk/agora_chat_sdk.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io' as io;

class ChatImageWidget extends StatefulWidget {
  final ChatFileMessageBody body;
  final bool self;
  const ChatImageWidget({Key? key, required this.body, required this.self})
      : super(key: key);

  @override
  State<ChatImageWidget> createState() => _ChatImageWidgetState();
}

class _ChatImageWidgetState extends State<ChatImageWidget> {
  bool showNetwork = true;
  bool isLoading = false;
  bool isInit = true;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (isInit) {
      if (widget.self) {
        if (mounted) {
          setState(() {
            isLoading = true;
          });
        }
        await io.File(widget.body.localPath).exists().then((value) {
          if (value) {
            showNetwork = false;
          }
        });

        if (mounted) {
          setState(() {
            isLoading = false;
          });
        }
      }
      isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.65;
    if (isLoading) {
      return SizedBox(
        width: width.w,
        height: 200.h,
      );
    }
    if (!showNetwork) {
      return Image.file(
        io.File(widget.body.localPath),
        width: width.w,
        fit: BoxFit.fitWidth,
      );
    }

    return FadeInImage(
      fit: BoxFit.fitWidth,
      width: width.w,
      fadeInDuration: const Duration(milliseconds: 700),
      fadeOutDuration: const Duration(milliseconds: 300),
      fadeInCurve: Curves.easeIn,
      image: CachedNetworkImageProvider(widget.body.remotePath ?? ""),
      placeholder: const AssetImage("assets/images/placeholder.jpg"),
      placeholderFit: BoxFit.contain,
      placeholderErrorBuilder: (context, url, error) => Image(
        image: const AssetImage("assets/images/placeholder.jpg"),
        width: width.w,
        fit: BoxFit.fitWidth,
      ),
      imageErrorBuilder: (context, url, error) => Image(
        image: const AssetImage("assets/images/placeholder.jpg"),
        width: width.w,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
