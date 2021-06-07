import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/model/models/teacher.dart';
import 'package:app3/screens/add_teacher.dart';
import 'package:app3/screens/edit_teacher.dart';
import 'package:app3/util/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Teachers extends StatefulWidget {
  Teachers({Key key}) : super(key: key);

  @override
  _TeachersState createState() => _TeachersState();
}

class _TeachersState extends State<Teachers> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();

//

  List Degrees = ['محاضر', 'أستاذ مشارك', 'أستاذ مساعد', 'مساعد تدريس'];
  String Degree;

  List<Semester> semesters = [];
  Semester semester;

  var _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    var main_provider = Provider.of<MainProvider>(context);
    var service_provider = Provider.of<ServiceProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.PrimaryColor,
        elevation: 0.0,
        // toolbarHeight: 80,
        title: Text('الأساتذة'),
        centerTitle: true,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(20),
        //   bottomRight: Radius.circular(20),
        // )),
        foregroundColor: AppColors.surfaceColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<List<Teacher>>(
          stream: main_provider.getTeachers(),
          builder:
              (BuildContext context, AsyncSnapshot<List<Teacher>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView(
              children: snapshot.data
                  .map((teacher) => Card(
                        elevation: 8.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: ListTile(
                          onTap: () {},
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          title: Text(
                            teacher.name,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            teacher.degree,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.edit ,  color:AppColors.PrimaryColor),
                              onPressed: () {
                                Get.to(EditTeacher(teacher));
                              }),
                        ),
                      ))
                  .toList(),
                  physics: BouncingScrollPhysics(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryVariantColor2,
        onPressed: () async {
          Get.to(AddTeacher());
        },
        child: Icon(Icons.add , color: AppColors.onSecondary,),
       
      ),
    );
  }
}
