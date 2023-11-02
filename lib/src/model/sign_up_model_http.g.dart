// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_up_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SignUp _$SignUpFromJson(Map<String, dynamic> json) {
  return SignUp(
    matricula: json['matricula'] as String?,
    phone: json['phone'] as String?,
    password: json['password'] as String?,
  );
}

Map<String, dynamic> _$SignUpToJson(SignUp instance) => <String, dynamic>{
      'matricula': instance.matricula,
      'phone': instance.phone,
      'password': instance.password,
};
