import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/screens/levels.dart';
import 'package:app3/screens/students.dart';
import 'package:app3/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Departments extends StatefulWidget {
  @override
  _DepartmentsState createState() => _DepartmentsState();
}

class _DepartmentsState extends State<Departments> {
  @override
  Widget build(BuildContext context) {
    var main_provider =  Provider.of<MainProvider>(context);
   return Scaffold(
backgroundColor:AppColors.appBarColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBarColor,
        elevation: 0.0,
        toolbarHeight: 80,
        title: Text('اقسام الكلية'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        )),
    
      ),

      body: Padding(padding: EdgeInsets.all(8.0),
      
      child: StreamBuilder<List<Department>>(
        stream: main_provider.getDepartments(),
        builder: (BuildContext context, AsyncSnapshot<List<Department>> snapshot){
          if (snapshot.connectionState==ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }

       

          return  ListView(
            children: snapshot.data.map((dept)=>
            


            Card(
                elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),

              child: Container(

                 decoration: BoxDecoration(
                              color: Colors.green[200]),
                child: ListTile(

                onTap: (){
                  Get.to(Levels(dept));
                },


                      contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                                
                  title: Text(dept.name ,  style: TextStyle(color:Colors.black ,fontWeight: FontWeight.bold),),),
              ),
            )
            ).toList(),
          );
        },
      ),
      ),
   );
  }
}