import 'package:app3/backendless_init.dart';
import 'package:app3/firebase_init.dart';
import 'package:app3/logic/event_provider.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/logic/user_provider.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/screens/add_event.dart';
import 'package:app3/screens/departments.dart';
import 'package:app3/screens/events.dart';
import 'package:app3/screens/profile_page.dart';
import 'package:app3/screens/semesters.dart';
import 'package:app3/screens/splash_screen.dart';
import 'package:app3/screens/students.dart';
import 'package:app3/screens/subjects.dart';
import 'package:app3/screens/teachers.dart';
import 'package:app3/screens/website.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/constants.dart';
import 'package:app3/util/util.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:load/load.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  runApp(LoadingProvider(
      themeData: LoadingThemeData(
        loadingBackgroundColor: Colors.white,
        backgroundColor: Colors.black54,
      ),
      loadingWidgetBuilder: (ctx, data) {
        return Center(
          child: SizedBox(
            width: 30,
            height: 30,
            child: Container(
              child: CupertinoActivityIndicator(),
              color: Colors.blue,
            ),
          ),
        );
      },
      child: MultiProvider(providers: [
        Provider<ServiceProvider>(create: (_) => ServiceProvider()),
        Provider<UserProvider>(create: (_) => UserProvider()),
       
        Provider<EventProvider>(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_)=> MainProvider())
      ], child: MyApp())));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // locale: new Locale('ar'),
       localizationsDelegates: [
          CustomLocalizationDelegate(),
        ],
       supportedLocales: [
             Locale('en', 'US'),
          Locale('ar', ''),
        ],
        theme:   ThemeData(
          primaryColor: AppColors.PrimaryColor ,
          backgroundColor: AppColors.backgroundColor ,  
          scaffoldBackgroundColor: AppColors.backgroundColor ,

          secondaryHeaderColor: AppColors.secondaryColor ,
          colorScheme: ColorScheme(primary: AppColors.PrimaryColor, primaryVariant: AppColors.primaryVariantColor, secondary: AppColors.secondaryColor, secondaryVariant: AppColors.secondaryVariantColor , surface: AppColors.surfaceColor, background: AppColors.backgroundColor ,error: AppColors.errorColor, onPrimary: AppColors.onPrimary , onSecondary: AppColors.onSecondary, onSurface: AppColors.onPrimary, onBackground: AppColors.onPrimary, onError: AppColors.onBackground, brightness: Brightness.light)
          

        ) ,
      // theme: ThemeData(brightness: Brightness.light, primarySwatch: AppColors.PrimaryColor) ,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.

      //     ),
      home: WelcomeScreen()
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    // throw UnimplementedError();

    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {

Supervisor supervisor;

getSuperVisor(){

  var admin =Utils.getSuperVisor();
  setState(() {
    supervisor= admin;
  });
}

  @override
  void initState() {
    super.initState();
    FirebaseInit.init();
    BackendlessInit().init();
    getSuperVisor();
  }

  @override
  Widget build(BuildContext context) {
    var main_provider = Provider.of<MainProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          elevation: 0.0,
          // toolbarHeight: 80,
          title: Text('المشرف'),
          centerTitle: true,
          // shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.only(
          //   bottomLeft: Radius.circular(20),
          //   bottomRight: Radius.circular(20),
          
          // ))
          
          backgroundColor:AppColors.PrimaryColor,
        ),
        drawer: Container(
          width: MediaQuery.of(context).size.width / 2,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.

              padding: EdgeInsets.zero,

              children: <Widget>[
                DrawerHeader(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,

                          backgroundImage: AssetImage('assets/images/user.jpg'),
                          // child: Container(
                          //   decoration: BoxDecoration(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(50))),
                          //   child: Image.asset(
                          //     'assets/images/user.jpg',
                          //     width: 50,
                          //     height: 50,
                          //   ),
                          // ),
                        ),
                        Text(main_provider.getAdmin().name ,  style:TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  decoration:
                      BoxDecoration(color: AppColors.primaryVariantColor),
                ),
                ListTile(
                  leading: Icon(Icons.account_box,
                    color: AppColors.secondaryVariantColor,
                  ),
                  title: Text('الملف الشخصي'),
                  onTap: () {
                    // Update the state of the app.

                    // ...

                    Get.to(MyPrpfole(main_provider.getAdmin()));
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  leading: Icon(Icons.web ,   color: AppColors.secondaryVariantColor,),
                  title: Text('موقع الجامعة'),
                  onTap: () {
                    // Update the state of the app.
Get.bottomSheet(
  
  Container(height: MediaQuery.of(context).size.height/2,
child: Text('lkdlkf'),
) ,
backgroundColor: AppColors.backgroundColor

);
                    // ...

              //      Get.to(WebSite());

                    //    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  leading: Icon(Icons.app_settings_alt,
                    color: AppColors.secondaryVariantColor,
                  ),
                  title: Text('عن التطبيق'),
                  onTap: () {
                    // Update the state of the app.

                    // ...

                    Navigator.pop(context);
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
                ListTile(
                  leading: Icon(Icons.logout,
                    color: AppColors.secondaryVariantColor,
                  ),
                  title: Text('تسجيل خروج '),
                  onTap: () {
                    Get.defaultDialog(
                        title: 'تسجيل خروج',
                        content: Text('هل تود ان تسجل خروج من هذا التطبيق؟'),
                        actions: [
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20))),
                              onPressed: () async {
                                await getStorage.write('isLogged', false);
                                Get.to(WelcomeScreen());
                              },
                              child: Text('نعم')),
                          RaisedButton(
                              color: Colors.red,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                      left: Radius.circular(20),
                                      right: Radius.circular(20))),
                              onPressed: () {
                                Get.back();
                              },
                              child: Text('لا')),
                        ]);
                  },
                ),
              ],
            ),
          ),
        ),
        body: Column(

          children: [
            SizedBox(height: 5,),
            Container(
              height: 200,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 3),
                ),
                items: [
                  'assets/images/slide1.webp',
                  'assets/images/slide2.webp',
                  'assets/images/slide3.webp',
                  'assets/images/slide4.webp',
                  'assets/images/slide5.jpeg'
                ].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        // width: MediaQuery.of(context).size.width,
                        // margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage(i) , fit:BoxFit.cover)),
                      );
                    },
                  );
                }).toList(),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(MyPrpfole(main_provider.getAdmin()));
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                              height: 80,
                              width: 80.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/profile.png')),
                                  shape: BoxShape.circle)),
                          Text('الملف الشخصي' ,  style:TextStyle(fontWeight: FontWeight.bold))
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(Events());
                    },
                    child: Column(
                      children: [
                        Container(
                           height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/news.png')),
                                shape: BoxShape.circle)),
                        Text('الأخبار',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(WebSite());
                    },
                    child: Column(
                      children: [
                        Container(
                              height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/website.png')),
                                shape: BoxShape.circle)),
                        Text('صفحة الكلية',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(Teachers());
                    },
                    child: Column(
                      children: [
                        Container(
                             height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/teacher.png')),
                                shape: BoxShape.circle)),
                        Text('الأساتذة',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(Semsters());
                    },
                    child: Column(
                      children: [
                        Container(
                            height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/time.png') ,  fit:BoxFit.cover),
                                shape: BoxShape.circle)),
                        Text('الجدول',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),



                     InkWell(
                    onTap: () {
                      Get.to(Subjects(supervisor));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage('assets/images/subject.png'),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle)),
                        Text('المواد',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),


                    InkWell(
                    onTap: () {
                      Get.to(StudentsOptions());
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        AssetImage('assets/images/students.png'),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle)),
                        Text('الطلاب',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),

                  
                    InkWell(
                    onTap: () {
                      Get.to(AddEvent());
                    },
                    child: Column(
                      children: [
                        Container(
                            height: 80,
                            width: 80.0,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/result.png'),
                                    fit: BoxFit.cover),
                                shape: BoxShape.circle)),
                        Text('النتيجة',
                            style: TextStyle(fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );

   
  }
}
