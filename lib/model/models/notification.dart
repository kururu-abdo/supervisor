
class Notification{
  int id;
  DateTime time;
  
  String title;
  String screen;
  String object;
Notification(this.id ,this.title,this.screen ,this.object , this.time);

Notification.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.title = data['title'];
  this.screen = data['screen'];
  this.object =data['object'];
  this.time = data['time'];
}

Map<dynamic ,dynamic> toJson(){
  return {
'id': this.id ,
'title':this.title ,
'screen':this.screen ,
'object': this.object ,
'time': this.time
  };
}


}