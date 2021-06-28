import 'package:app3/logic/event_provider.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/event.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/screens/add_event.dart';
import 'package:app3/screens/edit_event.dart';
import 'package:app3/screens/event_details.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/pop_up_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Events extends StatefulWidget {
  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<Events> {
  @override
  Widget build(BuildContext context) {
   


    var event_provider = Provider.of<EventProvider>(context);
    return Scaffold(
     

      
      appBar: AppBar(
      
      
        elevation: 0.0,
        
        title: Text('الأخبار'),
        centerTitle: true,
        
   
      ),
      body: 
      
      Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: event_provider.getEvents(), 
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          if (!snapshot.hasData) {
              return Center(
                child: Text('no events yet'),
              );
            }
            return ListView(
              children: snapshot.data
              .docs
                  .map((event) =>  SwipeActionCell(
                          key: ObjectKey(event.id),

                          ///this key is necessary
                          trailingActions: <SwipeAction>[
                            SwipeAction(
                                title: "حذف",
                                onTap: (CompletionHandler handler) async {

await event_provider.deleteevent(new Event( event.data()['id'] ,

                                        event.data()['title'] ,
                                        event.data()['body'] ,
                                        event.data()['files']   ,
                                        Level.fromJson(event.data()['level']) ,
                                        Department.fromJson(
                                              event.data()['level'])
                                          ));                                  setState(() {});
                                },
                               ),
                                 SwipeAction(

                                   color: Colors.green,
                                title: "تعديل",
                                onTap: (CompletionHandler handler) async {
 Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (_) {
                                    return EditEvent(
                                   new Event( event.data()['id'] ,

                                        event.data()['title'] ,
                                        event.data()['body'] ,
                                        event.data()['files']   ,
                                        Level.fromJson(event.data()['level']) ,
                                        Department.fromJson(
                                              event.data()['level'])
                                          )
                                  
                                    );
                                  }));
                                  
                                  setState(() {});
                                },
                            ),
                          ],
                    child: Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20.0))
                              ),
                          child: Container(
                            decoration:
                                  BoxDecoration(
                                  
                                 borderRadius: BorderRadius.all(Radius.circular(20))
                                    
                                    ),
                            child: ListTile(
                              onTap: () { 
                                
                            Get.to(EventDetails(   event.data() ,  event.id));
                              },
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              title: Text(
                                event.data()['title'],
                                maxLines: 40,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle:  event.data()['dept'] != null?  Text(
                                event.data()['dept']['name'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ):  Text('') ,
                            ),
                          ),
                        ),
                  ))
                  .toList(),
            );
          },
        ),
      ),

       floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(HeroDialogRoute(builder: (_) {
              return AddEvent();
            }));
          },
          child: Icon(Icons.add),
         
        )
    );
  }
}