import 'package:json_annotation/json_annotation.dart';

part 'sign_up_model_http.g.dart';

@JsonSerializable()
class SignUp {
  String? matricula;
  String? nome;
  String? phone;
  String? password;
  String? confirmPassword;

  SignUp(
      {this.matricula, this.nome,  this.phone,  this.password,  this.confirmPassword});

  factory SignUp.fromJson(Map<String, dynamic> json) =>
      _$SignUpFromJson(json);

  Map<String, dynamic> toJson() => _$SignUpToJson(this);
}