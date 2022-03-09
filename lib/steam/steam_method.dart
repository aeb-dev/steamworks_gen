import "steam_param.dart";

/// Method definition for steam api
class SteamMethod {
  /// name of the method
  late String name;

  /// flat name of accessor in order to lookup symbol in the library
  late String nameFlat;

  /// list of [SteamParam]s of the method
  late List<SteamParam> params;

  /// c return type of the method
  late String returnType;

  /// flat return type of the method
  late String returnTypeFlat;

  /// callResult of the method to be used with asynchrous apis
  late String callResult;

  /// callback of the method in order to resolve the callback struct
  late String callback;

  /// Creates a [SteamMethod] from json
  SteamMethod.fromJson(Map<String, dynamic> json) {
    name = json["methodname"];
    nameFlat = json["methodname_flat"];
    params =
        json["params"].map<SteamParam>((v) => SteamParam.fromJson(v)).toList();
    returnType = json["returntype"];
    returnTypeFlat = json["returntype_flat"] ?? "";
    callResult = json["callresult"] ?? "";
    callback = json["callback"] ?? "";
  }
}
