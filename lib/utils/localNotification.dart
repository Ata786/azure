import 'package:SalesUp/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz2;

class LocalNotification {
  static FlutterLocalNotificationsPlugin plugin =  FlutterLocalNotificationsPlugin();

  static initializeLocalNotification() async {
    AndroidInitializationSettings androidSettings =
    const AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) {
      // display a dialog with the notification details, tap ok to go to another page
      showDialog(
        context: Get.context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(title!),
          content: Text(body!),
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
              },
            )
          ],
        ),
      );
    });

    final InitializationSettings initializationSettings =
    InitializationSettings(
        android: androidSettings, iOS: initializationSettingsDarwin);

    await plugin.initialize(initializationSettings);
  }

  static Future<void> showLocalNotification(String channelId,
      String channelName, int id, String title, String body) async {
    AndroidNotificationDetails details = AndroidNotificationDetails(
      channelId,
      channelName,
      icon: '@mipmap/ic_launcher',
      color: themeColor,
      priority: Priority.max,
      importance: Importance.max,
      playSound: true,
      audioAttributesUsage: AudioAttributesUsage.notificationEvent,
      enableVibration: true,
    );

    NotificationDetails notificationDetails =
    NotificationDetails(android: details);

    await plugin.show(id, title, body, notificationDetails);
  }

  static Future<void> showScheduledLocalNotification(
      String channelId,
      String channelName,
      int id,
      String title,
      String body,) async {
    tz2.initializeTimeZones();

    final now = DateTime.now();
    final scheduledTime = now.add(Duration(seconds: 5));

    AndroidNotificationDetails details = AndroidNotificationDetails(
      channelId,
      channelName,
      icon: '@mipmap/ic_launcher',
      color: themeColor,
      priority: Priority.max,
      importance: Importance.max,
      playSound: true,
      audioAttributesUsage: AudioAttributesUsage.notificationEvent,
      enableVibration: true,
    );

    await plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(android: details),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  static Future<void> showPriodicallyNotification(String channelId,String channelName,int id,String title,String body,)async{


    AndroidNotificationDetails details = AndroidNotificationDetails(
      channelId,
      channelName,
      icon: '@mipmap/ic_launcher',
      color: themeColor,
      priority: Priority.max,
      importance: Importance.max,
      playSound: true,
      audioAttributesUsage: AudioAttributesUsage.notificationEvent,
      enableVibration: true,
    );

    NotificationDetails notificationDetails =
    NotificationDetails(android: details);


    await plugin.periodicallyShow(id, title, body, RepeatInterval.everyMinute, notificationDetails,androidAllowWhileIdle: true,androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);


  }


}
