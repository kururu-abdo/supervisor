import 'dart:convert';

import 'package:app3/firebase_init.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/teacher%20copy.dart';
import 'package:app3/util/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:load/load.dart';



class MyPrpfole extends StatefulWidget {
final Admin admin;
  MyPrpfole(this.admin);

  @override
  _MyPrpfoleState createState() => _MyPrpfoleState();
}

class _MyPrpfoleState extends State<MyPrpfole> {


  @override
  void initState() { 
    super.initState();
    

    FirebaseInit.init();






  }

  
  @override
  Widget build(BuildContext context) {
var main_provider = Provider.of<MainProvider>(context);
    Query admin = FirebaseFirestore.instance.collection('supervisor')
     .where('id',isEqualTo: 
      widget.admin.id
      );
 return    Scaffold(
   backgroundColor: AppColors.backgroundColor,
  appBar: AppBar(
    backgroundColor: AppColors.PrimaryColor,
        title: Text('الملف الشخصي'),
        centerTitle: true,
       
      ),


   body : FutureBuilder<QuerySnapshot>(
     future: admin.get(),
   
     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

    
    
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.connectionState == ConnectionState.done) {
           debugPrint(snapshot.data.size.toString()); 
            Map<String, dynamic> data = snapshot.data.docs.first.data();
            
       return Padding(
              padding: const EdgeInsets.all(0.0),
              child: ListView(
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [AppColors.PrimaryColor,
                              AppColors.primaryVariantColor2])),
                      child: Container(
                        width: double.infinity,
                        height: 350.0,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  "https://www.rd.com/wp-content/uploads/2017/09/01-shutterstock_476340928-Irina-Bg.jpg",
                                ),
                                radius: 50.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "${data['name']}",
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Card(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 5.0),
                                clipBehavior: Clip.antiAlias,
                                color: Colors.white,
                                elevation: 5.0,
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 22.0),
                                    child: Center(
                                      child: Text(
                                        "${data['address']}",
                                        style: TextStyle(
                                          color:AppColors.onBackground,
                                          fontSize: 22.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      )),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "البيانات الشخصية:",
                            style: TextStyle(
                                color: AppColors.onBackground,
                                fontStyle: FontStyle.normal,
                                fontSize: 28.0),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),

                          Center(
                            child: Form(
                                child: Column(
                              children: [
                                Center(
                                    child: ListTile(
                                  title: Text('${data['phone']}'),
                                  trailing: IconButton(
                                      icon: Icon(Icons.edit ,  color: AppColors.secondaryVariantColor,),
                                      onPressed: () async {
//                                        await editPhone(context);
                                      }),
                                )

                                    //  Row(

                                    //   children: [

                                    //     Text('${teacher.phone}' ) ,

                                    //   ]

                                    // ),

                                    ),
                                Center(
                                    child: ListTile(
                                  title: Text('${data['name']}'),
                                  trailing: IconButton(icon: Icon(Icons.edit,color: AppColors.secondaryVariantColor,) ,onPressed: () async{
  //                                 await  editAddres(context);
                                  },),
                                )

                                    ),
            //                         Center(

            // //child:Text(semesters[1].toJson().toString())


            //                       child:   new DropdownButtonFormField<Semester>(
            //                       value: semester,
            //                       items:semesters.map((sem){
            //                         // debugPrint(sem.toJson().toString());
            //                         return DropdownMenuItem<Semester>(
    
            //                                 value: sem,
            //                                   child: Text(sem.name),);
            //                                    }).toList(),
            //                       onChanged: (newValue){
            //                         setState(() {
            //                           semester=newValue;
            //                         });
            //                       },
            //                     ),

            //                         )

                              ],
                            )),
                          )
                          // Text('My name is Alice and I am  a freelance mobile app developper.\n'
                          //     'if you need any mobile app for your company then contact me for more informations',
                          //   style: TextStyle(
                          //     fontSize: 22.0,
                          //     fontStyle: FontStyle.italic,
                          //     fontWeight: FontWeight.w300,
                          //     color: Colors.black,
                          //     letterSpacing: 2.0,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20.0,
                  // ),
                  // Container(
                  //   width: 300.00,

                  //   child: RaisedButton(
                  //     onPressed: (){

                  //       print('fetch calling activity');
                  //     },
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(80.0)
                  //     ),
                  //     elevation: 0.0,
                  //       padding: EdgeInsets.all(0.0),
                  //     child: Ink(
                  //       decoration: BoxDecoration(
                  //         gradient: LinearGradient(
                  //           begin: Alignment.centerRight,
                  //           end: Alignment.centerLeft,
                  //           colors: [Colors.redAccent,Colors.pinkAccent]
                  //         ),
                  //         borderRadius: BorderRadius.circular(30.0),
                  //       ),
                  //       child: Container(
                  //         constraints: BoxConstraints(maxWidth: 300.0, minHeight: 50.0),
                  //         alignment: Alignment.center,
                  //         child: Text("call me",
                  //         style: TextStyle(color: Colors.white, fontSize: 26.0, fontWeight:FontWeight.w300),
                  //         ),
                  //       ),
                  //     )
                  //   ),
                  // ),
                ],
              ),
            );



          }

