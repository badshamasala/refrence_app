import 'package:aayu/controller/player/audio_player_controller.dart';
import 'package:aayu/model/model.dart';
import 'package:aayu/services/services.dart';
import 'package:aayu/theme/app_colors.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wakelock/wakelock.dart';

class AudioPlayList extends StatefulWidget {
  final String heroTag;
  final String playContentId;
  final String? growCategoryName;
  final List<Content?> categoryContent;
  const AudioPlayList(
      {Key? key,
      required this.heroTag,
      required this.playContentId,
      required this.categoryContent,
      this.growCategoryName})
      : super(key: key);

  @override
  State<AudioPlayList> createState() => _AudioPlayListState();
}

class _AudioPlayListState extends State<AudioPlayList>
    with WidgetsBindingObserver {
  late AssetsAudioPlayer audioPlayer;
  bool showPlay = true;
  bool audioFinished = true;
  late AudioPlayerController audioPlayerController;

  late Content? currentContent;
  int currentContentIndex = 0;
  DateTime startDate = DateTime.now();

  @override
  void initState() {
    try {
      WidgetsBinding.instance.addObserver(this);

      audioPlayerController = Get.put(AudioPlayerController());
      audioPlayerController.resetOptions();

      currentContent = widget.categoryContent.firstWhere((element) {
        return element!.contentId! == widget.playContentId;
      });

      currentContentIndex = widget.categoryContent.indexWhere((element) {
        return element!.contentId! == widget.playContentId;
      });
      currentContentIndex == -1 ? 0 : currentContentIndex;

      audioPlayer = AssetsAudioPlayer.newPlayer();
      audioPlayer.open(
        Playlist(
          startIndex: currentContentIndex,
          audios: List.generate(
            widget.categoryContent.length,
            (index) {
              return Audio.network(
                widget.categoryContent[index]!.contentPath!,
                metas: Metas(
                  id: widget.categoryContent[index]!.contentId,
                  title: widget.categoryContent[index]!.contentName,
                  artist: widget.categoryContent[index]!.artist!.artistName!,
                  image: MetasImage.network(
                    widget.categoryContent[index]!.contentImage!,
                  ),
                ),
              );
            },
          ),
        ),
        autoStart: true,
        showNotification: true,
        headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
        loopMode: LoopMode.playlist, //loop the full playlist
      );

      audioPlayer.playlistAudioFinished.listen((Playing playing) {
        int playIndex = playing.index;
        audioPlayerController.postContentCompletion(
            widget.categoryContent[playIndex]!.contentId!, -1);
        sendContentCompletedEvent(startDate, true);
      });

      audioPlayer.current.listen((Playing? playingAudio) {
        if (playingAudio != null) {
          int playIndex = playingAudio.index;
          setState(() {
            audioFinished = false;
            currentContent = widget.categoryContent[playIndex]!;
            startDate = DateTime.now();
          });
        }
      });

      audioPlayerController.postRecentContent(currentContent!.contentId!);
      Wakelock.enable();
    } catch (exp) {
      print("Exp => $exp");
      EventsService()
          .sendEvent("Audio_Player_Exception_${currentContent!.contentType!}", {
        "content_id": currentContent!.contentId,
        "content_name": currentContent!.contentName,
        "content_type": currentContent!.contentType,
        "artist_name": currentContent!.artist!.artistName!,
        "content_duration": currentContent!.metaData!.duration,
        "exception": exp.toString()
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    audioPlayer.stop();
    audioPlayer.dispose();
    Wakelock.disable();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        sendContentCompletedEvent(startDate, audioFinished);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: null,
          leading: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.close,
              size: 20,
              color: AppColors.whiteColor,
            ),
          ),
          actions: [
            InkWell(
              child: SvgPicture.asset(
                AppIcons.shareSVG,
                width: 17.w,
                height: 17.h,
                color: AppColors.whiteColor,
              ),
              onTap: () async {
                buildShowDialog(context);
                await ShareService().shareContent(
                    currentContent!.contentId!, currentContent!.contentImage!);

                EventsService().sendEvent("Grow_Content_Share", {
                  "content_id": currentContent!.contentId!,
                  "content_name": currentContent!.contentName!,
                  "artist_name": currentContent!.artist!.artistName!,
                  "content_type": currentContent!.contentType!,
                });
                Navigator.pop(context);
              },
            ),
            SizedBox(
              width: 26.w,
            ),
            InkWell(
              child: const Icon(
                Icons.playlist_play,
                size: 30,
                color: AppColors.whiteColor,
              ),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: false,
                  backgroundColor: Colors.black.withOpacity(0.5),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  builder: (context) {
                    return ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 26.h),
                      itemCount: widget.categoryContent.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: AppColors.whiteColor.withOpacity(0.2),
                        );
                      },
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8.w),
                                child: ShowNetworkImage(
                                  imgWidth: 60.w,
                                  imgHeight: 40.h,
                                  imgPath: widget
                                      .categoryContent[index]!.contentImage!,
                                  boxFit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: 16.w,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget
                                          .categoryContent[index]!.contentName!,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontSize: 14.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.w,
                                    ),
                                    Text(
                                      widget.categoryContent[index]!.artist!
                                          .artistName!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontFamily: 'Circular Std',
                                        fontSize: 14.sp,
                                        letterSpacing: 0,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 8.w,
                              ),
                              InkWell(
                                onTap: () {
                                  if (widget
                                          .categoryContent[index]!.contentId ==
                                      currentContent!.contentId) {
                                    setState(() {
                                      if (showPlay == false) {
                                        showPlay = true;
                                        audioPlayer.play();
                                      } else {
                                        showPlay = false;
                                        audioPlayer.pause();
                                      }
                                    });
                                  } else {
                                    audioPlayer.playlistPlayAtIndex(index);
                                  }

                                  Navigator.pop(context);
                                },
                                child:
                                    (widget.categoryContent[index]!.contentId ==
                                            currentContent!.contentId)
                                        ? (showPlay == true)
                                            ? Container(
                                                height: 26.h,
                                                width: 26.w,
                                                padding: EdgeInsets.zero,
                                                decoration: const BoxDecoration(
                                                    color: Color(0xFFAAFDB4),
                                                    shape: BoxShape.circle),
                                                child: const Icon(
                                                  Icons.pause,
                                                  size: 18,
                                                  color: AppColors.blackColor,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                AppIcons.playSVG,
                                                width: 26.w,
                                                height: 26.h,
                                                color: const Color(0xFFAAFDB4),
                                              )
                                        : SvgPicture.asset(
                                            AppIcons.playSVG,
                                            width: 26.w,
                                            height: 26.h,
                                            color: const Color(0xFFAAFDB4),
                                          ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
            SizedBox(
              width: 16.w,
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.zero,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Hero(
                tag: widget.heroTag,
                child: ShowNetworkImage(
                  imgPath: currentContent!.playBGImage!,
                  imgWidth: MediaQuery.of(context).size.width,
                  imgHeight: MediaQuery.of(context).size.height,
                  boxFit: BoxFit.cover,
                  placeholderImage:
                      "assets/images/placeholder/default_player_screen.jpg",
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color.fromRGBO(0, 0, 0, 1).withOpacity(0.3),
                      const Color.fromRGBO(0, 0, 0, 0).withOpacity(0.3),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 48.h,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        currentContent!.contentName!,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: AppColors.whiteColor,
                          fontFamily: 'Baskerville',
                          fontSize: 24.sp,
                          letterSpacing: 0,
                          fontWeight: FontWeight.normal,
                          height: 1.1666666666666667.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 13.h,
                    ),
                    Visibility(
                      visible: currentContent!.artist!.artistName != null &&
                          currentContent!.artist!.artistName!.isNotEmpty,
                      child: SizedBox(
                        height: 43.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 32.w,
                            ),
                            Expanded(
                              child: Text(
                                currentContent!.artist!.artistName ?? "",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(0.5),
                                  fontFamily: 'Circular Std',
                                  fontSize: 12.sp,
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.normal,
                                  height: 1.3333333333333333.h,
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40.w),
                              child: ShowNetworkImage(
                                imgWidth: 40.h,
                                imgHeight: 40.h,
                                imgPath: currentContent!.artist!.artistImage!,
                                boxFit: BoxFit.cover,
                                placeholderImage:
                                    "assets/images/placeholder.jpg",
                              ),
                            ),
                            SizedBox(
                              width: 32.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    audioPlayer.builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? infos) {
                        if (infos == null) {
                          return const Offstage();
                        }

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 26.w),
                              child: SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  activeTrackColor: const Color(0xFFAAFDB4),
                                  inactiveTrackColor: const Color.fromRGBO(
                                      196, 196, 196, 0.30000001192092896),
                                  trackShape:
                                      const RoundedRectSliderTrackShape(),
                                  trackHeight: 2.0,
                                  thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 8.0),
                                  thumbColor: const Color(0xFFAAFDB4),
                                  overlayColor: Colors.transparent,
                                  overlayShape: const RoundSliderOverlayShape(
                                      overlayRadius: 8.0),
                                  tickMarkShape:
                                      const RoundSliderTickMarkShape(),
                                  activeTickMarkColor: AppColors.whiteColor,
                                  inactiveTickMarkColor: Colors.black26,
                                  valueIndicatorShape:
                                      const PaddleSliderValueIndicatorShape(),
                                  valueIndicatorColor: AppColors.whiteColor,
                                  valueIndicatorTextStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                child: Slider(
                                  activeColor: const Color(0xFFAAFDB4),
                                  inactiveColor:
                                      AppColors.whiteColor.withOpacity(0.5),
                                  value: infos.currentPosition.inSeconds
                                      .toDouble(),
                                  min: 0,
                                  max: infos.duration.inSeconds.toDouble(),
                                  onChanged: (double value) {
                                    audioPlayer
                                        .seek(Duration(seconds: value.toInt()));
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 32.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    DateFormat.ms().format(
                                      DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        0,
                                        0,
                                        0,
                                        infos.currentPosition.inMilliseconds,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: const Color(0xFFD4DCE7),
                                      fontFamily: 'Circular Std',
                                      fontSize: 14.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w700,
                                      height: 1.6.h,
                                    ),
                                  ),
                                  Text(
                                    DateFormat.ms().format(
                                      DateTime(
                                        DateTime.now().year,
                                        DateTime.now().month,
                                        DateTime.now().day,
                                        0,
                                        0,
                                        0,
                                        infos.duration.inMilliseconds,
                                      ),
                                    ),
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: const Color(0xFFD4DCE7),
                                      fontFamily: 'Circular Std',
                                      fontSize: 14.sp,
                                      letterSpacing: 0,
                                      fontWeight: FontWeight.w700,
                                      height: 1.6.h,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            child: const Icon(
                              Icons.skip_previous,
                              size: 36,
                              color: Color(0xFFAAFDB4),
                            ),
                            onTap: () {
                              setState(() {
                                audioFinished = false;
                                audioPlayer.previous();
                              });
                            },
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              AppIcons.refreshSVG,
                              width: 24.w,
                              height: 24.h,
                              color: const Color(0xFFAAFDB4),
                            ),
                            onTap: () {
                              audioPlayer.seek(const Duration(seconds: 0),
                                  force: true);
                            },
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                if (showPlay == false) {
                                  showPlay = true;
                                  audioPlayer.play();
                                } else {
                                  showPlay = false;
                                  audioPlayer.pause();
                                }
                              });
                            },
                            child: (showPlay == true)
                                ? Container(
                                    height: 54.h,
                                    width: 54.w,
                                    padding: EdgeInsets.zero,
                                    decoration: const BoxDecoration(
                                        color: Color(0xFFAAFDB4),
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.pause,
                                      size: 24,
                                      color: AppColors.blackColor,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    AppIcons.playSVG,
                                    width: 54.w,
                                    height: 54.h,
                                    color: const Color(0xFFAAFDB4),
                                  ),
                          ),
                          InkWell(
                            child: SvgPicture.asset(
                              currentContent!.isFavourite == true
                                  ? AppIcons.favouriteFillSVG
                                  : AppIcons.favouriteSVG,
                              width: 24.w,
                              height: 24.h,
                              color: const Color(0xFFAAFDB4),
                            ),
                            onTap: () async {
                              EventsService().sendEvent(
                                  currentContent!.isFavourite! == true
                                      ? "Grow_Content_Unfavourite"
                                      : "Grow_Content_Favourite",
                                  {
                                    "content_id": currentContent!.contentId!,
                                    "content_name":
                                        currentContent!.contentName!,
                                    "artist_name":
                                        currentContent!.artist!.artistName!,
                                    "content_type":
                                        currentContent!.contentType!,
                                  });

                              buildShowDialog(context);
                              bool isFavourite =
                                  await audioPlayerController.favouriteContent(
                                      currentContent!.contentId!,
                                      !currentContent!.isFavourite!);
                              Navigator.pop(context);

                              if (isFavourite == true) {
                                setState(() {
                                  currentContent!.isFavourite =
                                      !currentContent!.isFavourite!;
                                });
                              }
                            },
                          ),
                          InkWell(
                            child: const Icon(
                              Icons.skip_next,
                              size: 36,
                              color: Color(0xFFAAFDB4),
                            ),
                            onTap: () {
                              setState(() {
                                audioFinished = false;
                                audioPlayer.next(keepLoopMode: true);
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 23.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  sendContentCompletedEvent(DateTime contentStartDate, bool audioFinshed) {
    int playDuration = DateTime.now().difference(contentStartDate).inSeconds;
    dynamic eventData = {
      "user_id": globalUserIdDetails?.userId,
      "content_id": currentContent!.contentId,
      "content_name": currentContent!.contentName,
      "content_type": currentContent!.contentType,
      "content_duration": currentContent!.metaData!.duration!,
      "artist_id": currentContent!.artist!.artistId!,
      "artist_name": currentContent!.artist!.artistName!,
      "play_duration": playDuration,
      "content_finished": audioFinshed,
      "grow_category": widget.growCategoryName,
    };

    EventsService().sendEvent("Grow_Content_Viewed", eventData);
  }
}
