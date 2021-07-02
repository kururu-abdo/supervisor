import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app3/logic/event_provider.dart';
import 'package:app3/model/models/event.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:app3/backendless_init.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/util/constants.dart';
import 'package:app3/util/custom_tween.dart';
import 'package:app3/util/fcm_config.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class EditEvent extends StatefulWidget {

  final Event event;
  EditEvent(this.event);

  @override
  _NewLectureState createState() => _NewLectureState();
}

class _NewLectureState extends State<EditEvent> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String event_id;
  DocumentSnapshot event_data;
  @override
  void initState() {
    super.initState();
    BackendlessInit().init();
    FCMConfig.fcmConfig();
    fetch_levels();
    fetch_depts();
  }

  final _formKey = GlobalKey<FormState>();
  Department dept;
  TextEditingController titleController = new TextEditingController();
  TextEditingController bodyController = new TextEditingController();

  List LecureFiles = [];
  List FilesTouploads = [];

  List<Department> depts = [];

  Level level;
  List<Level> levels = [];

  List<Semester> semesters = [];
  Semester semester;
  fetch_depts() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('depts')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();

    setState(() {
      depts = data.docs.map((e) => Department.fromJson(e.data())).toList();
    });
  }

  fetch_levels() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('level')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();

    setState(() {
      levels = data.docs.map((e) => Level.fromJson(e.data())).toList();
    });
  }

  fetch_semeters() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('semester')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();

    setState(() {
      semesters = data.docs.map((e) => Semester.fromJson(e.data())).toList();
    });
  }

  String _path = '-';
  bool _pickFileInProgress = false;
  bool _iosPublicDataUTI = true;
  bool _checkByCustomExtension = false;
  bool _checkByMimeType = false;
  @override
  Widget build(BuildContext context) {
    var service_provider = Provider.of<ServiceProvider>(context);

        var eventprovider = Provider.of<EventProvider>(context);

    return Center(
        child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Hero(
                tag: '',
                createRectTween: (begin, end) {
                  return CustomRectTween(begin: begin, end: end);
                },
                child: Material(
                    // color: Colors.white24,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    child: SingleChildScrollView(
                        child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
                              child: Form(
                                  key: _formKey,
                                  child: Column(children: <Widget>[
                                    TextFormField(
                                      controller: bodyController,
                                      decoration: InputDecoration(
                                        // contentPadding: EdgeInsets.all(8.0),

                                        labelText: 'title...',
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.blue)),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange),
                                        ),
                                      ),
                                    ),
                                    TextFormField(
                                      controller: titleController,
                                      maxLines: 10,
                                      decoration: InputDecoration(
                                        // contentPadding: EdgeInsets.all(8.0),

                                        labelText: 'topic...',
                                        enabledBorder: new UnderlineInputBorder(
                                            borderSide: new BorderSide(
                                                color: Colors.blue)),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.orange),
                                        ),
                                      ),
                                      // The validator receives the text that the user has entered.
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[300],
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(children: [
                                            Text('المستوى' ,
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            Container(),
                                            new DropdownButton<Level>(
                                              value: level,
                                              items: levels.map((lev) {
                                                return DropdownMenuItem<Level>(
                                                  value: lev,
                                                  child: Text(lev.name  ,
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  level = newValue;
                                                });
                                              },
                                            )
                                          ])),
                                    ),

                                    SizedBox(
                                      height: 10,
                                    ),

                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: Colors.grey[300],
                                      ),
                                      child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Row(children: [
                                            Text('التخصص' ,   style: TextStyle(
                                                    color: Colors.black)),
                                            Container(),
                                            new DropdownButton<Department>(
                                              value: dept,
                                              items: depts.map((dept) {
                                                return DropdownMenuItem<
                                                    Department>(
                                                  value: dept,
                                                  child: Text(dept.name ,
                                                      style: TextStyle(
                                                          color: Colors.black) ),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  dept = newValue;
                                                });
                                              },
                                            )
                                          ])),
                                    ),

                                    Row(children: [
                                      Text('اضافة ملفات'),

                                      IconButton(
                                        icon: Icon(Icons.file_copy),
                                        onPressed: () async {
                                          _pickDocument();
                                        },
                                      ),
//LecureFiles

                                      Text('ملفات  ${LecureFiles.length}')
                                    ]),

                                    MaterialButton(
                                        color: Colors.green[700],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.horizontal(
                                                    left: Radius.circular(20),
                                                    right:
                                                        Radius.circular(20))),
                                        minWidth: double.infinity,
                                        onPressed: () async {
//await upload files then send data to firebase

                                          if (await service_provider
                                              .checkInternet()) {
                                            await UploadFilesToBackendless(); //await here
//

                                            await Future.delayed(Duration(
                                                seconds: 2)); // abd  here

//send data to the firebase

                                            FilesTouploads.forEach(
                                                (element) async {
                                              print(
                                                  '////////////////////////////////////////');
                                              print(element);
                                            });

var event =   widget.event;

event.Files =    FilesTouploads.length>0?  FilesTouploads :event.Files ;

event.title =
                                                 bodyController.text.length>0 ? bodyController.text  :event.title;
   
event.body =  titleController.text.length>0 ? titleController.text :
                                                event.body;                                              
   
event.department = this.dept??
                                                event.department; 
event.level =
                                                this.level ?? event.level; 

                            await     eventprovider.updateEvent(event);
                                            Get.back();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "تأكد من أتصالك بالانترنت ^_^",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                timeInSecForIosWeb: 1,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);
                                          }
                                        },
                                        child: Text('نشر الخبر'))

                                    // Add TextFormFields and ElevatedButton here.
                                  ])),
                            )))))));
  }

  _pickDocument() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'ppt'],
          allowMultiple: true);
      setState(() {
        LecureFiles = result.files;
      });

      print('///////////////////////////////////');
      PlatformFile file = result.files.first;
      print(file.extension);
      var first_file = File(LecureFiles[0].path);

      print(first_file.lastAccessed());
