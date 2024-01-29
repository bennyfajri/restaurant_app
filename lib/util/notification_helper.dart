import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/models/restaurant_list.dart';
import 'package:restaurant_app/util/constant.dart';
import 'package:rxdart/subjects.dart';

import '../common/navigation.dart';
import '../provider/restaurant_provider.dart';

final selectNotificationSubject = BehaviorSubject<String>();

class NotificationHelper {
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initNotifications(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      if (payload != null) {
        dev.log('notification payload: $payload');
      }
      selectNotificationSubject.add(payload ?? 'empty payload');
    });
  }

  Future<void> showNotification(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      RestaurantsResult restaurants) async {
    var channelId = "1";
    var channelName = "channel_01";
    var channelDescription = "drsync restaurant channel";

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
        styleInformation: const DefaultStyleInformation(true, true));

    var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    var titleNotification = "<b>Rekomendasi Untukmu</b>";
    var titleRestaurant =
        "${getRecommendationText()} ${restaurants.restaurants?[Random().nextInt(restaurants.restaurants!.length)].name}";

    await flutterLocalNotificationsPlugin.show(
        0, titleNotification, titleRestaurant, platformChannelSpecifics,
        payload: json.encode(restaurants.toJson()));
  }

  void configureSelectNotificationSubject(String route, BuildContext context) {
    selectNotificationSubject.stream.listen(
      (String payload) async {
        var data = RestaurantsResult.fromJson(json.decode(payload));
        var restaurant = data.restaurants![0];
        Provider.of<RestaurantProvider>(
          context,
          listen: false,
        ).fetchDetailRestaurant(restaurant.id);
        Navigation.intentWithData(route, restaurant.pictureId);
      },
    );
  }
}
