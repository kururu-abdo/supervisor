import 'dart:convert';

import 'package:app3/model/models/supervisor.dart';

import 'constants.dart';

class Utils {
  
  static Supervisor getSuperVisor(){
      Supervisor admin = Supervisor.fromJson(json.decode(getStorage.read('admin')));

    return admin;
  }
}