import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';
import 'package:app3/model/models/subject.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/model/models/teacher%20copy.dart';
import 'package:app3/screens/subjects.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
class AddTime extends StatefulWidget {
  Level level;
  Semester semester;
  Map day;
  Supervisor supervisor;
  AddTime({Key key  , this.level , this.semester , this.day , this.supervisor}) : super(key: key);

  @override
  _AddTimeState createState() => _AddTimeState();
}

class _AddTimeState extends State<AddTime> {
    var uuid = Uuid(options: {'grng': UuidUtil.cryptoRNG});
      RegExp fromRegex = new RegExp(r'([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
      String from;
            RegExp toRegex = new RegExp(r'([0-1]?[0-9]|2[0-3]):[0-5][0-9]$');
            String to;
            ClassSubject classSubject;
            TextEditingController hallController = new TextEditingController();


List<ClassSubject>  subjects =[];
// Supervisor supervisor;

// getSupervisor() async{
 
//     var admin =Provider.of<MainProvider>(context).getAdmin();
// var sup =await Provider.of<MainProvider>(context).getSuperVisorData(admin.phone, admin.password);




//   setState(() {
//     supervisor =  sup.data;
//   });
     
   
// }

@override
  void didChangeDependencies() {

    Provider.of<MainProvider>(context)
        .getAllSubject(widget.supervisor.dept, widget.semester, widget.level)
        .then((element) {
      setState(() {
        subjects = element;
      });
    });  
    
      super.didChangeDependencies();
  }

@override
  void initState() {
 
    super.initState();
  }

var formKey =  GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
        CollectionReference table  = FirebaseFirestore.instance.collection('table');

   return Directionality(textDirection: TextDirection.rtl, child:
    Scaffold(
      
      resizeToAvoidBottomInset: false,
      appBar:AppBar(title: Text('إضافة للجدول') ,   centerTitle: true,) ,
   
   body: Padding(padding: EdgeInsets.all(20.0) ,
   
   child: Form(
     key: formKey,
     child: SingleChildScrollView(
       child: Column(
       
       children: [
       DropdownButtonFormField<ClassSubject>(
              value: classSubject,
              items: subjects.map((subject) => 
              DropdownMenuItem<ClassSubject>(
                  child: Text(subject?.name),
                  value: subject,
                )).toList() 
             ,
               
              onChanged: ( value) {
              setState(() {
                classSubject=value;
              });
              debugPrint(classSubject.name);
              },
              
              hint:Text("اختر المادة")
              ),
          
       SizedBox(height: 20.0,) ,
       
       SizedBox(
       width: 150,
       child:   TextFormField(
       
       decoration: InputDecoration(
         border: OutlineInputBorder(),
         hintText: 'من :  00:00' ,
         suffixIcon: Icon(Icons.timer)
       
       ),
       
       
       
       validator: (str){
       
         if(fromRegex.hasMatch(str) ){
       
        return null;
       
         }else{
       
        return "الوقت المدخل غير صالح";
       
         }
       
       },
       
       onChanged: (str){
       
         setState(() {
       
        from=str;
       
         });
       
       },
       
       
       
       ),
       ) ,
       
       SizedBox(height: 5.0,) ,
       SizedBox(
                        width: 150,
       child:   TextFormField(
       
                          decoration:
       
                              InputDecoration(suffixIcon: Icon(Icons.timer) ,
                               border: OutlineInputBorder(),
                              hintText: 'إلى :  00:00'
                              
                              ),
       
                          validator: (str) {
       
                            if (fromRegex.hasMatch(str)) {
       
                              return null;
       
                            } else {
       
                              return "الوقت المدخل غير صالح";
       
                            }
       
                          },
       
                          onChanged: (str) {
       
                            setState(() {
       
                              to = str;
       
                            });
       
                          },
       
                        ),
       ),
       
       SizedBox(height: 20.0,) ,
       
        TextFormField(
       
        controller: hallController,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.timer),
                            border: OutlineInputBorder(),
                            hintText: 'القاعة'),
                        validator: (str) {
                          if (str.length>0){
                            return null;
                          } else {
                            return "الرجاء ادخال اسم القاعة";
                          }
                        },
                        onChanged:(str){
       hallController.text = str;
                        } ,
                       
                      ),
       
       
       SizedBox(
                        height: 20.0,
                      ),
       OutlinedButton.icon(onPressed: ()async{

       if (formKey.currentState.validate()) {








         var future =  await  showLoadingDialog();

var timetableObject  ={

  "id" :uuid.v4() ,
  "from":from ,
  "to": to ,
  "hall":hallController.text,
  "subject" : classSubject.toJson() ,
  "day": widget.day ,
  "semester":widget.semester .toJson(),
  "level":widget.level.toJson() ,
  "dept":widget.supervisor.dept.toJson()
  

};
table.add(timetableObject)
.then((value) {


  future.dismiss();
  
Get.defaultDialog(title: 'SUCCCESS' ,  content: Text('تمت الاضافة بنجاح') ,   actions: [TextButton(onPressed: (){
  Get.back();
}, child: Text("ok"))]);


})
                                  .catchError((error) {
                                      future.dismiss();

                                    Get.defaultDialog(
                                    title: 'FAILED',
                                    content: Text("حاول مرة اخرى"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text("ok"))
                                    ]);
                                  
                                  }
                                    
                                      
                                      );


       }
       }, icon: Icon(Icons.add), label: Text('إضافة'))
       
       
       
       ],
       ),
     )),
   
   
   ),
   
   ));
  }
}