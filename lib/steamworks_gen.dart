import "dart:convert";
import "dart:io";

import "package:path/path.dart" as path;

import "extensions/steam/steam_api_extensions.dart";
import "steam/steam_api.dart";

/// Generates the steam api
/// [steamApiJsonPath] is the path for steam_api.json file
/// [outputPath] is the path of the output folder
/// [target] is the target platform. i.e win for windows. Possible values win, linux, mac, arm
Future<void> generate(
  String steamApiJsonPath,
  String outputPath,
  String target,
) async {
  bool isRelative = path.isRelative(steamApiJsonPath);
  if (isRelative) {
    steamApiJsonPath =
        path.normalize(path.join(path.current, steamApiJsonPath));
  }

  isRelative = path.isRelative(outputPath);
  if (isRelative) {
    outputPath = path.normalize(path.join(path.current, outputPath));
  }

  String jsonContent = await File(steamApiJsonPath).readAsString();
  Map<String, dynamic> json = jsonDecode(jsonContent);
  SteamApi steamApi = SteamApi.fromJson(json);

  await steamApi.generate(
    path: outputPath,
    target: target,
  );
}
