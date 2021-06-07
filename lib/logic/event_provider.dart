import 'package:app3/model/models/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';

class EventProvider{
  

   
  
  Stream<QuerySnapshot> getEvents() async* {
  
   try {
      QuerySnapshot data = await FirebaseFirestore.instance
          .collection('events')
          //.where('teacher' , isEqualTo: teacher.toJson())
   .orderBy('time')
          .get();

      yield data;
   } catch (e) {
     print(e);
   }
  }


   Future<void> addSubject(Event event) async {
    CollectionReference data =
        await FirebaseFirestore.instance.collection('events');

    await data.doc().set(event.toJson());
  }

  Future<void> updateEvent(Event event) async {
      var future = await showLoadingDialog();
    CollectionReference data =
        await FirebaseFirestore.instance.collection('events');

    var selectedSubject =
        await data.where('id', isEqualTo: event.id).get();
    var doc_id = selectedSubject.docs.first.id;
    await data.doc(doc_id).update({
    'title': event.title
    ,
      'body': event.body, // John Doe
      'files': event.Files, // Stokes and Sons
      'dept': event.department!= null?event.department.toJson() :null,
      'level': event.level!= null?event.level.toJson(): null



    });

    future.dismiss();
  }
 Future<void> deleteevent(Event event) async {
    var future = await showLoadingDialog();
    CollectionReference data =
        await FirebaseFirestore.instance.collection('events');

    var selectedSubject = await data.where('id', isEqualTo: event.id).get();
    var doc_id = selectedSubject.docs.first.id;
    await data.doc(doc_id).delete();

    future.dismiss();
  }

}