// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Trip _$TripFromJson(Map<String, dynamic> json) {
  return Trip(
    id: json['id'] as int,
    matricula: json['matricula'] as String,
    frota:     json['frota'] as String,
    empresa:   json['empresa'] as String,
    origem:    json['origem'] as String,
    destino:   json['destino'] as String
  );
}

Map<String, dynamic> _$TripToJson(Trip instance) => <String, dynamic>{
      'id':  instance.id,
      'matricula': instance.matricula,
      'frota':     instance.frota,
      'empresa':   instance.empresa,
      'origem':    instance.origem,
      'destino':   instance.destino
};
