import 'package:app3/logic/api_response.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/screens/days.dart';
import 'package:app3/screens/semesters.dart';
import 'package:app3/screens/subjects.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class LevelScreen extends StatefulWidget {
  final Semester semster;
  LevelScreen(this.semster);
  @override
  _LevelsState createState() => _LevelsState();
}

class _LevelsState extends State<LevelScreen> {
  @override
  Widget build(BuildContext context) {
    var main_provider = Provider.of<MainProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryVariantColor,
        elevation: 0.0,

        title: Text(
          'المستويات',
          style: TextStyle(color: AppColors.onPrimary),
        ),
        centerTitle: true,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //   bottomLeft: Radius.circular(20),
        //   bottomRight: Radius.circular(20),
        // )),
        // foregroundColor: Colors.green,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<APIresponse<List<Level>>>(
            future : main_provider.getAllevels(),
            builder:
                (BuildContext context, AsyncSnapshot<APIresponse<List<Level>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              return ListView(
                children: snapshot.data.data
                    .map((dept) => Card(
                          elevation: 8.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          child: ListTile(
                            onTap: () {
                             Get.to(() =>Days(

                               semseter: widget.semster,
                               level: dept,
                               
                             ));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              dept.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
