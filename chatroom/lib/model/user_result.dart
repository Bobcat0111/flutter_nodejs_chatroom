class User {
  int id;
  String username;
  User(this.id,this.username){}

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'];
}
