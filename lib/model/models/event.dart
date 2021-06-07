import 'dart:convert';

import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Event{
  String id;
  String title;

  String body;
  Timestamp time;
  List Files ;
  Level level;
  Department department;

Event(this.id, this.title ,this.body ,this.Files,this.level ,this.department);

Event.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.title = data['title']??'';
  this.body =data['body']??'';
  this.time =data['time']??'';
  this.Files= data['files'];
  this.department =Department.fromJson( data['dept'])??null;

  this.level =   Level.fromJson(data['level'])??null;
}

Map<dynamic ,dynamic>  toJson(){

  return  {
  'id':  this.id ,
  'title': this.title ,
  'body':this.body ,
  'time': this.time ,
  'files': this.Files,
  'dept': this.department.toJson() ,
  'level': this.level.toJson()

  };
}


}