class ChatUser {
String id;
String name;
String role;

ChatUser(this.id  , this.name  ,this.role);

ChatUser.fromJson(Map<dynamic ,dynamic> data){
  this.id =  data['id'];
  this.name = data['name'];
  this.role=data['role'];

}

Map<dynamic ,dynamic>  toJson(){
  return {
'id': this.id ,
'name':this.name ,
'role':this.role
  };
}
  
}