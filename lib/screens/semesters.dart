 import 'package:app3/logic/api_response.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/screens/levels_screen.dart';
import 'package:app3/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Semsters extends StatelessWidget {
   Semsters({Key key}) : super(key: key);
  List<Semester>  semesters =[];





  @override
  Widget build(BuildContext context) {
   return Directionality(
     textDirection: TextDirection.rtl,
     child: Scaffold(appBar: new AppBar(title: Text('السمستر'), centerTitle: true,),
     
     body: Center(

       child: FutureBuilder<APIresponse<List<Semester>>>(
         future: Provider.of<MainProvider>(context).getSemesters(),
        
         builder: (BuildContext context, AsyncSnapshot<APIresponse<List<Semester>>> snapshot) {
          if(snapshot.hasData){
return ListView.builder(
  itemCount: snapshot.data.data.length,
  padding: EdgeInsets.all(30.0),
  itemBuilder: (BuildContext context, int index) {
  return InkWell(
                          onTap: () {

                 Get.to(LevelScreen(snapshot.data.data[index]));

                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            height: MediaQuery.of(context).size.width / 2 - 70,
                            margin: EdgeInsets.all(10.0),
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
                                  Text(snapshot.data.data[index].name,
                                      style: TextStyle(
   fontSize: 16,
   fontWeight: FontWeight.bold)),
                                  SizedBox(width: 28),
                                  Image.asset('assets/images/semester.png')
                                ],
                              ),
                            ),
                          ),
                        );
 },
);
          }if(snapshot.hasError){
            return Center(child: Text(snapshot.error.toString()),);
          }
          else {
            return Center(child:CircularProgressIndicator());
          }
         },
       ),
     ),
     
     ),
   );
  }
}