class Level{
  int id;
  String name;
Level({this.id ,this.name});
  
Level.fromJson(Map<dynamic, dynamic> json) {
    id = json!=null?json['id']:null ;
    name = json!=null?json['name'] : null;
  }

Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id??null;
    data['name'] = this.name??null;
    return data;
  }

}