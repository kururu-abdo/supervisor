import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {

  final VoidCallback  onPressed;
final Color color;
final String txt;

final IconData icon;
  CustomButton(this.onPressed ,  this.txt , this.icon  ,this.color);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {


  @override
  Widget build(BuildContext context) {
    return buildLoginButtonWidget(context);
  }

  Widget buildLoginButtonWidget(context) {
    var icon2 = this.widget.icon;
    return RawMaterialButton(

              onPressed: widget.onPressed,
              fillColor: widget.color,
              
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children:  [
                    Icon(
                     widget.icon,
                      color: Colors.amber,
                      size: 32,
                    ),
                    SizedBox(
                      width: 10.0,
                    ),
                    Text(
                  widget.txt,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            );
          
  }
}
