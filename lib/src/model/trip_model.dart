import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:trip/src/model/launch_trip_model.dart';

part 'trip_model_http.g.dart';

@JsonSerializable()
class Trip {
  int id;
  String matricula;
  String frota;
  String empresa;
  String origem;
  String destino;
  List<LaunchTrip> launchTrips;
  
  Trip(
      {required this.id,
      required this.matricula,
      required this.frota,
      required this.empresa,
      required this.origem,
      required this.destino,
      required this.launchTrips});

  factory Trip.fromJson(Map<String, dynamic> json) => _$TripFromJson(json);

  Map<String, dynamic> toJson() => _$TripToJson(this);
}
