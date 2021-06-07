import 'package:flutter/material.dart';
class Header extends StatelessWidget{
final String title;
final Color color;

  const Header({Key key, this.title, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
  height: 80,
  decoration:BoxDecoration(
  color: this.color,
                    borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(20.0),
                              right: Radius.circular(20.0),
                            ),
  ),
child: Row(

mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children:[
IconButton(icon:Icon(Icons.arrow_back_ios), onPressed:(){
Navigator.of(context).pop();
})

,
Padding(
  padding:EdgeInsets.only(left:8.0) ,
  
  child: Text(this.title))

  ]
),

    );
  }





}