class Supervisor {
  String password;
  String address;
  String phone;
  String name;
  String id;
  Dept dept;

  Supervisor(
      {this.password, this.address, this.phone, this.name, this.id, this.dept});

  Supervisor.fromJson(Map<String, dynamic> json) {
    password = json['password'];
    address = json['address'];
    phone = json['phone'];
    name = json['name'];
    id = json['id'];
    dept = json['dept'] != null ? new Dept.fromJson(json['dept']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['password'] = this.password;
    data['address'] = this.address;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['id'] = this.id;
    if (this.dept != null) {
      data['dept'] = this.dept.toJson();
    }
    return data;
  }
}

class Dept {
  String deptCode;
  String name;
  int id;

  Dept({this.deptCode, this.name, this.id});

  Dept.fromJson(Map<String, dynamic> json) {
    deptCode = json['dept_code'];
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dept_code'] = this.deptCode;
    data['name'] = this.name;
    data['id'] = this.id;
    return data;
  }
}
