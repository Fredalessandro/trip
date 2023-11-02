import 'package:json_annotation/json_annotation.dart';

part 'trip_model_http.g.dart';

@JsonSerializable()
class Trip {
  int id;
  String matricula;
  String frota;
  String empresa;
  String origem;
  String destino;
  
  Trip(
      {required this.id,
      required this.matricula,
      required this.frota,
      required this.empresa,
      required this.origem,
      required this.destino});

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  Map<String, dynamic> toJson() => _$TripToJson(this);
}
