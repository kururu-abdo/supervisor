import 'package:firebase_core/firebase_core.dart';

class FirebaseInit{

static init() async{

  try{
        await Firebase.initializeApp();
      // setState(() {
      //   _initialized = true;
      // });
    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      // setState(() {
      //   _error = true;
      // });
    }
}

}