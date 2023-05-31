import 'package:cast/cast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as path;
import '../../model/grow/grow.page.content.model.dart';

class CastController extends GetxController {
  List<CastDevice>? listCastdDevices;
  CastSession? session;
  RxBool isSearching = false.obs;
  RxBool showControls = false.obs;
  RxDouble volume = 1.0.obs;
  double currentTime = 0.0;
  int mediaSessionId = 0;
  Rx<PlayerState> playerState = PlayerState.IDLE.obs;

  Future<void> searchCastDevices() async {
    isSearching.value = true;
    listCastdDevices = await CastDiscoveryService().search();
    for (var element in listCastdDevices!) {
      print(element.name);
    }
    isSearching.value = false;
  }

  switchShowControls(bool boolean) {
    showControls.value = boolean;
  }

  Future<void> connectAndPlayMedia(BuildContext context, CastDevice object,
      Content content, String? healingTitle) async {
    session = await CastSessionManager().startSession(object);
    session!.stateStream.listen((state) {
      if (state == CastSessionState.connected) {
        // const snackBar = SnackBar(content: Text('Connected'));
        // Scaffold.of(context).showSnackBar(snackBar);
      }
    });

    var index = 0;
    session!.messageStream.listen((message) {
      index += 1;
      //print('receive message: $message');
      if (message['type'] == 'MEDIA_STATUS') {
        List<dynamic> status = message['status'] as List<dynamic>? ?? [];
        Map<String, dynamic>? map =
            status.isNotEmpty ? status.last as Map<String, dynamic> : null;
        if (map != null) {
          currentTime = (map['currentTime'] ?? 0.0) as double;
          mediaSessionId = map['mediaSessionId'] ?? 0;
          switch (map['playerState']) {
            case 'PLAYING':
              playerState.value = PlayerState.PLAYING;
              break;
            case 'PAUSED':
              playerState.value = PlayerState.PAUSED;
              break;
            case 'IDLE':
              playerState.value = PlayerState.IDLE;
              break;
            default:
          }
        }
      }

      if (index == 2) {
        Future.delayed(const Duration(seconds: 5)).then((x) {
          _sendMessagePlayVideo(session!, content, healingTitle);
        });
      }
    });

    session!.sendMessage(CastSession.kNamespaceReceiver, {
      'type': 'LAUNCH',
      'appId': '7A9AC602', // set the appId of your app here
    });
  }

  void _sendMessagePlayVideo(
      CastSession session, Content content, String? healingTitle) {
    print('_sendMessagePlayVideo');

    String contentType = "";
    String extension = path.extension(content.contentPath!);
    if (content.contentType!.toUpperCase() == "VIDEO") {
      if (extension == ".m3u8") {
        contentType = 'video/m3u8';
      } else if (extension == ".mp4") {
        contentType = 'video/mp4';
      }
    } else if (content.contentType!.toUpperCase() == 'AUDIO' ||
        content.contentType!.toUpperCase() == 'MUSIC') {
      contentType = 'audio/mp3';
    }

    var message = {
      // Here you can plug an URL to any mp4, webm, mp3 or jpg file with the proper contentType.
      'contentId': content.contentPath,
      'contentType': contentType,
      'streamType': 'BUFFERED', // or LIVE
      // Title and cover displayed while buffering
      'metadata': {
        'type': 0,
        'metadataType': 0,
        'title': healingTitle ?? content.contentName,
        'images': [
          {'url': content.contentImage}
        ]
      }
    };

    session.sendMessage(CastSession.kNamespaceMedia, {
      'type': 'LOAD',
      'autoPlay': true,
      'currentTime': 0,
      'media': message,
    });
  }

  pauseVideo() {
    if (session != null) {
      if (playerState.value == PlayerState.PLAYING) {
        session!.sendMessage(CastSession.kNamespaceMedia,
            {'type': 'PAUSE', 'mediaSessionId': mediaSessionId});
      }
      if (playerState.value == PlayerState.PAUSED) {
        session!.sendMessage(CastSession.kNamespaceMedia,
            {'type': 'PLAY', 'mediaSessionId': mediaSessionId});
      }
    }
  }

  plus10() {
    if (session != null) {
      session!.sendMessage(CastSession.kNamespaceMedia,
          {'type': 'GET_STATUS', 'mediaSessionId': mediaSessionId});
      session!.sendMessage(CastSession.kNamespaceMedia, {
        'type': 'SEEK',
        'currentTime': currentTime + 10.0,
        'mediaSessionId': mediaSessionId
      });
    }
  }

  minus10() {
    if (session != null) {
      session!.sendMessage(CastSession.kNamespaceMedia,
          {'type': 'GET_STATUS', 'mediaSessionId': mediaSessionId});
      session!.sendMessage(CastSession.kNamespaceMedia, {
        'type': 'SEEK',
        'currentTime': currentTime - 10.0,
        'mediaSessionId': mediaSessionId
      });
    }
  }

  closeSession() {
    if (session != null) {
      session!.close();
      session = null;
    }
  }

  // setVolume(double val) {
  //   volume.value = val;

  //   print(double.parse(volume.value.toStringAsFixed(2)));
  //   session!.sendMessage(CastSession.kNamespaceMedia, {
  //     'type': 'VOLUME',
  //     'volume': {'level': volume.value},
  //     'mediaSessionId': mediaSessionId
  //   });
  // }
}

enum PlayerState { PLAYING, BUFFERING, IDLE, PAUSED }
