import 'package:flutter/material.dart';


class Admin {

  String  id;
  String name;
  String phone;
  String password;
  String address;
 


Admin(this.id  ,this.name  , this.address ,this.password ,this.phone );

Admin.fromJson(Map <dynamic ,dynamic >  data){

this.id = data['id'].toString();
this.name = data['name'];
this.phone= data['phone'];
this.address = data['address'];
this.password =  data['password'];




}



Map <dynamic ,dynamic >  toJson(){
  return  {
'id' :this.id ,
'name' : this.name ,
'phone' : this.phone  ,
'address' : this.address,
'password' : this.password ,



  };
}

  
}