class User {
  late String id;
  late String username;
  late String password;

  User();
  User.fromMap(Map<String, dynamic> data) {
    id = data['id'];
    username = data['username'];
    password = data['password'];
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'username': username, 'password': password};
  }
}
