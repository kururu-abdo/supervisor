class User {
  String id;
  String name;
  String role;

  User(this.id, this.name, this.role);

  User.fromJson(Map<dynamic, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    this.role = data['role'];
  }

  Map<dynamic, dynamic> toJson() {
    return {
      'id': this.id,
      'name': this.name,
      'role': this.role,
    };
  }

  @override
  bool operator ==(other) {
    return (other is User) &&
        other.name == name &&
        other.id == id &&
        other.role == role;
  }
}
