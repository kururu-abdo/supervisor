import 'dart:convert';

import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/model/models/subject.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/model/models/teacher.dart';
import 'package:app3/util/constants.dart';
import 'package:app3/util/fcm_config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:http/http.dart'  as http;
class AddSubject extends StatefulWidget {
  Supervisor supervisor;
  AddSubject(this.supervisor);
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  List<Semester> semesters = [];
  Semester semester;

  List<Teacher> teachers = [];
  Teacher teacher;

  List<Level> levels = [];
  Level level;

  @override
  void initState() {
    super.initState();

    fetch_semeters();

    fetch_teachers();

    fetch_levels();

    FCMConfig.fcmConfig();
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

  fetch_teachers() async {
    QuerySnapshot data = await FirebaseFirestore.instance
        .collection('teacher')
        //.where('teacher' , isEqualTo: teacher.toJson())

        .get();

    setState(() {
      teachers = data.docs.map((e) => Teacher.fromJson(e.data())).toList();
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

  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    var main_provider = Provider.of<MainProvider>(context);

    var service_provider = Provider.of<ServiceProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: Text('إضافة مادة'),
          centerTitle: true,
        ),
        body: Center(
          heightFactor: 3,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: controller,

                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(8.0),
                    labelText: 'اسم المادة',
                    enabledBorder: new UnderlineInputBorder(
                        borderSide: new BorderSide(color: Colors.blue)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                  ),
                  // The validator receives the text that the user has entered.
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'الرجاء ادخال اسم المادة';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
               
                new DropdownButtonFormField<Semester>(
                  hint: Text('السمستر'),
                  value: semester,
                  items: semesters.map((sem) {
                    return DropdownMenuItem<Semester>(
                      value: sem,
                      child: Text(sem.name ),
                      
                    );
                  }).toList(),


                  
                  onChanged: (newValue) {
                    setState(() {
                      semester = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "هذا الحقل مطلوب";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
               
                new DropdownButtonFormField<Level>(
                  value: level,
                  hint: Text('المستوى'),
                  items: levels.map((level) {
                    return DropdownMenuItem<Level>(
                      value: level,
                      child: Text(level.name),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      level = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "هذا الحقل مطلوب";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
               
                new DropdownButtonFormField<Teacher>(
                  value: teacher,
                  hint: Text('الاستاذ'),
                  items: teachers.map((tea) {
                    return DropdownMenuItem<Teacher>(
                      value: tea,
                      child: Text(tea.name ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      teacher = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return "هذا الحقل مطلوب";
                    }

                    return null;
                  },
                ),
                MaterialButton(
                  onPressed: () async {
                    if (await service_provider.checkInternet()) {
                      var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});

                      if (_formKey.currentState.validate() &&
                          this.semester != null &&
                          this.teacher != null) {
               var data=         await main_provider.addSubject(ClassSubject(
                            uuid.v1(),
                            controller.text,
                            widget.supervisor.dept,
                            level,
                            teacher,
                            semester));
                      
var doc = await   data.get();
      


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
                                'title': "لقد تم تكليفك بتدريس مادة    ${controller}   من قبل    ${widget.supervisor.name}"
                              },
                              'priority': 'high',
                              'data': <String, dynamic>{
                                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                                'id': '1',
                                'status': 'done',
                                'screen': 'event_details',
                                'event': doc.data()['id']
                              },
                              'to':
                                  '/topics/teacher${teacher.id.toString()}'
                            },
                          ),
                        );
                        debugPrint(response.body);




                      } else {
                        Fluttertoast.showToast(
                            msg: "البيانات ناقصة ^_^",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
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
                  child: Text('اضافة المادة'),
                  color: Colors.green,
                  minWidth: 200,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20),
                          right: Radius.circular(20))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
