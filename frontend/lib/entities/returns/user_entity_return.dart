class UserEntityReturn {
  final int id;
  final String name;
  final String email;
  final String password;
  final int target;
  final double peso;

  const UserEntityReturn(
      {required this.id,
      required this.name,
      required this.email,
      required this.password,
      required this.target,
      required this.peso});

  factory UserEntityReturn.fromJson(Map<String, dynamic> json) {
    int id = json['id'];
    String name = json['name'];
    String email = json['email'];
    String password = json['password'];
    int target = 0;
    double peso = 0.0;

    if (json['peso'] is! double) {
      if (json['peso'] is int) {
        peso = json['peso'].toDouble();
      } else {
        peso = double.parse(json['peso']);
      }
    } else {
      peso = json['peso'];
    }

    if (json['target'] is int) {
      target = json['target'];
    } else {
      target = int.parse(json['target']);
    }

    return UserEntityReturn(
        id: id,
        name: name,
        email: email,
        password: password,
        target: target,
        peso: peso);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'target': target,
        'peso': peso
      };

  Map<String, dynamic> toJsonAPI() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'target': target,
        'peso': peso
      };

}
