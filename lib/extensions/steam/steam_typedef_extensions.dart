import "dart:io";

import "package:path/path.dart" as p;

import "../../steam/steam_typedef.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "../token.dart";

/// Extensions on [SteamTypedef] to generate ffi code
extension SteamTypedefExtensions on SteamTypedef {
  /// Generates necessary code for a [SteamTypedef]
  void generate({
    required IOSink fileSink,
  }) {
    Token token = type.toToken();
    fileSink.writeTypedef(
      alias: name.clearSteamNaming(),
      of: token.typeDart,
    );
  }
}

/// Extensions on [Iterable<SteamTypedef>] to generate ffi code
extension SteamTypedefIterableExtensions on Iterable<SteamTypedef> {
  static const _typedefSkipList = {
    "uint8",
    "int8",
    "int16",
    "uint16",
    "int32",
    "uint32",
    "int64",
    "uint64",
    "lint64",
    "ulint64",
    "intp",
    "uintp",
    "PFNPreMinidumpCallback",
    "SteamInputActionEventCallbackPointer",
    "FnSteamNetConnectionStatusChanged",
    "FnSteamNetAuthenticationStatusChanged",
    "FnSteamRelayNetworkStatusChanged",
    "FnSteamNetworkingMessagesSessionRequest",
    "FnSteamNetworkingMessagesSessionFailed",
    "FnSteamNetworkingFakeIPResult",
    "FSteamNetworkingSocketsDebugOutput",
  };

  /// Generates code for each [SteamTypedef] in
  /// a single file (typedefs.dart)
  Future<void> generateFile({
    required String path,
    required IOSink exportSink,
  }) async {
    String filePath = p.join(path, "typedefs.dart");
    exportSink.writeExport(
      path: "typedefs.dart",
    );
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    fileSink.writeln(
      "// ignore_for_file: public_member_api_docs, always_specify_types, avoid_positional_boolean_parameters, avoid_classes_with_only_static_members",
    );
    fileSink.writeImport(
      packageName: "dart:ffi",
    );
    fileSink.writeImport(
      packageName: "package:ffi/ffi.dart",
    );
    fileSink.writeTypedef(
      alias: "CSteamId",
      of: "int",
    ); // write CSteamID
    fileSink.writeTypedef(
      alias: "CGameId",
      of: "int",
    ); // write CGameID

    for (SteamTypedef steamTypedef
        in where((item) => !_typedefSkipList.contains(item.name))) {
      steamTypedef.generate(
        fileSink: fileSink,
      );
    }

    await fileSink.flush();
    await fileSink.close();
  }
}
