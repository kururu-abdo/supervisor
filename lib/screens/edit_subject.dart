import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/model/models/subject.dart';
import 'package:app3/model/models/teacher.dart';
import 'package:app3/screens/subjects.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class EditSubject extends StatefulWidget {
  final ClassSubject subject;
  EditSubject(this.subject);
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<EditSubject> {
  List<Semester> semesters = [];
  Semester semester;

  List<Teacher> teachers = [];
  Teacher teacher;

  @override
  void initState() {
    super.initState();

    fetch_semeters();

    fetch_teachers();
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

    return Scaffold(
      appBar: new AppBar(title: Text("اضافة مادة"), centerTitle: true,   ),
      body: Container(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Material(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
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
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10,) ,
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(children: [
                            Text('السمستر'),
                            Container(),
                            new DropdownButton<Semester>(
                              value: semester,
                              items: semesters.map((sem) {
                                return DropdownMenuItem<Semester>(
                                  value: sem,
                                  child: Text(sem.name ?? ''),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  semester = newValue;
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
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300],
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(children: [
                            Text('الاستاذ'),
                            Container(),
                            new DropdownButton<Teacher>(
                              value: teacher,
                              items: teachers.map((tea) {
                                return DropdownMenuItem<Teacher>(
                                  value: tea,
                                  child: Text(tea.name ?? ''),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  teacher = newValue;
                                });
                              },
                            )
                          ])),
                    ),
                                        SizedBox(
                      height: 10,
                    ),
Spacer() ,
                    MaterialButton(
                      onPressed: () async {
                        if (await service_provider.checkInternet()) {
                          var uuid =
                              Uuid(options: {'grng': UuidUtil.cryptoRNG});
    
                        
                           
    var subject =   widget.subject;
    
    
    subject.semester = this.semester?? subject.semester;
    subject.teacher = this.teacher?? subject.teacher;
    subject.name= controller.text??subject.name; 
    
                            await main_provider.updateSubject(
                              
    
    
    
                          subject);
                            Get.back();
                          // } else {
                          //   Fluttertoast.showToast(
                          //       msg: "البيانات ناقصة ^_^",
                          //       toastLength: Toast.LENGTH_SHORT,
                          //       gravity: ToastGravity.BOTTOM,
                          //       timeInSecForIosWeb: 1,
                          //       backgroundColor: Colors.red,
                          //       textColor: Colors.white,
                          //       fontSize: 16.0);
                          // }
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
                      child: Text('تحديث المادة'),
                      color: Colors.green,
                      minWidth: 200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20),
                              right: Radius.circular(20))),
                    )
                  ],
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
