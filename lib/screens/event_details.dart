import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get_storage/get_storage.dart';

class EventDetails extends StatefulWidget {
final Map data;
EventDetails(this.data);


  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  List<String>  files =[];
  @override
  void initState() { 
    super.initState();


fill_array();
  }
fill_array(){
  for (var i = 0; i < widget.data['files'].length; i++) {
    files.add(widget.data['files'][i]);
  }
}
    ScrollController _scrollController = ScrollController();



  @override
  Widget build(BuildContext context) {

       var size = MediaQuery.of(context).size;

    /*24 is for notification bar on Android*/
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
       resizeToAvoidBottomInset: false,
       
        appBar: AppBar(
         
         
          title: Text('التفاصيل'),
          centerTitle: true,
         
       
        ),
        body:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
    
            children: [
    Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.white)
                    ]),
                    child: Text('االموضوع.' , style: TextStyle(color: Colors.black))),
                SizedBox(
                  height: 10.0,
                ),
    
      Container(
    width: double.infinity,
    height: 100,
    child: SingleChildScrollView(
      child: Text(widget.data['body']!= null?widget.data['body'] :''
      
      ,
      maxLines: 20,
    
      style: TextStyle(color: Colors.white),
      ),
    ),
    
      ) ,
    
    
    
    
     Container(
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(blurRadius: 2.0, color: Colors.white)
                    ]),
                    child: Text('الملفات...' ,
                        style: TextStyle(color: Colors.black))),
                   SizedBox(height: 10.0,),
           Center(
                  child: Container(
                    height: MediaQuery.of(context).size.height-120,
                     
                      child: files.length > 0
                          ? GridView.count(
                              crossAxisCount: 3,
                               childAspectRatio: (itemWidth / itemHeight),
                               controller:
                                new ScrollController(keepScrollOffset: false),
                                shrinkWrap: true,
                              children: files.map((file) {
                                print(file);
    
                                return Container(
                                  margin: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                  
                                  ),
                                  child: Column(
                                    children: [
                                      IconButton(
                                          icon: Icon(Icons.download_done_rounded),
                                          onPressed: () {
                                            _requestDownload(file);
                                          }),
                                      Text('ملف '),
                                    ],
                                  ),
                                );
    
                                return Stack(
                                  children: [
                                    Container(
                                      color: Colors.green[300],
                                      height: 200,
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            top: 0,
                                            right: 5,
                                            child: IconButton(
                                                icon: Icon(
                                                    Icons.download_done_rounded),
                                                onPressed: () {
                                                  _requestDownload(file);
                                                }),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Text('ملف '),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList()
                              
                              ..add(
                                  Container(
                                    constraints: BoxConstraints(
                                        maxWidth: 250.0, minHeight: 50.0),
                                    margin: EdgeInsets.all(10),
                                    child: RaisedButton(
                                      onPressed: () {},
                                      color: Theme.of(context).accentColor,
                                      child: Padding(
                                        padding: EdgeInsets.all(0),
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                'اضافة ملف',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              
                              ,
                            )
                          : 
                          
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [


                      Image.asset('assets/images/file_not_found.png') ,
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
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

       
    final taskId = await FlutterDownloader.enqueue(
      url: link,
      
   
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, 
          savedDir: appDocPath, // click on notification to open downloaded file (for Android)
    );
  }
}