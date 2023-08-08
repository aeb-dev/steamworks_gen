// ignore: comment_references
/// Accessor field of [SteamInterface]s
class SteamAccessor {
  /// kind of accessor
  late String kind;

  /// name of accessor
  late String name;

  /// flat name of accessor in order to lookup symbol in the library
  late String nameFlat;

  /// Creates a [SteamAccessor] from json
  SteamAccessor.fromJson(Map<String, dynamic> json) {
    kind = json["kind"];
    name = json["name"];
    nameFlat = json["name_flat"];
  }
}
