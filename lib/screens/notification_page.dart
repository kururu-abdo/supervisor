import 'dart:convert';

import 'package:app3/model/models/chat_user.dart';
import 'package:app3/model/models/notification.dart';
import 'package:app3/screens/chat_page.dart';
import 'package:app3/screens/events.dart';
import 'package:app3/util/local_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';


class NotificationPage extends StatefulWidget {
  static const String page_id = 'notification';

  NotificationPage();

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Scaffold(
      appBar: AppBar(
          title: Text('الإشعارات'),
          centerTitle: true,
          actions: [IconButton(icon: Icon(Icons.home), onPressed: () {})]),
      body: FutureBuilder<List<LocalNotification>>(
        future: DBProvider.db.getAllNotification(),
        builder: (BuildContext context,
            AsyncSnapshot<List<LocalNotification>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                LocalNotification item = snapshot.data[index];
                return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.red),
                    onDismissed: (direction) {
                      // DBProvider.db.del(item.id);
                    },
                    child: InkWell(
                      onTap: () {
                        debugPrint(item.object);
                        var object = json.decode(item.object);
                        debugPrint(object.toString());
                        var screen = object['screen'];

                        var data = json.decode(object["data"]);
                        //chat
                        if (object["type"] == "message") {
                          var me = User.fromJson(object["receiver"]);
                          var user = User.fromJson(object["sender"]);
                          Get.to(ChatPage(me: me, user: user));
                        }
                        //event
                    
                      },
                      child: Container(
                        width: double.infinity,
                        child: Card(
                          elevation: 8.0,
                          color: item.isRead ? Colors.white : Colors.lightBlue,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(item.title),
                                  Text(formatedDate(item.time)),
                                ],
                              ),
                              Text(item.body ?? ''),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FlatButton(
                                      onPressed: () async {
                                        await DBProvider.db.delete(item.id);

                                        Fluttertoast.showToast(
                                            msg: "تم مسح الاشعار ",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            timeInSecForIosWeb: 1,
                                            backgroundColor: Colors.green,
                                            textColor: Colors.white,
                                            fontSize: 16.0);
                                        setState(() {});
                                      },
                                      child: Text("حذف")),
                                  FlatButton(
                                      onPressed: () async {
                                        var notification = item;
                                        notification.isRead = true;
                                        DBProvider.db
                                            .updateNotifica(notification);
                                        setState(() {});
                                      },
                                      child: Text("تحديد كمقروء")),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )

                    //                 ListTile(
                    //                   title: Text(item.title),
                    //                   leading: Text(item.id.toString()),
                    //                   trailing: Checkbox(
                    //                     onChanged: (bool value) {
                    //                       DBProvider.db.updateNotifica(item);
                    //                       DBProvider.db.getAllNotification();
                    //                       setState(() {});
                    //                     },
                    //                     value: item.isRead,
                    //                   ),

                    //                   onTap: (){
                    //                     debugPrint(item.object);
                    //                     var object =  json.decode(item.object);
                    //  debugPrint(object.toString());
                    //  var screen =  object['screen'];
                    //  //chat

                    //  //event

                    //  //comment

                    //                   },
                    //                 ),
                    );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ));
  }

  formatedDate(int t) {
    var date = DateTime.fromMillisecondsSinceEpoch(t);
    String txt = '';
    if (date == DateTime.now()) {
      txt = 'الان';
    } else {
      var now = DateTime.now();
      var diff = now.difference(date);

      if (diff.inDays <= 0 && diff.inHours <= 0) {
        txt = 'قبل   ${diff.inMinutes}  دقايق';
      } else if (diff.inDays <= 0 && diff.inHours >= 1) {
        txt = 'قبل   ${diff.inHours}  ساعات';
      } else {
        var defaultTime = DateTime.now().subtract(diff);

        txt = '${defaultTime.day}-${defaultTime.month}-${defaultTime.year}';
      }
    }

    return txt;
  }
}
