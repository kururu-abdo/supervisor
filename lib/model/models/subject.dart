


import 'package:app3/model/models/teacher.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/semester.dart';
class ClassSubject {

  String  id;
  String name;
  Department department;
  Level level;
  Teacher teacher;
  Semester semester;


ClassSubject(this.id  ,this.name  , this.department ,this.level ,this.teacher , this.semester);

ClassSubject.fromJson(Map <dynamic ,dynamic >  data){

this.id = data['id']?.toString() ??"";
this.name = data['name'];
this.department= Department.fromJson( data['dept'])    ;
this.level = Level.fromJson( data['level']);
this.teacher = Teacher.fromJson( data['teacher']);
this.semester =  Semester.fromJson(data['semester']);



}



Map <dynamic ,dynamic >  toJson(){
  return  {
'id' :this.id ,
'name' : this.name ,
'department' : this.department.toJson()  ,
'level' : this.level.toJson(),
'teacher' : this.teacher?.toJson() ,
'semester' : this.semester.toJson()


  };
}

  
}