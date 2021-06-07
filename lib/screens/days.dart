import 'package:app3/logic/api_response.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/screens/levels_screen.dart';
import 'package:app3/screens/time_table.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class   Days extends StatelessWidget {

  Level level ;
  Semester semseter;
  Days({Key key ,   this.level ,  this.semseter}) : super(key: key);
  List<Semester> semesters = [];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: new AppBar(
          title: Text('اليوم'),
          centerTitle: true,
        ),
        body: Center(
       
         child :     ListView.builder(
                  itemCount: DAYS.length,
                  itemBuilder: (BuildContext context, int index) {
                    return 
                         InkWell(

onTap: (){

  Get.to(TimeTable(day: DAYS[index] , level: this.level ,  semester: this.semseter, ));
},

                           child: Container(
                              width: MediaQuery.of(context).size.width - 20,
                              height: MediaQuery.of(context).size.width / 2 - 70,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.15),
                                      offset: Offset(0.5, 0.5),
                                      blurRadius: 15,
                                      spreadRadius: 5,
                                    ),
                                  ]),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(DAYS[index]['name'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(width: 28),
                                    Image.asset('assets/images/day.png')
                                  ],
                                ),
                              ),
                            ),
                         );
                        
                 
                  },
                )
             
        ),
      ),
    );
  }
}
