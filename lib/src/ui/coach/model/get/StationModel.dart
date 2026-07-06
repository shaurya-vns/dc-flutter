import 'LocationModel.dart';

class StationModel {
  String stationName;
  List<LocationModel> gates;
  List<LocationModel> platforms;
  List<LocationModel> overbridges;

  StationModel({
    required this.stationName,
    required this.gates,
    required this.platforms,
    required this.overbridges,
  });

  factory StationModel.fromJson(Map<dynamic, dynamic> json) {
    return StationModel(
      stationName: json["stationName"] ?? "",
      gates:
          (json["gates"] as List? ?? [])
              .map((e) => LocationModel.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
      platforms:
          (json["platform"] as List? ?? [])
              .map((e) => LocationModel.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
      overbridges:
          (json["overbridge"] as List? ?? [])
              .map((e) => LocationModel.fromJson(Map<String, dynamic>.from(e)))
              .toList(),
    );
  }
}
