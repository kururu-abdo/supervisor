import 'dart:convert';
import 'package:app3/firebase_init.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/user_provider.dart';
import 'package:app3/model/models/chat_user.dart';
import 'package:app3/model/models/teacher.dart';
import 'package:app3/screens/chat_page.dart';
import 'package:app3/util/fcm_config.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';

import 'package:url_launcher/url_launcher.dart';

class TeacherProfile extends StatefulWidget {
  final Teacher teacher;
  TeacherProfile(this.teacher);

  @override
  _MyPrpfoleState createState() => _MyPrpfoleState();
}

class _MyPrpfoleState extends State<TeacherProfile> {
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    FirebaseInit.init();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<MainProvider>(context);

    CollectionReference teachers =
        FirebaseFirestore.instance.collection('teacher');
    teachers.where('id', isEqualTo: widget.teacher.id);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.teacher.name),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.messenger),
              onPressed: () async {
                var token = await FCMConfig.getToken();

                Get.to(ChatPage(
                  user: User(widget.teacher.id.toString(), widget.teacher.name,
                      'أستاذ'),
                  me: User(userProvider.getAdmin().id,
                      userProvider.getAdmin().name, 'مشرف'),
                ));
              })
        ],
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: teachers.get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            debugPrint(snapshot.data.size.toString());
            Map<String, dynamic> data = snapshot.data.docs.first.data();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  Container(
                     // decoration: BoxDecoration(
                          // gradient: LinearGradient(
                          //     begin: Alignment.topCenter,
                          //     end: Alignment.bottomCenter,
                          //     colors: [Colors.redAccent, Colors.pinkAccent])),
                      child: Container(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage:   AssetImage(
                                  "assets/images/karari.png",
                                ),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${widget.teacher.name}",
                                style: TextStyle(
                                  fontSize: 22.0,
                               
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 22.0),
                                    child: Center(
                                      child: Text(
                                        "محاضر",
                                        style: TextStyle(
                                          color: Colors.redAccent,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "البيانات الشخصية:",
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontStyle: FontStyle.normal,
                                fontSize: 28.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Center(
                            child: Form(
                                child: Column(
                              children: [
                                Center(
                                    child: ListTile(
                                  title: Text('${widget.teacher.phone}'),
                                  trailing: IconButton(onPressed: ()  async {
await openContacts(widget.teacher.phone);
                                  }, icon: Icon(Icons.call)),
                                )),
                                Center(
                                    child: ListTile(
                                  title: Text('${widget.teacher.address}'),
                                )),
                   
                              ],
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );

  }
openContacts(String phone) async{

    // final Uri _phoneCall = Uri(
    //   scheme: 'tel:$phone' 
    //   // path: 'smith@example.com',
    //   // queryParameters: {'subject': 'Example Subject & Symbols are allowed!'}
    //   );

      await launch('tel:$phone');
}



 






}
