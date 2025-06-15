import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_model.g.dart';

@JsonSerializable()
class WeatherModel extends Equatable {
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String location;

  const WeatherModel({
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.location,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) => 
      _$WeatherModelFromJson(json);

  Map<String, dynamic> toJson() => _$WeatherModelToJson(this);

  @override
  List<Object?> get props => [
        temperature,
        condition,
        humidity,
        windSpeed,
        location,
      ];
}