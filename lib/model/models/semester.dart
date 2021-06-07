class Semester{
  int id;
  String name;


  Semester(this.id ,this.name);


  Semester.fromJson(Map<dynamic ,dynamic> json){
    this.id=  json['id'];
    this.name = json['name'];
  }

Map<dynamic ,dynamic>  toJson(){
  return {
    'id': this.id,
    'name': this.name
  };
}

}