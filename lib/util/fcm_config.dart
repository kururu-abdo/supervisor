import 'dart:convert';

import 'package:app3/model/models/notification.dart';
import 'package:app3/util/constants.dart';
import 'package:app3/util/local_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import '../main.dart';


class FCMConfig {
FCMConfig(){
fcmConfig();


}

static fcmConfig() async {
    debugPrint('config notfication');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
     
RemoteNotification notification = message.notification;
  AndroidNotification android = message.notification.android;
    if (notification != null && android != null) {
  DBProvider.db.newNotification(LocalNotification(
        title: notification.title,
        object: json.encode(message.data),
        body: notification.body,
        time: DateTime.now().millisecondsSinceEpoch));
    flutterLocalNotificationsPlugin.show(
      notification?.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
      android:   AndroidNotificationDetails(
            'channel', 'channelName', 'channelDescription')

        // android:
        //  AndroidNotificationDetails(
        //   channel.id,
        //   channel.name,
        //   channel.description,
        //   // TODO add a proper drawable resource to android, for now using
        //   //      one that already exists in example app.
        //   icon: 'launch_background',
        // ),
         , 
      ) ,  
      
      
      );

    }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;

        if (notification != null && android != null) {
  DBProvider.db.newNotification(LocalNotification(
        title: notification.title,
        object: json.encode(message.data),
        body: notification.body,
        time: DateTime.now().millisecondsSinceEpoch));
    flutterLocalNotificationsPlugin.show(
      notification?.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
     android:    AndroidNotificationDetails(
            'channel', 'channelName', 'channelDescription')

        // android:
        //  AndroidNotificationDetails(
        //   channel.id,
        //   channel.name,
        //   channel.description,
        //   // TODO add a proper drawable resource to android, for now using
        //   //      one that already exists in example app.
        //   icon: 'launch_background',
        // ),
         
      ) ,  
      
      
      );

    }
    
    });

// RemoteMessage initialMessage =
//         await FirebaseMessaging.instance.getInitialMessage();

// debugPrint(initialMessage?.data.toString());

//     if (initialMessage?.data['type'] != 'chat') {
//    Get.toNamed('notification');
//     }

    FirebaseMessaging.onBackgroundMessage((message) async {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification.android;

           if (notification != null && android != null) {
  DBProvider.db.newNotification(LocalNotification(
        title: notification.title,
        object: json.encode(message.data),
        body: notification.body,
        time: DateTime.now().millisecondsSinceEpoch));
    flutterLocalNotificationsPlugin.show(
      notification?.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
      android  : AndroidNotificationDetails(
            'channel', 'channelName', 'channelDescription')

        // android:
        //  AndroidNotificationDetails(
        //   channel.id,
        //   channel.name,
        //   channel.description,
        //   // TODO add a proper drawable resource to android, for now using
        //   //      one that already exists in example app.
        //   icon: 'launch_background',
        // ),
         
      ) ,  
      
      
      );

    }
});
  }

static subscripeToTopic(String topic){
   FirebaseMessaging.instance.subscribeToTopic(topic);
}
static unSubscripeToTopic(String topic) {
     FirebaseMessaging.instance.unsubscribeFromTopic(topic);
}
static Future<String>  getToken() async{
  return await   FirebaseMessaging.instance.getToken();
}





}