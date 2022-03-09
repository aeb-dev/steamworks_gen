/// EnumValue definition for steam api
class SteamEnumValue {
  /// name of the enum value
  late String name;

  /// value of the enum value
  late int value;

  /// Creates a [SteamEnumValue] from json
  SteamEnumValue.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    value = int.parse(json["value"]);
  }
}
