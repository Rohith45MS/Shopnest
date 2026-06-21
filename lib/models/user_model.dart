class UserModel {
  final int id;
  final String name;
  final String email;
  final String avatar;
  final String role;
  final String creationAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.role,
    required this.creationAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatar: json['avatar'] ?? 'https://i.pravatar.cc/150?img=1',
      role: json['role'] ?? 'customer',
      creationAt: json['creationAt'] ?? '',
    );
  }

  String get validAvatarUrl {
    if (avatar.isEmpty || !avatar.startsWith('http')) {
      return 'https://i.pravatar.cc/150?img=$id';
    }
    return avatar;
  }
}
