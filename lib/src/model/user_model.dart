import 'package:json_annotation/json_annotation.dart';
part 'user_model.g.dart';

@JsonSerializable()
class User {
  String? matricula;
  String? nome;
  String? phone;
  String? password;
  bool?   connected;

  User(
      {this.matricula, this.nome, this.phone, this.password, this.connected});

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
  

}