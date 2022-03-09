import "dart:io";

import "package:path/path.dart" as p;

import "../../steam/steam_typedef.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";

/// Extensions on [SteamTypedef] to generate ffi code
extension SteamTypedefExtensions on SteamTypedef {
  /// Generates necessary code for a [SteamTypedef]
  Future<void> generate(IOSink fileSink) async {
    fileSink.writeTypedef(typedef.clearSteamNaming(), type.toDartType());
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

  /// Creates the typedef file and appends the generated code of each [SteamTypedef]
  Future<void> generate(String path) async {
    String filePath = p.join(path, "typedefs.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    fileSink.writeImport("dart:ffi");
    fileSink.writeImport("package:ffi/ffi.dart");
    fileSink.writeTypedef("CSteamId", "int"); // write CSteamID
    // fileSink.writeTypedef("CSteamIDNative", "Uint64"); // write CSteamID
    fileSink.writeTypedef("CGameId", "int"); // write CGameID
    // fileSink.writeTypedef("CGameIDNative", "Uint64"); // write CGameID

    for (SteamTypedef steamTypedef
        in where((item) => !_typedefSkipList.contains(item.typedef))) {
      await steamTypedef.generate(fileSink);
    }

    await fileSink.flush();
    await fileSink.close();
  }
}