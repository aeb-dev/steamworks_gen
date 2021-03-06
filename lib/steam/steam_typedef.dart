/// Typedef definition for steam api
class SteamTypedef {
  /// name of the typedef
  late String name;

  /// type of the typedef
  late String type;

  /// Creates a [SteamTypedef] from json
  SteamTypedef.fromJson(Map<String, dynamic> json) {
    name = json["typedef"];
    type = json["type"];
  }
}
