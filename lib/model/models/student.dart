

import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/semester.dart';

class Student{

  String name;

String  id_number;
String password;
String profile_image;
Department department;
Level level;

Semester semester;

Student(this.name ,this.id_number  ,this.password  ,this.department  ,this.level ,this.profile_image ,this.semester );



Student.fromJson(Map<dynamic ,dynamic> data){

  this.name=data['name'];

  this.id_number = data['id_number'];

  this.password = data['password'];


  this.department =  Department.fromJson(data['dept']);
  this.level = Level.fromJson( data['level']);
  this.semester =  Semester.fromJson(data['semester']);



}

Map<dynamic ,dynamic> toJson() => {
'name' : this.name ,

'id_number': this.id_number ,

'password': this.password ,

'dept': this.department.toJson() ,

'level' : this.level.toJson() ,
'semester': this.semester.toJson()


 };







}