return Center(
    child: CircularProgressIndicator(),
);

     },
   ),
 );
 
 
  }

//  editPhone( BuildContext context)  async {
//    var studentProvider = Provider.of<UserProvider>(context ,listen: false);
//          showDialog(

//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('تعديل الرقم الجامعي'),
//           content:
//           TextField(

//             keyboardType: TextInputType.number,
//             onChanged: (value) {
     
//             },
//             controller: idController,
//             decoration: InputDecoration(hintText: "الرقم الجامعي"),
//           ),


//           actions: <Widget>[

//              FlatButton(
//                color: Colors.red,
//                textColor: Colors.white,
//                child: Text('cancel'),
//                onPressed: () {
//                  setState(() {
//                   //  codeDialog = valueText;
//                    Navigator.pop(context);
//                  });
//                },
//              ),
//              FlatButton(
//                color: Colors.green,
//                textColor: Colors.white,
//                child: Text('OK'),
//                onPressed: () async {
                 

//                             CollectionReference students =
//                       FirebaseFirestore.instance.collection('student');
//                   // .where('id' , isEqualTo:teacher.id)
//                   // .get()
//                   // ;
//                   QuerySnapshot current_teacer = await students
//                       .where('id_number', isEqualTo:  widget.student.id_number)
//                       .get();
//                   print(widget.student.id_number);
//                   print(current_teacer.docs.toString());

//                   var doc_id = current_teacer.docs.first.id;

//                   debugPrint(doc_id);
//                   if (idController.text.length > 0) {
//                     await students
//                         .doc(doc_id)
//                         .update({'id_number': '${idController.text}'});
//                   }
//                await    studentProvider.updateId(idController.text);




//                                   setState(() {
//                                    //  codeDialog = valueText;
//                                     Navigator.pop(context);
//                                   });
//                                 },
//                               ),
                   
//                             ],
//                          );
//                        });
//                  }
                 
//                   editAddres( BuildContext context)  async {
//          showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Edit Address'),
//             content: TextField(
//               keyboardType: TextInputType.phone,
//               onChanged: (value) {},
//               controller: addressController,
//               decoration: InputDecoration(hintText: "new Address Name"),
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 color: Colors.red,
//                 textColor: Colors.white,
//                 child: Text('cancel'),
//                 onPressed: () {
//                   setState(() {
//                     //  codeDialog = valueText;
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//               FlatButton(
//                 color: Colors.green,
//                 textColor: Colors.white,
//                 child: Text('OK'),
//                 onPressed: () async {
//                   await updateAddress();
//                   setState(() {
//                     //  codeDialog = valueText;
//                     Navigator.pop(context);
//                   });
//                 },
//               ),
//             ],
//           );
//         });

//                  }
//                           updatePhone(UserProvider provider)  async{

//                             CollectionReference  students =   FirebaseFirestore.instance.collection('student');
//                             // .where('id' , isEqualTo:teacher.id)
//                             // .get()
//                             // ;
//                QuerySnapshot current_teacer =     await      students
//                          .where('id_number' , isEqualTo:  widget.student.id_number)
//                            .get();
//                            print(widget.student.id_number);
// print(current_teacer.docs.toString());

// var doc_id=    current_teacer.docs.first.id;
                           
//                     debugPrint(doc_id);       
//                             if (idController.text.length>0) {
                            
                            
//    await              students
                            
//                  .doc(doc_id)
                             
                            
                             
                              
//     .update({'id_number': '${idController.text}'});
//                             }
//     provider.updateId(idController.text);
// }    


// updateAddress() async {
//     CollectionReference teachers =
//         FirebaseFirestore.instance.collection('teacher');
//     // .where('id' , isEqualTo:teacher.id)
//     // .get()
//     // ;
//     QuerySnapshot current_teacer = await teachers
//         .where('id', isEqualTo: int.parse(widget.student.id_number))
//         .get();


//     var doc_id = current_teacer.docs.first.id;

//     if (idController.text.length > 0) {
//       teachers
//           .doc(doc_id)
//           .update({'address': '${addressController.text}'})
//           .then((value) => print("User Updated"))
//           .catchError((error) => print("Failed to update user: $error"));
//     }
//   }    



                 }
                 
    
