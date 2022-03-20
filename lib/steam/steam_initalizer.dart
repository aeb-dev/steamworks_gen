import "steam_method.dart";

/// Creates a [SteamInitializer]. The initializer does not exist
/// in the steam_api.json. We use this class to create global apis
/// i.e. SteamAPI_Init, SteamAPI_ManualDispatch_Init etc.
class SteamInitializer {
  /// name of the struct
  late String name;

  /// list of [SteamMethod]s of the struct
  late List<SteamMethod> methods;

  /// Creates a [SteamInitializer]
  SteamInitializer({
    required this.name,
    required this.methods,
  });
}
