import 'package:flutter/material.dart';
import 'package:flutter_fcm/LocalNotificationService.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: MaterialButton(
          onPressed: () async{
            await service.showNotification(id: 0, title: 'Notification title', body: 'some body');
          },
          child: Text(
            "Notification",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}
