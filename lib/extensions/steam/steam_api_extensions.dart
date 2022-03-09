import "dart:io";

import "package:path/path.dart" as p;

import "../../steam/steam_api.dart";
import "../../steam/steam_field.dart";
import "../../steam/steam_interface.dart";
import "../../steam/steam_struct.dart";
import "../file_extensions.dart";
import "steam_const_extensions.dart";
import "steam_enum_extensions.dart";
import "steam_interface_extensions.dart";
import "steam_struct_extensions.dart";
import "steam_typedef_extensions.dart";

/// Extensions on [SteamApi] to generate ffi code
extension SteamApiExtensions on SteamApi {
  /// This is entrypoint for code generation. Generates code according to the
  /// [SteamApi] definition by traversing all fields and emitting necessary code
  Future<void> generate(String path, String target) async {
    List<SteamStruct> missingStructs = [
      SteamStruct(name: "SteamDatagramRelayAuthTicket"),
      SteamStruct(
        name: "CallbackMsg_t",
        fields: [
          SteamField(
            name: "m_hSteamUser",
            type: "HSteamUser",
          ),
          SteamField(
            name: "m_iCallback",
            type: "int",
          ),
          SteamField(
            name: "m_pubParam",
            type: "uint8 *",
          ),
          SteamField(
            name: "m_cubParam",
            type: "int",
          ),
        ],
      ),
      SteamStruct(
        name: "AnalogAction_t",
        fields: [
          SteamField(
            name: "actionHandle",
            type: "InputAnalogActionHandle_t",
          ),
          SteamField(
            name: "analogActionData",
            type: "InputAnalogActionData_t",
          ),
        ],
      ),
    ];

    List<SteamInterface> missingInterfaces = [
      SteamInterface(name: "ISteamNetworkingConnectionSignaling"),
      SteamInterface(name: "ISteamNetworkingSignalingRecvContext"),
    ];

    // Set<String> typedefSet = typedefs.map((t) => t.typedef).toSet();

    Set<String> enumSet = enums.map((e) => e.name).toSet();
    enumSet.addAll(structs.expand((s) => s.enums.map((e) => e.name)));
    enumSet.addAll(callbackStructs.expand((cs) => cs.enums.map((e) => e.name)));
    enumSet.addAll(interfaces.expand((i) => i.enums.map((e) => e.name)));

    Set<String> structSet = structs.map((s) => s.name).toSet()
      ..addAll(missingStructs.map((s) => s.name));

    Set<String> callbackStructSet =
        callbackStructs.map((cs) => cs.name).toSet();

    Set<String> interfaceSet = interfaces.map((i) => i.name).toSet()
      ..addAll(missingInterfaces.map((i) => i.name));

    await generateSteamCommonApi(path);
    await consts.generate(path, FileMode.writeOnly);
    await typedefs.generate(path);
    await enums.generate(path);
    await missingStructs.generate(
      path,
      target,
      false,
      enumSet,
      structSet,
      callbackStructSet,
    );
    await structs.generate(
      path,
      target,
      false,
      // typedefSet,
      enumSet,
      structSet,
      callbackStructSet,
    );
    await callbackStructs.generate(
      path,
      target,
      true,
      // typedefSet,
      enumSet,
      structSet,
      callbackStructSet,
    );
    await missingInterfaces.generate(
      path,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );
    await interfaces.generate(
      path,
      enumSet,
      structSet,
      callbackStructSet,
      interfaceSet,
    );
  }

  /// Generates code for common steam apis
  Future<void> generateSteamCommonApi(String path) async {
    String filePath = p.join(path, "steam_api.dart");
    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    fileSink.writeImport("dart:ffi");
    fileSink.writeImport("dart:io");
    fileSink.writeImport("typedefs.dart");

    fileSink.writeln(
      "DynamicLibrary dl = DynamicLibrary.open(\"C:/Repos/aeb-dev/steamworks/bin/steam_api64.dll\");",
    );

    fileSink.writeln(
      "final _init = dl.lookupFunction<Bool Function(), bool Function()>(\"SteamAPI_Init\");",
    );
    fileSink.writeln("bool init() => _init.call();");

    fileSink.writeln(
      "final _shutdown = dl.lookupFunction<Void Function(), void Function()>(\"SteamAPI_Shutdown\");",
    );
    fileSink.writeln("void shutdown() => _shutdown.call();");

    fileSink.writeln(
      "final _getHSteamPipe = dl.lookupFunction<Int32 Function(), HSteamPipe Function()>(\"SteamAPI_GetHSteamPipe\");",
    );
    fileSink.writeln("HSteamPipe getHSteamPipe() => _getHSteamPipe.call();");

    fileSink.writeln(
      "final _restartAppIfNecessary = dl.lookupFunction<Bool Function(Int32), bool Function(int)>(\"SteamAPI_RestartAppIfNecessary\");",
    );
    fileSink.writeln(
      "bool restartAppIfNecessary(int appId) => _restartAppIfNecessary.call(appId);",
    );

    await fileSink.flush();
    await fileSink.close();
  }
}
