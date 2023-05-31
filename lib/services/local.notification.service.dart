import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:aayu/controller/deeplink/singular_deeplink_controller.dart';
import 'package:aayu/view/shared/shared.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:timezone/timezone.dart' as tz;

final StreamController<ReceivedLocalNotification?>
    didReceiveLocalNotificationStream =
    StreamController<ReceivedLocalNotification?>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class LocalNotificationService {
  handleAppLaunchedViaNotification() async {
    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        !kIsWeb && Platform.isLinux
            ? null
            : await flutterLocalNotificationsPlugin
                .getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      handleNavigation(
          notificationAppLaunchDetails!.notificationResponse?.payload!);
    }
  }

  listenSelectNotificationStream() {
    selectNotificationStream.stream.listen((String? payload) async {
      //handleNavigation(payload);
    });
  }

  handleNavigation(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      Map<String, dynamic> payloadData = jsonDecode(payload);
      print("Local Notification Received: payloadData =====>");
      print(payloadData);
      Navigator.of(Get.context!).popUntil((route) => route.isFirst);
      SingularDeepLinkController singularDeepLinkController = Get.find();
      singularDeepLinkController.storeData(payloadData);
      singularDeepLinkController.handleNavigation();
    } else {
      print("Local Notification Received: payloadData | Not Available =====>");
    }
  }

  Future<void> scheduleMoodReminder(DateTime scheduledTime) async {
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        MOOD_TRACKER_CHANNEL.channelId,
        MOOD_TRACKER_CHANNEL.channelName,
        channelDescription: MOOD_TRACKER_CHANNEL.channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await cancelReminder("MOOD_TRACKER");
    Map<String, dynamic> payloadData = {
      "screenName": "MOOD_TRACKER",
      "scheduledTime": scheduledTime.millisecondsSinceEpoch,
    };
    tz.TZDateTime nextScheduleDate =
        nextInstanceOfTime(scheduledTime.hour, scheduledTime.minute);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(100000),
      "How are you feeling today?",
      "Take a sec to track your mood today. Your mental health matters and keeping a record of how you feel can help you take care of yourself better. You're not alone - let's do this!",
      nextScheduleDate,
      notificationDetails,
      payload: jsonEncode(payloadData),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleSleepReminder(DateTime scheduledTime) async {
    String title = "How'd you sleep?";
    String body = "Don't forget to track your sleep for last night. Take a moment to record how many hours you got and how you're feeling this morning. - let's make today a good one!";
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        MOOD_TRACKER_CHANNEL.channelId,
        MOOD_TRACKER_CHANNEL.channelName,
        channelDescription: MOOD_TRACKER_CHANNEL.channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await cancelReminder("SLEEP_TRACKER");
    Map<String, dynamic> payloadData = {
      "screenName": "SLEEP_TRACKER",
      "scheduledTime": scheduledTime.millisecondsSinceEpoch,
    };
    await flutterLocalNotificationsPlugin.zonedSchedule(
      Random().nextInt(100000),
      title,
      body,
      nextInstanceOfTime(scheduledTime.hour, scheduledTime.minute),
      notificationDetails,
      payload: jsonEncode(payloadData),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> scheduleWaterReminder(
      DateTime fromTime, DateTime toTime, Duration duration) async {
    String title = "Drink Water Reminder";
    String body = "It's time to drink some water! Take a break from what you're doing and grab a glass of water. Your body will thank you!";
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        WATER_INTAKE_TRACKER_CHANNEL.channelId,
        WATER_INTAKE_TRACKER_CHANNEL.channelName,
        channelDescription: WATER_INTAKE_TRACKER_CHANNEL.channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await cancelReminder("WATER_INTAKE_TRACKER");
    DateTime scheduledDate = fromTime;
    while (scheduledDate.compareTo(toTime) <= 0) {
      Map<String, dynamic> payloadData = {
        "screenName": "WATER_INTAKE_TRACKER",
        "scheduledDate": scheduledDate.millisecondsSinceEpoch,
        "fromTime": fromTime.millisecondsSinceEpoch,
        "toTime": toTime.millisecondsSinceEpoch,
        "duration": duration.inMinutes
      };
      tz.TZDateTime nextScheduleDate =
          nextInstanceOfTime(scheduledDate.hour, scheduledDate.minute);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        Random().nextInt(100000),
        title,
        body,
        nextScheduleDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: jsonEncode(payloadData),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      scheduledDate = scheduledDate.add(duration);
    }
  }

  Future<void> scheduleWeightTracker(
      List<String> selectedDays, int hour, int minute) async {
    String title = 'Progress Check-In';
    String body = "Hey, it's time to weigh yourself and check in on your progress. Don't forget to celebrate your wins, big or small, along the way. You're doing amazing - keep it up!";
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        WEIGHT_TRACKER_CHANNEL.channelId,
        WEIGHT_TRACKER_CHANNEL.channelName,
        channelDescription: WEIGHT_TRACKER_CHANNEL.channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: false,
        ticker: 'ticker',
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await cancelReminder("WEIGHT_TRACKER");
    for (var index = 0; index < selectedDays.length; index++) {
      int day = 0;
      switch (selectedDays[index]) {
        case "MON":
          day = DateTime.monday;
          break;
        case "TUE":
          day = DateTime.tuesday;
          break;
        case "WED":
          day = DateTime.wednesday;
          break;
        case "THU":
          day = DateTime.thursday;
          break;
        case "FRI":
          day = DateTime.friday;
          break;
        case "SAT":
          day = DateTime.saturday;
          break;
        case "SUN":
          day = DateTime.sunday;
          break;
      }
      tz.TZDateTime scheduleDate = nextInstanceOfDayAndTime(day, hour, minute);
      Map<String, dynamic> payloadData = {
        "screenName": "WEIGHT_TRACKER",
        "scheduledDate": scheduleDate.millisecondsSinceEpoch,
        "selectedDay": selectedDays[index],
        "day": day,
      };
      await flutterLocalNotificationsPlugin.zonedSchedule(
        day,
        title,
        body,
        scheduleDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: jsonEncode(payloadData),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> schedulePrgoramReminder(
      List<String> selectedDays, int hour, int minute) async {
    String title = 'Daily Practice Reminder!';
    String body =
        "It's time to connect with your breath, move your body, and find inner peace.";
    NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        PROGRAM_REMINDER_CHANNEL.channelId,
        PROGRAM_REMINDER_CHANNEL.channelName,
        channelDescription: PROGRAM_REMINDER_CHANNEL.channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        autoCancel: false,
        ticker: 'ticker',
        audioAttributesUsage: AudioAttributesUsage.alarm,
      ),
      iOS: const DarwinNotificationDetails(),
    );
    await cancelReminder("PROGRAM_REMINDER");
    for (var index = 0; index < selectedDays.length; index++) {
      int day = 0;
      switch (selectedDays[index].toUpperCase()) {
        case "MON":
          day = DateTime.monday;
          break;
        case "TUE":
          day = DateTime.tuesday;
          break;
        case "WED":
          day = DateTime.wednesday;
          break;
        case "THU":
          day = DateTime.thursday;
          break;
        case "FRI":
          day = DateTime.friday;
          break;
        case "SAT":
          day = DateTime.saturday;
          break;
        case "SUN":
          day = DateTime.sunday;
          break;
      }
      tz.TZDateTime scheduleDate = nextInstanceOfDayAndTime(day, hour, minute);
      Map<String, dynamic> payloadData = {
        "screenName": "PROGRAM_REMINDER",
        "scheduledDate": scheduleDate.millisecondsSinceEpoch,
        "selectedDay": selectedDays[index],
        "day": day,
      };
      await flutterLocalNotificationsPlugin.zonedSchedule(
        day,
        title,
        body,
        scheduleDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: jsonEncode(payloadData),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  Future<void> cancelReminder(String type) async {
    String title = "";
    if (type == "MOOD_TRACKER") {
      title = "Mood Tracker Reminder";
    } else if (type == "SLEEP_TRACKER") {
      title = "How'd you sleep?";
    } else if (type == "WATER_INTAKE_TRACKER") {
      title = "Drink Water Reminder";
    } else if (type == "WEIGHT_TRACKER") {
      title = "Progress Check-In";
    } else if (type == "PROGRAM_REMINDER") {
      title = "Daily Practice Reminder!";
    }
    List<PendingNotificationRequest> pendingNotification =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    if (pendingNotification.isNotEmpty) {
      for (var index = 0; index < pendingNotification.length; index++) {
        if (pendingNotification[index].title! == title) {
          await flutterLocalNotificationsPlugin
              .cancel(pendingNotification[index].id);
        }
      }
    }
  }

  tz.TZDateTime nextInstanceOfDayAndTime(int day, int hour, int minute) {
    tz.TZDateTime scheduledDate = nextInstanceOfTime(hour, minute);
    while (scheduledDate.weekday != day) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}

class LocalNotificationChannel {
  LocalNotificationChannel({
    required this.channelId,
    required this.channelName,
    required this.channelDesc,
  });

  final String channelId;
  final String channelName;
  final String channelDesc;
}

class ReceivedLocalNotification {
  ReceivedLocalNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}
