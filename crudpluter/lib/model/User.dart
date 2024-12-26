class User {
  int id;
  String userName;
  String email;
  String password;

  // Konstruktor dengan parameter id, userName, email, dan password
  User(this.id, this.userName, this.email, this.password);

  // Mengambil data dari JSON
  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      throw Exception('Data tidak ditemukan');
    }

    // Mengonversi ID ke integer jika ID dalam format string
    int id = int.tryParse(json['id'].toString()) ?? 0;

    return User(
      id,
      json['username'] ?? '',  // Default ke string kosong jika username null
      json['email'] ?? '',     // Default ke string kosong jika email null
      json['password'] ?? '',  // Default ke string kosong jika password null
    );
  }

  // Mengirim data ke server
  Map<String, dynamic> toJson() => {
    'id': this.id.toString(),
    'username': this.userName,
    'email': this.email,
    'password': this.password,
  };
}