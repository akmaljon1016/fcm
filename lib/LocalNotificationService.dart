import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NotificationService {
  static final _notification = FlutterLocalNotificationsPlugin();

  static Future _notificationDetail() async {
    return const NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channelname',
          channelDescription: "channel description",
          importance: Importance.high),
      iOS: DarwinNotificationDetails(),
    );
  }

  static Future init({bool initSchedule = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        "Add",
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      ),
    ];

    final ios = DarwinInitializationSettings(
        notificationCategories: darwinNotificationCategories);
    final settings = InitializationSettings(android: android, iOS: ios);

    await _notification.initialize(settings);
  }

  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    await _notification.show(id, title, body, await _notificationDetail(),
        payload: payload);
  }

  static Future showNotificationWithAction() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails("channel id", "channelname",
            channelDescription: "",
            importance: Importance.max,
            actions: [
          AndroidNotificationAction("Action1", "Action1", contextual: true),
          AndroidNotificationAction("Action1", "Action2", contextual: true),
          AndroidNotificationAction("Action1", "Action3", contextual: true),
        ]);
    await _notification.show(0, "sas", "sas",
        await NotificationDetails(android: androidNotificationDetails));
  }


  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }

  Future<void> showBigPictureNotification() async {
    final String largeIconPath = await _downloadAndSaveFile(
        'https://via.placeholder.com/48x48', 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(
        'https://via.placeholder.com/400x800', 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation =
    BigPictureStyleInformation(FilePathAndroidBitmap(bigPicturePath),
        largeIcon: FilePathAndroidBitmap(largeIconPath),
        contentTitle: 'overridden <b>big</b> content title',
        htmlFormatContentTitle: true,
        summaryText: 'summary <i>text</i>',
        htmlFormatSummaryText: true);
    final AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        channelDescription: 'big text channel description',
        styleInformation: bigPictureStyleInformation);
    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidNotificationDetails);
    await _notification.show(
        0, 'big text title', 'silent body', notificationDetails);
  }


}
