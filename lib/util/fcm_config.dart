import 'package:app3/util/constants.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class FCMConfig {
 static  FirebaseMessaging   _firebaseMessaging = new FirebaseMessaging();
FCMConfig(){
fcmConfig();


}


static fcmConfig() async{
  debugPrint('config notfication');
   firebaseMessaging.configure(

 onMessage: (Map<String, dynamic> message) async {
         debugPrint('new message');
        Get.defaultDialog(title: message['notification']['title']);
        },
      onLaunch: (Map<String, dynamic> message) async {
          
          switch (message['screen']) {
          case 'lecture_details':
     //       Get.to(LectureDisscusion(message['lecture']));

            break;

          case 'event_details':
       //     Get.to(EventDeitals(message['event']));
            break;
          default:
        }



      },
      onResume: (Map<String, dynamic> message) async {
        
     switch (message['screen']) {
       case  'lecture_details' :
         //Get.to(LectureDisscusion(message['lecture']));
         
         break;

         case 'event_details':
         // Get.to(EventDeitals(message['event']));
          break;
       default:
     }

      },

   );
}

static routes(){}


static _handleOnMessage(Map<dynamic, dynamic>  data){



}

static _handleOnResume(Map<dynamic, dynamic> data){

}

static _handleOnLaunch(Map<dynamic, dynamic>  data){

}


static subscripeToTopic(String topic){
 _firebaseMessaging.subscribeToTopic(topic);
}
static unSubscripeToTopic(String topic) {
   _firebaseMessaging.unsubscribeFromTopic(topic);
}
static Future<String>  getToken() async{
  return await _firebaseMessaging.getToken();
}





}