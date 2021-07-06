import 'dart:io';

import 'package:app3/logic/main_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_file_preview/flutter_file_preview.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EventDetails extends StatefulWidget {
  final Map data;
  String document_id;
  EventDetails(this.data, this.document_id);

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<String> files = [];
  @override
  void initState() {
    super.initState();
    _permissionReady= false;
    _prepareSaveDir();
    fill_array();
  }
   bool _permissionReady;

  String _localPath;
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }
 Future<void> _retryRequestPermission() async {
    final hasGranted = await _checkPermission();

    if (hasGranted) {
      await _prepareSaveDir();
    }

    setState(() {
      _permissionReady = hasGranted;
    });
  }
  _checkPermission() async {
      final status = await Permission.storage.status;
      bool granted;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          granted= true;
        }else{
          granted= false;
        }
      } else {
        granted= true;
      }
    
    
    return granted;
  }
  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  fill_array() {
    for (var i = 0; i < widget.data['files'].length; i++) {
      files.add(widget.data['files'][i]);
    }
  }

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
Stream eventStream = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.document_id)
        .snapshots();

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    var mainProcider = Provider.of<MainProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text('التفاصيل'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: 
            
            
            
            
            
            
            ListView(
              children: [
                Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.white)
                    ]),
                    child: Text('االموضوع.',
                        style: TextStyle(color: Colors.black))),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  width: double.infinity,
                  height: 100,
                  child: SingleChildScrollView(
                    child: Text(
                      widget.data['body'] != null ? widget.data['body'] : '',
                      maxLines: 20,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.white)
                    ]),
                    child: Text('الملفات...',
                        style: TextStyle(color: Colors.black))),
                SizedBox(
                  height: 10.0,
                ),
                Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height - 120,
                    child: files.length > 0
                        ? GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: (itemWidth / itemHeight),
                            controller:
                                new ScrollController(keepScrollOffset: false),
                            shrinkWrap: true,
                            children: files.map((file) {
                              print(file);
if(file.endsWith(".jpeg") || file.endsWith(".png") || file.endsWith(".jpg") ){
return InkWell(
  onTap: () async{
 await OpenFile.open(file);
 
  },
  child: Stack(children:  [ Image.network(file)   ,     Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                            onPressed: () async {
                                              debugPrint("deleting");
                                              try {
                                                await mainProcider
                                                    .deleteEventFile(file,
                                                        widget.document_id);
                                              } catch (e) {
                                                debugPrint(e);
                                              }
                                              //logic for delete item from firebase
                                            },
                                            icon: Icon(Icons.delete_rounded))),  ])  ,      );  
}
                              return Stack(children: [
                                InkWell(
                                  onTap: () async {


 if (await canLaunch(file)) {
                                      await launch(file);
                                    } else {
                                      throw 'Unable to open url : $file';
                                    }

                                    // FlutterFilePreview.openFile(file,
                                    //     title: widget.data['body']);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                                Icons.download_done_rounded),
                                            onPressed: () {
                                              _requestDownload(file);
                                            }),
                                        Text('ملف '),
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    left: 0,
                                    child: IconButton(
                                        onPressed: () async {
                                          debugPrint("deleting");
                                          try {
                                            await mainProcider.deleteEventFile(
                                                file, widget.document_id).then((value) {

debugPrint("deleted");


                                                });
                                          } catch (e) {
                                            debugPrint(e);
                                          }
                                          //logic for delete item from firebase
                                        },
                                        icon: Icon(Icons.delete))),
                              ]);
                            }).toList()
                             
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/file_not_found.png'),
                              Text(' لا يحتوى الخبر على اية ملفات'),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          
          
          
          
          )
          
          ),
    );
  }

  void _requestDownload(String link) async {
    var result  =  await _checkPermission();
    if(result != null && result){
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    final taskId = await FlutterDownloader.enqueue(
      url: link,

      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification: true,
      savedDir:
          _localPath,
        fileName:DateTime.now().toString()// click on notification to open downloaded file (for Android)
    );
  }

  }
}
