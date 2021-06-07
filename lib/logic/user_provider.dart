import 'dart:convert';

import 'package:app3/model/models/teacher%20copy.dart';
import 'package:app3/util/constants.dart';

class UserProvider {

  Admin  getAdmin() {
   var admin =  Admin.fromJson(json.decode(getStorage.read('admin')));

   
   return admin;
  }
}