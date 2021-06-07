import 'package:app3/logic/main_provider.dart';
import 'package:app3/logic/services_provider.dart';
import 'package:app3/util/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

var _formKey = GlobalKey<FormState>();

TextEditingController phoneController = new TextEditingController();

TextEditingController passwordController = new TextEditingController();
var passwordFocusNose = FocusNode();

class _LoginState extends State<Login> {
  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    var service_provider = Provider.of<ServiceProvider>(context);

    var main_provider = Provider.of<MainProvider>(context);
debugPrint(MediaQuery.of(context).size.width.toString());
    return SafeArea(
      child: 
      
      
      Scaffold(
        resizeToAvoidBottomInset: false,
       
        body:
        
        
         SingleChildScrollView(
reverse: true,

           child: Column(
             //  crossAxisAlignment: CrossAxisAlignment.center,
               
             children: [
               SizedBox(height: 50.0,),
               Center(
         
                 child: Icon(
                   Icons.security_outlined ,
                   color: AppColors.secondaryColor,
                   size: 150,
                 ),
               ) ,
               // Container(
               //     height: MediaQuery.of(context).size.height / 3,
               //     decoration: BoxDecoration(
               //         shape: BoxShape.circle,
               //         color: AppColors.secondaryVariantColor,
               //         image: DecorationImage(
               //             image: AssetImage('assets/images/karari.png'),
               //             fit: BoxFit.contain))),
               
               // Spacer(),
               
               SizedBox(
                 height: 20.0,
               ),
               Center(
                 child: Text('أهلا بك في تطبيق التواصل الجامعي'  ,  style: TextStyle(fontWeight: FontWeight.bold ,),),
               ) ,
         SizedBox(
                 height: 20.0,
               ) ,      
               Padding(
                 padding:  EdgeInsets.only(
                   left: 20,
                   right: 20.0,
                     bottom: MediaQuery.of(context).viewInsets.bottom),
                 child: Form(
                   key: _formKey,
                   child: Center(
                     child: Column(
                       children: [
                         TextFormField(
                           controller: phoneController,
                             onFieldSubmitted: (str) {
                               passwordFocusNose.requestFocus();
                             },
                             keyboardType:TextInputType.number,
                             decoration: InputDecoration(
                               labelText: 'phone',
                               
         
                               // suffixIcon: IconButton(
               
                               //     icon: Icon(isObsecure
               
                               //         ? Icons.visibility
               
                               //         : Icons.visibility_off),
               
                               //     onPressed: () {
               
                               //       setState(() {
               
                               //         isObsecure = !isObsecure;
               
                               //       });
               
                               //     }
                             )),
                         SizedBox(
                           height: 15.0,
                         ),
                         TextFormField(
                           controller: passwordController ,
                           obscureText: isObsecure,
                           focusNode: passwordFocusNose,
                           decoration: InputDecoration(
                               labelText: 'Password',
                               suffixIcon: IconButton(
                                   icon: Icon(isObsecure
                                       ? Icons.visibility
                                       : Icons.visibility_off),
                                   onPressed: () {
                                     setState(() {
                                       isObsecure = !isObsecure;
                                     });
                                   })),
                         ),
                         SizedBox(
                           height: 80.0,
                         ),
                         MaterialButton(
               
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.all(Radius.circular(10.0))
               ),
               child: Text('تسجيل الدخول' ,  style:TextStyle(color: AppColors.onSecondary)),
                           minWidth: 250,
                                                       color: AppColors.secondaryColor, onPressed: () async {
              if (await service_provider.checkInternet()) {
                              await main_provider.login(
                                  phoneController.text, passwordController.text);
                            } else {
                              Fluttertoast.showToast(
                                  msg: "تأكد من أتصالك بالانترنت ^_^",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:AppColors.errorColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          
                                                       }) ,
         
         
                                         ]                  ),
                   ),
                 ),
               )
             ],
           ),
         ),
      ),
    );

    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        //
        // appBar: AppBar(

        //   elevation: 0.0,
        //   toolbarHeight: 80,
        //   title: Text('تسجيل الدخول'),
        //   centerTitle: true,
        //   shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(20),
        //     bottomRight: Radius.circular(20),
        //   )),

        // ),

        body: Padding(
          padding: const EdgeInsets.only(top: 70.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'الهاتف',
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: TextField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'كلمة السر',
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0))),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: ButtonTheme(
                      height: 56,
                      child: RaisedButton(
                        child: Text('تسجيل الدخول',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50)),
                        onPressed: () async {
                          if (await service_provider.checkInternet()) {
                            await main_provider.login(
                                phoneController.text, passwordController.text);
                          } else {
                            Fluttertoast.showToast(
                                msg: "تأكد من أتصالك بالانترنت ^_^",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    passwordFocusNose.dispose();

    super.dispose();
  }
}