// Backendless.files.upload(File file, String path, {bool overwrite, void onProgressUpdate(int progress)});

      // String result;
      // try {
      //   setState(() {
      //     _path = '-';
      //     _pickFileInProgress = true;
      //   });

      //   FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
      //     // allowedFileExtensions: ['pdf' ,'PDF' ,'Pdf'],
      //     allowedMimeTypes: ['application/*'],
      //     invalidFileNameSymbols: ['/'],

      //   );

      //   result = await FlutterDocumentPicker.openDocument(params: params);

    } catch (e) {
      print(e);
      // result = 'Error: $e';
    } finally {
      setState(() {
        // _pickFileInProgress = false;
      });
    }

    // setState(() {
    //   _path = result;
    // });

    debugPrint(_path);
  }

  Future<void> UploadFilesToBackendless() async {
    LecureFiles.forEach((file) async {
      // PlatformFile()

//await here
      var url = await Backendless.files.upload(File(file.path), 'lectures',
          overwrite: true, onProgressUpdate: (value) {});

      debugPrint(url);
      setState(() {
        FilesTouploads.add(url);
      });
//print(url);

      Future.delayed(Duration(seconds: 2));
    });

    await Future.delayed(Duration(seconds: 2));
  }

  Future<Map<String, dynamic>> sendAndRetrieveMessage() async {
    // await firebaseMessaging.requestNotificationPermissions(
    // );

    debugPrint('sending .......');

//https://gcm-http.googleapis.com/gcm/send
//https://fcm.googleapis.com/fcm/send
    if (this.dept != null && this.level != null) {
      var response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'إخطار جديد',
              'title': titleController.text ?? 'خبر جديد'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'screen': 'event_details',
              'event': event_data.data()
            },
            'to': '/topics/${this.dept.name}${this.level.name}'
          },
        ),
      );
    }
    if (this.dept == null && this.level != null) {
      var response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'إخطار جديد',
              'title': titleController.text ?? 'خبر جديد'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'screen': 'event_details',
              'event': event_data.data()
            },
            'to': '/topics/${this.level.name}'
          },
        ),
      );
    }

    if (this.level == null && this.dept != null) {
      var response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'إخطار جديد',
              'title': titleController.text ?? 'خبر جديد'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'screen': 'event_details',
              'event': event_data.data()
            },
            'to': '/topics/${this.dept.name}'
          },
        ),
      );
    }
    if (this.level == null && this.dept == null) {
      var response = await http.post(
        'https://fcm.googleapis.com/fcm/send',
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverToken',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'إخطار جديد',
              'title': titleController.text ?? 'خبر جديد'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'screen': 'event_details',
              'event': event_data.data()
            },
            'to': '/topics/general'
          },
        ),
      );
    }

    // final Completer<Map<String, dynamic>> completer =
    //    Completer<Map<String, dynamic>>();

    // firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     completer.complete(message);
    //   },
    // );

    // return completer.future;
    Get.back();
    // debugPrint(response.body);
  }
}

// FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
//   allowedFileExtensions: ['doc' ,'pdf' ,'ppt'],

//   allowedMimeTypes: ['application/*'],
//   invalidFileNameSymbols: ['/'],
// );

// final path = await FlutterDocumentPicker.openDocument(params: params);

//
