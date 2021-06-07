import 'dart:io';

class ServiceProvider{
     Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        return true;
      } else {
        print('disconnetced');
        return false;
      }
    } on SocketException catch (_) {
      print('not connected');

      return false;
    }
  }
}