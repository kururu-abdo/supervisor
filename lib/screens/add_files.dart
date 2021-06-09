import 'dart:convert';
import 'dart:io';
import 'package:flutter_filereader/flutter_filereader.dart';

import 'package:app3/backendless_init.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/constants.dart';
import 'package:app3/util/fcm_config.dart';
import 'package:app3/util/util.dart';
import 'package:backendless_sdk/backendless_sdk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
class AddFiles extends StatefulWidget {

  String title;
  String body;
  Level level;
  AddFiles(this.title ,  this.body ,  this.level) ;

  @override
  _AddFilesState createState() => _AddFilesState();
}


class _AddFilesState extends State<AddFiles> {


  String _path = '-';

String event_id;
  DocumentSnapshot event_data;
List<PlatformFile> LecureFiles = [];
  List FilesTouploads = [];



@override
void initState() { 
  super.initState();
      BackendlessInit().init();

  FCMConfig.fcmConfig();


      getSuperVisor();

}


Supervisor supervisor;
  getSuperVisor() {
    var admin = Utils.getSuperVisor();

    setState(() {
      supervisor = admin;
    });
  }
 _pickDocument() async {
    try {
      FilePickerResult result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'pdf', 'doc', 'ppt' , 'pptx' , 'docx'],
          allowMultiple: true);
      setState(() {
        LecureFiles .addAll(result.files) ;
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
              'title': widget.title ?? 'خبر جديد'
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
              'title': widget.title ?? 'خبر جديد'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done',
              'screen': 'event_details',
              //'event': event_data.data()['id']
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


  @override
  Widget build(BuildContext context) {

        var service_provider = Provider.of<ServiceProvider>(context);

    return Scaffold(
     appBar: new AppBar(
       title: Text('إضافة ملفات للخبر'),
       centerTitle: true,
     ),


     body: Padding(
       padding: const EdgeInsets.all(8.0),
       child: ListView(
        
         children: [ Container(
           height: MediaQuery.of(context).size.height*3/4,
           child: GridView.count(crossAxisCount: 3 ,
           crossAxisSpacing: 5.0,


           mainAxisSpacing: 5.0 ,
           children: LecureFiles.toSet().map((e) 
         {
            if (e.path.endsWith("jpg") ||  e.path.endsWith("jpeg") || e.path.endsWith("pnf")) {
            return
            
             Stack(
              children:[
                 
Container(
  height: 100,
  decoration: BoxDecoration(
    image: DecorationImage(image: FileImage(File(e.path) ,),fit: BoxFit.cover)
  ),
) ,
            Positioned(top: 0, right:0 ,   
                  
                  child: IconButton(onPressed: (){

   
setState(() {
LecureFiles.remove(e); 
});


                  }, icon: Icon(Icons.highlight_off ,  color: Colors.red,)),
                    ) ,
       ]
            );
          }  else  if(e.path.endsWith("pdf")){
            return 
            
     Stack(

       children: [

       Container(
                          height: 100,
                          child: PDFView(
                            filePath: e.path,
                            enableSwipe: true,
                            swipeHorizontal: true,
                            autoSpacing: false,
                            pageFling: false,
                            onRender: (_pages) {
                              setState(() {});
                            },
                            onError: (error) {
                              print(error.toString());
                            },
                            onPageError: (page, error) {
                              print('$page: ${error.toString()}');
                            },
                            onViewCreated:
                                (PDFViewController pdfViewController) {
                              // _controller.complete(pdfViewController);
                            },
                            onPageChanged: (int page, int total) {
                              print('page change: $page/$total');
                            },
                          ),
                        ) ,
    Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  LecureFiles.remove(e);
                                });
                              },
                              icon: Icon(
                                Icons.highlight_off,
                                color: Colors.red,
                              )),
                        ),

       ],
     );
    
            }else{
                 
          return 
            
     Stack(

       children: [

       Container(
                          height: 100,
                          child: 
                       FileReaderView(
                            filePath: e.path,
                          ),
                        ) ,
    Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                              onPressed: () {
                                setState(() {
                                  LecureFiles.remove(e);
                                });
                              },
                              icon: Icon(
                                Icons.highlight_off,
                                color: Colors.red,
                              )),
                        ),

       ],
     );      
            
            
            
            }



         }     
           
           ).toList()
           
           
           
           ),
         ),
         
         SizedBox(height: 10,) ,



         
                          MaterialButton(

                            color: AppColors.PrimaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(20), right: Radius.circular(20))),
              minWidth: double.infinity,
              onPressed: () async {
                //await upload files then send data to firebase

                if (await service_provider.checkInternet()) {

    var future = await showLoadingDialog(
      tapDismiss:false
    );


                  await UploadFilesToBackendless(); //await here

                  //

                  await Future.delayed(Duration(seconds: 2)); // abd  here

                  //send data to the firebase

                  FilesTouploads.forEach((element) async {
                    print('////////////////////////////////////////');

                    print(element);
                  });

                  CollectionReference lecture =
                      FirebaseFirestore.instance.collection('events');

                  var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

                  var data = await lecture.add({
                    'id': uuid.v1(),

                    'time': DateTime.now(),

                    'title':widget.title,

                    'body': widget.body, // John Doe

                    'files': FilesTouploads, // Stokes and Sons

                    'dept': supervisor.dept?.toJson() ?? null,

                    'level': widget.level?.toJson() ?? null
                  });

                  var firebase_data = await data.get();

                  setState(() {
                    event_data = firebase_data;
                  });

                  print(event_data.data().toString());

                  FCMConfig.subscripeToTopic('event' + event_data.data()['id']);

                  debugPrint('event' + event_data.data()['id']);

                  await sendAndRetrieveMessage(event_data.data());

                  // .then((value) => print("lecures Added"))

                  // .catchError((error) => print("Failed to add user: $error"));

                  Get.back();

                  future.dismiss();
                } else {
                  Fluttertoast.showToast(
                      msg: "تأكد من أتصالك بالانترنت ^_^",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                      
                }
              },
              child: Text('نشر الخبر أو الإعلان '    ,  style: TextStyle(fontSize: 22 ,  fontWeight: FontWeight.bold),))
         
         
         ]
       ),
     ),


     floatingActionButton: FloatingActionButton(
       
       child: Icon(Icons.add) ,  


       onPressed: () async{
await _pickDocument();
       }
       ,),
    );
  }
}


// import 'package:open_file/open_file.dart';

// OpenFile.open("/sdcard/example.txt");