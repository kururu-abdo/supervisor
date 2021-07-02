import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/model/models/subject.dart';
import 'package:app3/model/models/teacher.dart';
import 'package:app3/util/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class AddTeacher extends StatefulWidget {
  AddTeacher();
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddTeacher> {
  List<Semester> semesters = [];
  Semester semester;

  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

//

  List Degrees = ['محاضر', 'أستاذ مشارك', 'أستاذ مساعد', 'مساعد تدريس'];
  String Degree;



  @override
  void initState() {
    super.initState();

    fetch_semeters();

 
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
        backgroundColor: AppColors.greenColor,
    
    appBar: AppBar(title: Text("اضافة استاذ"), centerTitle: true,  elevation: 0.0,
    backgroundColor: AppColors.greenColor,
    ),
        resizeToAvoidBottomInset :  false ,
    
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
                        controller: nameController,
      
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          labelText: 'الأسم.... ',
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
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          labelText: 'الهاتف.... ',
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
    
                      TextFormField(
                        controller: addressController,
      
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(8.0),
                          labelText: 'العنوان.... ',
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
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(children: [
                              Text('الدرجة'  ,
                                  style: TextStyle(color: Colors.black)),
                              Container(),
                              new DropdownButton<String>(
                                value: Degree,
                                items: Degrees.map((deg) {
                                  return DropdownMenuItem<String>(
                                    value: deg,
                                    child: Text(deg ?? ''   ,
                                        style: TextStyle(color: Colors.black)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    Degree = newValue;
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
                              Text('السمستر' ,style: TextStyle(color: Colors.black),),
                              Container(),
                              new DropdownButton<Semester>(
                                value: semester,
                                items: semesters.map((sem) {
                                  return DropdownMenuItem<Semester>(
                                    value: sem,
                                    child: Text(sem.name ?? ''   ,
                                        style: TextStyle(color: Colors.black)),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20))),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('إلغاء')),
                          RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20))),
                              onPressed: () async {
                                if (_formKey.currentState.validate() &&
                                    await service_provider.checkInternet()) {
                                  if (this.semester != null ||
                                      this.Degree != null) {
                                    var data = {
                                      "name": nameController.text,
                                      'address': addressController.text,
                                      'phone': phoneController.text,
                                      'degree': this.Degree,
                                      'semester': this.semester.toJson()
                                    };
                                    await main_provider.addTeacher(data);
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
                              child: Text('إضافة')),
        ],
      )
      
                    ],
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
