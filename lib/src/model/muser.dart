class MUser {
  MUser({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.online,
    this.gender,
    this.birthday,
    this.label,
  });

  String id;
  String name;
  String photoUrl;
  bool online;
  String? gender;
  DateTime? birthday;
  String? label;
}
