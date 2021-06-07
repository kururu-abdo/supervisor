
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/screens/add_time.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class TimeTable extends StatefulWidget {
  Map day;
  Semester semester;
  Level level;


   TimeTable({Key key ,  this.day , this.level  , this.semester}) : super(key: key);

  @override
  _TimeTableState createState() => _TimeTableState();
}

class _TimeTableState extends State<TimeTable> {

Supervisor supervisor;


getSupervisor() async {
  print('get it');
  
    var sup = Utils.getSuperVisor();

    setState(() {
      supervisor = sup;
    });
  }

@override
  void initState() {
    getSupervisor();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
    appBar: AppBar(title: Text(widget.day['name']),  centerTitle: true,),
    
    body:Padding(padding: EdgeInsets.all(20.0) ,
    
    child: Center(
   child:   FutureBuilder(
        future:
         Provider.of<MainProvider>(context).getTimeTableOfDay(widget.day, supervisor?.dept , widget.level, widget.semester),

        builder: (BuildContext context, AsyncSnapshot snapshot) {
        
if (snapshot.hasData) {
  return   ListView.builder(
    itemCount: snapshot.data.length,
    itemBuilder: (BuildContext context, int index) {
    return Container(

      decoration: BoxDecoration(
        color: Colors.white,


        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(

          )
        ]
      ),
      child: ListTile(

trailing:

      IconButton(
                                      onPressed: () async {


showCupertinoDialog(context: context, builder: (context){

return CupertinoAlertDialog(
title: Text("حذف"),

actions: [
  CupertinoButton(child: Text('نعم'), onPressed: (){

Provider.of<MainProvider>(context ,listen: false).deletTimeOfDay(snapshot.data[index].data());
  }) ,

CupertinoButton(
                                                  child: Text('لا'),
                                                  onPressed: () {

                                                    Get.back();
                                                  })


],
);

});



                                      }, icon: Icon(Icons.delete ,
                                        color: AppColors.PrimaryColor,
                                      )) ,
//  leading: Text(snapshot.data[index].data()['hall']),


        subtitle:  Column(children:[

Text(
                                    snapshot.data[index].data()['from']
                                        ,
                                  ) ,
                                  Text(
                                    snapshot.data[index].data()['to'],
                                  )



        ]  ,
        ) ,
        
        title: Text(snapshot.data[index].data()['subject']['name'],) ),
    );
   },
  );
}else{
  return Center(child: CircularProgressIndicator(),);
}

        },
      ),
    ),
    
    
    ),
    floatingActionButton: FloatingActionButton(
    child: Icon(Icons.add),
    
      onPressed: (){
    Get.to(AddTime(level: widget.level , semester: widget.semester ,day:widget.day, supervisor: this.supervisor,));
      },
    )
    
      ),
    );
  }
}