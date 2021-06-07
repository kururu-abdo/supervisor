import 'package:backendless_sdk/backendless_sdk.dart';

class BackendlessInit {


  
  static const String SERVER_URL = "https://api.backendless.com";
  static const String APPLICATION_ID = "F698C529-1FF3-871A-FF6D-52A0154D3600";
  static const String ANDROID_API_KEY = "3BA6F57F-CA1D-43E5-AA56-AEBFDFD5982B";
  static const String IOS_API_KEY = "72521EEB-F3A3-40E4-A1C6-18A539269C0D";
	static const String JS_API_KEY = "5EB0896C-52DA-477C-AE1B-99AE73291C23";

	BackendlessServer(){
init();

  }
	void init() async{
 await Backendless.setUrl(SERVER_URL);

 //for mobile
    await Backendless.initApp(
      APPLICATION_ID,
      ANDROID_API_KEY,
      IOS_API_KEY);

      //for web
		await Backendless.initWebApp(
			APPLICATION_ID,
			JS_API_KEY);

  }
  
}