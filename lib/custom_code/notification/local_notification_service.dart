import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../thong_bao/thong_bao_cham_cong_widget.dart';

class LocalNoticationService {
  static final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize(BuildContext context) {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));

    _notificationPlugin.initialize(initializationSettings,
        onSelectNotification: (String? message) async {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ThongBaoChamCongWidget(),
        ),
      );
    });
  }

  static void showNotificationOnForeground(RemoteMessage message) {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      const notificationDetail = NotificationDetails(
          android: AndroidNotificationDetails(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.max,
        priority: Priority.high,
      ));

      _notificationPlugin.show(id, message.notification!.title,
          message.notification!.body, notificationDetail,
          payload: "test");
    } on Exception catch (e) {
      print(e);
    }
  }
}
