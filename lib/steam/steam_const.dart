/// Consant definition for steam api
class SteamConst {
  /// name of the constant
  late String name;

  /// c type of the constant
  late String type;

  /// value of the constant
  late String value;

  /// Creates a [SteamConst]. This constructor is used
  /// for manual [SteamConst] creation
  SteamConst({
    required this.name,
    required this.type,
    required this.value,
  });

  /// Creates a [SteamConst] from json
  SteamConst.fromJson(Map<String, dynamic> json) {
    name = json["constname"];
    type = json["consttype"];
    value = json["constval"];
  }
}
