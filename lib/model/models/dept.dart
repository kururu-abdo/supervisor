class Department {
  int id;
  String name;
  String dept_code;
  Department.fromJson(Map<dynamic, dynamic> json) {
    id = json != null ? json['id'] : null;
    name = json != null ? json['name'] : null;
    dept_code = json != null ? json['dept_code'] : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? null;
    data['name'] = this.name ?? null;
    data['dept_code'] = this.dept_code ?? null;
    return data;
  }
}
