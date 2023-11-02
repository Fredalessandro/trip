// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FormSignIn _$FormSignInFromJson(Map<String, dynamic> json) {
  return FormSignIn(
    matricula: json['matricula'] as String?,
    nome:      json['nome']      as String?,
    password:  json['password']  as String?
  );
}

Map<String, dynamic> _$FormSignInToJson(FormSignIn instance) => <String, dynamic>{
      'matricula': instance.matricula,
      'nome':      instance.nome,
      'password':  instance.password
};
