import 'package:aayu/model/model.dart';
import 'package:aayu/services/local.notification.service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:hypersdkflutter/hypersdkflutter.dart';

enum SnackBarMessageTypes {
  Info,
  Error,
  Success,
  Warning,
}

int defaultAnimateToPageDuration = 300;

UserRegistrationResponse? globalUserIdDetails;
SubscriptionCheckResponse? subscriptionCheckResponse;

final GlobalKey<NavigatorState> navState = GlobalKey<NavigatorState>();
AppProperties appProperties = AppProperties();

HyperSDK hyperSDK = HyperSDK();
FirebaseRemoteConfig? remoteConfigData;

enum TimeFormat {
  showDate,
  showHours,
  showMinutes,
  showSeconds,
}

//Local Notification Channels
LocalNotificationChannel MOOD_TRACKER_CHANNEL = LocalNotificationChannel(
    channelId: "MOOD_TRACKER",
    channelName: "Mood Tracker",
    channelDesc: "Mood Tracker");
LocalNotificationChannel SLEEP_TRACKER_CHANNEL = LocalNotificationChannel(
    channelId: "SLEEP_TRACKER",
    channelName: "Sleep Tracker",
    channelDesc: "Sleep Tracker");
LocalNotificationChannel WATER_INTAKE_TRACKER_CHANNEL =
    LocalNotificationChannel(
        channelId: "WATER_INTAKE",
        channelName: "Water Intake Tracker",
        channelDesc: "Water Intake Tracker");
LocalNotificationChannel WEIGHT_TRACKER_CHANNEL = LocalNotificationChannel(
    channelId: "WEIGHT_TRACKER",
    channelName: "Weight Tracker",
    channelDesc: "Weight Tracker");
LocalNotificationChannel PROGRAM_REMINDER_CHANNEL = LocalNotificationChannel(
    channelId: "PROGRAM_REMINDER",
    channelName: "Program Reminder",
    channelDesc: "Program Reminder");