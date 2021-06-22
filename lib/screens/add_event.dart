import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/screens/add_files.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/util.dart';
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

class NewEvent extends StatefulWidget {
  NewEvent();

  @override
  _NewLectureState createState() => _NewLectureState();
}

class _NewLectureState extends State<NewEvent> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
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
                                            Text('المستوى',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            Container(),
                                            new DropdownButton<Level>(
                                              value: level,
                                              items: levels.map((lev) {
                                                return DropdownMenuItem<Level>(
                                                  value: lev,
                                                  child: Text(lev.name,
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
                                            CollectionReference lecture =
                                                FirebaseFirestore.instance
                                                    .collection('events');

                                            var uuid = Uuid(options: {
                                              'grng': UuidUtil.cryptoRNG
                                            });
                                            var data = await lecture.add({
                                              'id': uuid.v1(),
                                              'time': DateTime.now(),
                                              'title': bodyController.text,
                                              'body': titleController
                                                  .text, // John Doe
                                              'files':
                                                  FilesTouploads, // Stokes and Sons
                                              'dept':
                                                  this.dept?.toJson() ?? null,
                                              'level':
                                                  this.level?.toJson() ?? null
                                            });

                                            var firebase_data =
                                                await data.get();

                                            setState(() {
                                              event_data = firebase_data;
                                            });

                                            print(event_data.data().toString());
                                            FCMConfig.subscripeToTopic('event' +
                                                event_data.data()['id']);
                                            debugPrint('event' +
                                                event_data.data()['id']);

                                            await sendAndRetrieveMessage(
                                                event_data.data());
                                            // .then((value) => print("lecures Added"))
                                            // .catchError((error) => print("Failed to add user: $error"));
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

  Future<Map<String, dynamic>> sendAndRetrieveMessage(Map data) async {
    // await firebaseMessaging.requestNotificationPermissions(
    // );

    debugPrint('sending .......');
    // debugPrint(dept.name);
    //   debugPrint(level.name);
//https://gcm-http.googleapis.com/gcm/send
//https://fcm.googleapis.com/fcm/send
    if (data['dept'] != null && data['level'] != null) {
      debugPrint('send dept');
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
              'event': event_data.data()['id']
            },
            'to': '/topics/${data['dept']['dept_code']}${data['dept']['id']}'
          },
        ),
      );
      debugPrint(response.body);
    } else if (data['dept'] == null && data['level'] != null) {
      debugPrint('level is not null');
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
              'event': event_data.data()['id']
            },
            'to': '/topics/level${data['level']['id']}'
          },
        ),
      );
    } else if (data['level'] == null && data['dept'] != null) {
      debugPrint('dept is null');
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
              'event': event_data.data()['id']
            },
            'to': '/topics/${data['dept']['dept_code']}'
          },
        ),
      );
    } else {
      debugPrint('ALL');
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
              'event': event_data.data()['id']
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

    return {};
  }
}

// FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
//   allowedFileExtensions: ['doc' ,'pdf' ,'ppt'],

//   allowedMimeTypes: ['application/*'],
//   invalidFileNameSymbols: ['/'],
// );

// final path = await FlutterDocumentPicker.openDocument(params: params);

//
class AddEvent extends StatefulWidget {
  AddEvent();

  @override
  _AddEventState createState() => _AddEventState();
}

class _AddEventState extends State<AddEvent> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String event_id;
  DocumentSnapshot event_data;
  @override
  void initState() {
    super.initState();
    BackendlessInit().init();
    FCMConfig.fcmConfig();
    fetch_levels();

    getSuperVisor();
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

  Supervisor supervisor;
  getSuperVisor() {
    var admin = Utils.getSuperVisor();

    setState(() {
      supervisor = admin;
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: new AppBar(
            title: Text(
              'إضافة إعلان',
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      key: _formKey,
                      child: Column(children: <Widget>[
                        TextFormField(
                          controller: bodyController,
                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.all(8.0),

                            labelText: 'العنوان...',

                            enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.blue)),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                        ),

                        TextFormField(
                          controller: titleController,

                          maxLines: 10,

                          decoration: InputDecoration(
                            // contentPadding: EdgeInsets.all(8.0),

                            labelText: 'الموضوع..',

                            enabledBorder: new UnderlineInputBorder(
                                borderSide: new BorderSide(color: Colors.blue)),

                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
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

                        SizedBox(
                          height: 10,
                        ),

                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.grey[300],
                          ),
                          child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(children: [
                                Text('المستوى',
                                    style: TextStyle(color: Colors.black)),
                                Container(),
                                new DropdownButton<Level>(
                                  value: level,
                                  items: levels.map((lev) {
                                    return DropdownMenuItem<Level>(
                                      value: lev,
                                      child: Text(lev.name,
                                          style:
                                              TextStyle(color: Colors.black)),
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

                        MaterialButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(20),
                                    right: Radius.circular(20))),
                            color: AppColors.PrimaryColor,
                            minWidth: double.infinity,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                Get.to(AddFiles(titleController.text,
                                    bodyController.text, level));
                              }
                            },
                            child: Text(
                              'متابعة ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))

                        // Add TextFormFields and ElevatedButton here.
                      ])),
                ],
              ),
            ),
          )),
    );
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

  Future<Map<String, dynamic>> sendAndRetrieveMessage(Map data) async {
    // await firebaseMessaging.requestNotificationPermissions(
    // );

    debugPrint('sending .......');
    // debugPrint(dept.name);
    //   debugPrint(level.name);
//https://gcm-http.googleapis.com/gcm/send
//https://fcm.googleapis.com/fcm/send
    if (data['level'] != null) {
      debugPrint('level is not null');
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
              'event': event_data.data()['id']
            },
            'to': '/topics/level${data['level']['id']}'
          },
        ),
      );
    } else {
      debugPrint('ALL');
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
              'event': event_data.data()['id']
            },
            'to': '/topics/${data['dept']['dept_code']}'
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

    return {};
  }
}

// FlutterDocumentPickerParams params = FlutterDocumentPickerParams(
//   allowedFileExtensions: ['doc' ,'pdf' ,'ppt'],

//   allowedMimeTypes: ['application/*'],
//   invalidFileNameSymbols: ['/'],
// );

// final path = await FlutterDocumentPicker.openDocument(params: params);

//
