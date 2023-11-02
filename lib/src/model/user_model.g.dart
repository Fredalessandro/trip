// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// *************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    matricula: json['matricula'] as String?,
    nome: json['nome'] as String?,
    phone: json['phone'] as String?,
    password: json['password'] as String?,
    connected: json['connected'] as bool?,
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'matricula': instance.matricula,
      'nome': instance.nome,
      'phone': instance.phone,
      'password': instance.password,
      'connected': instance.connected,
};