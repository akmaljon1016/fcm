import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'LocalNotificationService.dart';
import 'package:http/http.dart' as http;
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("A big message just showed up:${message.messageId}");
}

Future getDeviceToken() async {
  FirebaseMessaging firebaseMessage = FirebaseMessaging.instance;
  String? deviceToken = await firebaseMessage.getToken();
  return (deviceToken == null) ? "token yo'q" : deviceToken;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  init() async {
    String deviceToken = await getDeviceToken();
    print("######### PRINT DEVICE TOKEN");
    print(deviceToken);
    print("####################################");

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Notification Title: ${message.notification!.title}');
        print('Notification Body: ${message.notification!.body}');
        NotificationService.showNotification(
            id: 0,
            title: message.data!['message'],
            body: message.data!['imageUrl']);
      }
    });
  }



  @override
  void initState() {
    super.initState();
    NotificationService.init();
    init();
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? androidNotification = message.notification?.android;
    //   if (notification != null && androidNotification != null) {
    //     NotificationService.showNotification();
    //   }
    // });
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   print("A new onMessageOpenedApp event was published");
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: MaterialButton(
            onPressed: () {
              //NotificationService.showNotificationWithAction();
              NotificationService().showBigPictureNotification();
            },
            child: Text("Noti"),
            color: Colors.cyan,
          ),
        ),
      ),
    );
  }
}
