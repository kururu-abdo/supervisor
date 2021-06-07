import 'package:app3/logic/api_response.dart';
import 'package:app3/logic/main_provider.dart';
import 'package:app3/model/models/dept.dart';
import 'package:app3/model/models/level.dart';
import 'package:app3/model/models/student.dart';
import 'package:app3/model/models/supervisor.dart';
import 'package:app3/screens/add_subject.dart';
import 'package:app3/util/app_colors.dart';
import 'package:app3/util/custom_button.dart';
import 'package:app3/util/pop_up_card.dart';
import 'package:app3/util/util.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class Students extends StatefulWidget {
  final Department department;

  const Students({Key key, this.department}) : super(key: key);

  @override
  _StudntsState createState() => _StudntsState();
}

class _StudntsState extends State<Students> {

  Supervisor supervisor;

  getSuperVisor() {
    var admin = Utils.getSuperVisor();
    setState(() {
      supervisor = admin;
    });
  }

@override
void initState() { 
  getSuperVisor();
  super.initState();
  
}

  @override
  Widget build(BuildContext context) {
      var main_provider = Provider.of<MainProvider>(context);
   return Scaffold(
   
 appBar: AppBar(
       
        elevation: 0.0,
      
        title: Text('طلاب القسم'),
        centerTitle: true,
        
      ),
 body: Padding(
        padding: EdgeInsets.all(8.0),
        child: StreamBuilder<List<Student>>(
          stream: main_provider.getStudens(supervisor.dept),
          builder:
              (BuildContext context, AsyncSnapshot<List<Student>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }


             if (!snapshot.hasData) {
             return Center(
                  child: Text('ليس هنالك ااي طالب بالقسم'),
                );

             }
            return ListView(
              children: snapshot.data
                  .map((student) => Card(
                        elevation: 8.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: Container(
                        
                          child: ListTile(
                            onTap: () {
                             
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            title: Text(
                              student.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),

                            subtitle: Text(
                              student.level.name,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            );
          },
        ),
      ),

   );
  }
}


 class StudentsOptions extends StatelessWidget {
   StudentsOptions({Key key}) : super(key: key);
final SearchStudent _delegate = SearchStudent();

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, 
      child: Scaffold(
        appBar: AppBar(title: Text('خيارات البحث' ,  ),centerTitle: true,),
    
        body: Padding(padding: EdgeInsets.all(30.0) ,
        
        
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
    
     Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            child: ListTile(
                              onTap: () async{
                    await         showSearch(context: context, delegate: _delegate);


                              },
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10.0),
                              title: Text(
                               "بحث عن طالب برقم الجلوس",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ) ,




                          SizedBox(height: 10.0,),
                           Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: ListTile(
                    onTap: () {
                       Get.to(() => DeptStudents()
                      
                          );
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      "كل طلاب القسم",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )  ,

                 Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: ListTile(
                    onTap: () {
                       Get.to(() =>LevelStudents(

                        
                         level: Level(id: 1 ,name: 'المستوى الأول'),

                       )
                       
                       );
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      "طلاب المستوى الأول",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                ) ,
                 Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: ListTile(
                    onTap: () {
                       Get.to(() => LevelStudents(
                            level: Level(id: 2, name: 'المستوى الثاني'),
                          ));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      "طلاب المستوى الثاني",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )  ,
                 Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: ListTile(
                    onTap: () {
                      Get.to(() => LevelStudents(
                            level: Level(id: 3, name: 'المستوى الثالث'),
                          ));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      "طلاب المستوى الثالث",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )  ,

                 Card(
                  elevation: 8.0,
                  margin:
                      new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  child: ListTile(
                    onTap: () {
                       Get.to(() => LevelStudents(
                            level: Level(id: 4, name: 'المستوى الرابع'),
                          ));
                    },
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    title: Text(
                      "طلاب المستوى الرابع",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
    
          ],
        )
        ),
    
      ),
    );
  }
}

class DeptStudents extends StatefulWidget {
  DeptStudents({Key key}) : super(key: key);

  @override
  _DeptStudentsState createState() => _DeptStudentsState();
}

class _DeptStudentsState extends State<DeptStudents> {
    Supervisor supervisor = Utils.getSuperVisor();

  @override
  Widget build(BuildContext context) {
       var main_provider = Provider.of<MainProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: new AppBar(
          title: Text('طلاب ${supervisor.dept.name}'),
        ),
        body: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<APIresponse<List<Student>>>(
            future: main_provider.getDeptStudents( supervisor.dept),
            builder: (BuildContext context,
                AsyncSnapshot<APIresponse<List<Student>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
    
              if (!snapshot.hasData) {
                return Center(
                  child: Text('ليس هنالك ااي طالب في هذا  '),
                );
              }
              return ListView(
                children: snapshot.data.data
                    .map((student) => InkWell(
                      onTap: (){
                        Get.to(StudentDetails(student));

                      },
                      child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              child: Card(
                                elevation: 16.0,
                                child: ListTile(
                                  onTap: () {
                        Get.to(StudentDetails(student));


                                  },
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 10.0),
                                  title: Text(
                                    student?.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Text(
                                        student.level.name,
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                         Text(
                                        student.id_number.toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                    ))
                    .toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
class LevelStudents extends StatefulWidget {

  
  Level level;
  Supervisor supervisor;
  LevelStudents({Key key ,   this.level}) : super(key: key);

  @override
  _LevelStudentsState createState() => _LevelStudentsState();
}

class _LevelStudentsState extends State<LevelStudents> {
  Supervisor supervisor = Utils.getSuperVisor();

  @override
  Widget build(BuildContext context) {
          var main_provider = Provider.of<MainProvider>(context);

    return Directionality(
            textDirection: TextDirection.rtl,

      child: Scaffold(appBar: new AppBar(title: Text('طلاب ${widget.level.name}'),),
      
      body: Padding(
          padding: EdgeInsets.all(8.0),
          child: FutureBuilder<APIresponse<List<Student>>>(
            future : main_provider.getLevelStudents( widget.level ,  supervisor.dept),
            builder:
                (BuildContext context, AsyncSnapshot<APIresponse<List<Student>>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
    
              if (!snapshot.hasData) {
                return Center(
                  child: Text('ليس هنالك ااي طالب في هذا  '),
                );
              }
              return ListView(
                children: snapshot.data.data
                    .map((student) => InkWell(
                      onTap: (){
                        Get.to(StudentDetails(student));

                      },
                      child: Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              child: ListTile(
                                onTap: () {
                        Get.to(StudentDetails(student));



                                },
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                title: Text(
                                  student?.name,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: Text(
                                  student.id_number.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                    ))
                    .toList(),
              );
            },
          ),
        ),
    
      
      
      ),
    );
  }
}



class StudentDetails extends StatefulWidget {
  Student student;
  StudentDetails(this.student);

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
bool showWarningForm = false;
  bool showValueForm = false;
var _warningFormKey =   GlobalKey<FormState>();
var _valueFormKey = GlobalKey<FormState>();

TextEditingController  warinigText =  new TextEditingController();

TextEditingController valueText = new TextEditingController();

void onWarning(){
setState(() {
  showWarningForm=true;
  showValueForm=false;
});
}
void onValuated() {
setState(() {
      showWarningForm = false;
      showValueForm = true;
    });


}


  @override
  Widget build(BuildContext context) {
    return   Scaffold(

appBar: AppBar(title: Text('${widget.student.name}'), centerTitle: true,),


body: Padding(padding: EdgeInsets.all(20.0) ,


child: ListView(
  children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [CustomButton(onWarning, 'إنذار', Icons.warning, AppColors.errorColor) ,
  
  
  CustomButton(onValuated, 'إشادة', Icons.title,AppColors.secondaryVariantColor)
  
  ], 



  
)  ,

SizedBox(height: 50,) ,
Visibility(
  visible: showWarningForm,
  child: warningForm(context)) ,
Visibility(
  visible: showValueForm,
  child: valueForm(context)) ,

  ],
),

),
    );
  }


Widget warningForm(BuildContext context){
return Form(
  key: _warningFormKey,
  child: Column(

children: [
  Container(
    child: ConstrainedBox(
       constraints: BoxConstraints(
                  maxHeight: 150.0,
                ),
      child: TextFormField(
        controller: warinigText,
        
        maxLines:  50 ,
        decoration: InputDecoration(
          enabledBorder:  OutlineInputBorder(),
          border: OutlineInputBorder()
        ),
    
    validator: (str){
      if (str.length<0) {
        return "قم بكتابة الرسالة";
      }
      return null;
    },
      ),
    ),
  ) , 


  SizedBox(height: 20,) ,

  Container(
    width: 200,
    child: Card(

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0))
      ),
      elevation: 16.0,
      child: OutlinedButton(onPressed: (){
    
      }, child: Text('ابلاغ الطالب')),
    ),
  )
],


  ));

}


Widget valueForm(BuildContext context) {
    return Form(
        key: _valueFormKey,
        child: Column(
          children: [
            Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 150.0,
                ),
                child: TextFormField(
                  controller: valueText,
                   decoration: InputDecoration(border: OutlineInputBorder() ,   enabledBorder: OutlineInputBorder(),
                  ),
    
                  maxLines: 50,
                  validator: (str) {
                    if (str.length < 0) {
                      return "قم بكتابة الرسالة";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16.0))),
                elevation: 16.0,
                child: OutlinedButton(
                    onPressed: () {}, child: Text('نشر الاشادة')),
              ),
            )
          ],
        ));
  }

}
class SearchStudent extends SearchDelegate<Student> {

SearchStudent():super(keyboardType: TextInputType.number);
 Supervisor supervisor = Utils.getSuperVisor();

  Student student ;
  @override





  List<Widget> buildActions(BuildContext context) {

return <Widget>[
      query.isEmpty
          ? IconButton(
              tooltip: 'Voice Search',
              icon: const Icon(Icons.mic),
              onPressed: () {
                query = 'TODO: implement voice input';
              },
            )
          : IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            ),
    ];
  }
  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
     return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var provider =  Provider.of<MainProvider>(context);
var id =   int.parse(query);

return Center(
  child: FutureBuilder<APIresponse<Student>>(
    future: provider.getStudentById(id  ,   supervisor.dept),
   
    builder: (BuildContext context, AsyncSnapshot<APIresponse<Student>> snapshot) {
     if (snapshot.connectionState==ConnectionState.done) {
       if (snapshot.hasData) {
          return _ResultCard(student: snapshot.data.data);
       }
       return Text('لم يتم العثور على هذا الطالب');
     }

     return CircularProgressIndicator();
    },
  ),
);


  }

  @override
  Widget buildSuggestions(BuildContext context) {
  return Container();
  }




}

class _ResultCard extends StatelessWidget {
   _ResultCard({ this.student, this.searchDelegate});
  final Student student;
  final SearchDelegate<Student> searchDelegate;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () {

      
Get.to(StudentDetails(student));
      },
      child: Container(
        height:  100,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        margin: EdgeInsets.all(20.0),
        child: Card(
          borderOnForeground: true,
          shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),
          elevation: 16.0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(student?.name??"",   style: TextStyle(fontWeight: FontWeight.bold , fontSize: 20.0),),
                Text(
                  '${student?.level?.name ?? ""}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class CustomLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const CustomLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'en' || locale.languageCode == 'ar' ;

  @override
  Future<MaterialLocalizations> load(Locale locale) =>
      SynchronousFuture<MaterialLocalizations>(const CustomLocalization());

  @override
  bool shouldReload(CustomLocalizationDelegate old) => false;

  @override
  String toString() => 'CustomLocalization.delegate(en_US)';
}

class CustomLocalization extends DefaultMaterialLocalizations {
  const CustomLocalization();

  @override
  String get searchFieldLabel => "رقم الجلوس";

  
}
