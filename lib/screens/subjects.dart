import 'package:app3/logic/api_response.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/subject.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/screens/add_subject.dart';
import 'package:app3/screens/edit_subject.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/pop_up_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Subjects extends StatefulWidget {
 
  final Supervisor supervisor;
  Subjects( this.supervisor); 
  @override
  _SubjectsState createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {
  @override
  Widget build(BuildContext context) {
    var main_provider = Provider.of<MainProvider>(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          
          title: Text('المواد' ,  style: TextStyle(color: AppColors.onPrimary),),
          centerTitle: true,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          // )),
         
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<APIresponse<List<ClassSubject>>>(
            future : main_provider.getDeptSubjects(widget.supervisor.dept),
            builder:
                (BuildContext context, AsyncSnapshot<APIresponse<List<ClassSubject>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
             
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
             }
              return ListView(
                children: snapshot.data?.data
                    ?.map((subject) => Card(
                          elevation: 8.0,
                          color: AppColors.surfaceColor,
                          shadowColor: AppColors.secondaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: ListTile(
                            onTap: () {
                              // Get.to(Students(
                              //   department: dept,
                              // ));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              subject.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),

                            subtitle: Row(children: [
                              Text(
                                  subject.department.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  subject.level.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                            ],),
                            trailing: IconButton(icon: Icon(Icons.edit ,  color: AppColors.greenColor), onPressed: (){
 
                              Get.to(Directionality(
                                
                                textDirection :TextDirection.rtl ,
                                child: Material (child: EditSubject(subject))));
                            }),
                          ),
                        ))
                    ?.toList(),
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(HeroDialogRoute(builder: (_) {
              return AddSubject(widget.supervisor);
            }));
          },
          child: Icon(Icons.add ,  color: AppColors.onSecondary),
         
        )
        
        );
  }
}