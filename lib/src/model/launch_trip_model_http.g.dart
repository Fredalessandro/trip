// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'launch_trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LaunchTrip _$LaunchTripFromJson(Map<String, dynamic> json) {
  return LaunchTrip(
    id: json['id'] ,
    destino:    json['destino'] as String,
    dia:        json['dia']  as String,
    hora:       json['hora']  as String,
    km:         json['km']  as String,
    tipo:       json['tipo']  as String,
  );
}

Map<String, dynamic> _$LaunchTripToJson(LaunchTrip instance) => <String, dynamic>{
      'id': instance.id,
      'destino':   instance.destino,
      'dia':   instance.dia,
      'hora':  instance.hora,
      'km':  instance.km,
      'tipo': instance.tipo
};
