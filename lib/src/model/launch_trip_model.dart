import 'package:json_annotation/json_annotation.dart';

part 'launch_trip_model_http.g.dart';

@JsonSerializable()
class LaunchTrip { 
  int id;
  String destino;
  String dia;
  String hora;
  String km;
  String tipo;

  LaunchTrip(
      {required this.id,
      required this.destino,
      required this.dia,
      required this.hora,
      required this.km,
      required this.tipo});

  factory LaunchTrip.fromJson(Map<String, dynamic> json) => _$LaunchTripFromJson(json);

  Map<String, dynamic> toJson() => _$LaunchTripToJson(this);

}