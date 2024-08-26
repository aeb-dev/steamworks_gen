import "dart:io";

import "package:path/path.dart" as p;
import "package:recase/recase.dart";

import "../../steam/steam_api.dart";
import "../../steam/steam_field.dart";
import "../../steam/steam_initalizer.dart";
import "../../steam/steam_interface.dart";
import "../../steam/steam_method.dart";
import "../../steam/steam_param.dart";
import "../../steam/steam_struct.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "steam_const_extensions.dart";
import "steam_enum_extensions.dart";
import "steam_initializer_extensions.dart";
import "steam_interface_extensions.dart";
import "steam_struct_extensions.dart";
import "steam_typedef_extensions.dart";

/// Extensions on [SteamApi] to generate ffi code
extension SteamApiExtensions on SteamApi {
  /// This is entrypoint for code generation. Generates code according to the
  /// [SteamApi] definition by traversing all fields and emitting necessary code
  Future<void> generate({
    required String path,
    required String target,
  }) async {
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

    String exportFilePath = p.join(path, "generated.dart");
    File file = File(exportFilePath);
    await file.create(recursive: true);

    IOSink exportSink = file.openWrite(mode: FileMode.writeOnly);

    await generateCallbackIdMap(
      path: path,
      exportSink: exportSink,
      callbackStructSet: callbackStructSet,
    );

    await generateDl(
      path: path,
    );
    await generateSteamApi(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await generateSteamGameServer(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await generateDispatch(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await generateUnknownEnumValueException(
      path: path,
      exportSink: exportSink,
    );
    await consts.generateFile(
      path: path,
      exportSink: exportSink,
    );
    await typedefs.generateFile(
      path: path,
      exportSink: exportSink,
    );
    await enums.generateFile(
      path: path,
      exportSink: exportSink,
    );
    await missingStructs.generateFile(
      path: path,
      exportSink: exportSink,
      target: target,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await structs.generateFile(
      path: path,
      exportSink: exportSink,
      target: target,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
    await callbackStructs.generateFile(
      path: path,
      exportSink: exportSink,
      target: target,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );

    await missingInterfaces.generateFile(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );
    await interfaces.generateFile(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
      interfaceSet: interfaceSet,
    );

    await exportSink.flush();
    await exportSink.close();
  }

  /// Generates code for accessing the library file
  Future<void> generateDl({
    required String path,
  }) async {
    String filePath = p.join(path, "dl.dart");
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
      packageName: "dart:io",
    );

    fileSink.writeln(
      'DynamicLibrary dl = Platform.isWindows ? DynamicLibrary.open("steam_api64.dll") : Platform.isLinux ? DynamicLibrary.open("libsteam_api.so") : DynamicLibrary.open("libsteam_api.dylib");\n',
    );

    await fileSink.flush();
    await fileSink.close();
  }

  /// Generates callback id map by type to make
  /// it easier to lookup callback ids
  Future<void> generateCallbackIdMap({
    required String path,
    required IOSink exportSink,
    Set<String> callbackStructSet = const {},
  }) async {
    String filePath = p.join(path, "callback_id_map.dart");
    exportSink.writeExport(
      path: "callback_id_map.dart",
    );

    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);
    fileSink.writeln(
      "// ignore_for_file: public_member_api_docs, always_specify_types, avoid_positional_boolean_parameters, avoid_classes_with_only_static_members",
    );

    for (String name in callbackStructs.map((cs) => cs.name)) {
      String importPath = name.importPath(
        relativeness: "",
        callbackStructSet: callbackStructSet,
      );

      if (importPath.isNotEmpty) {
        fileSink.writeImport(packageName: importPath);
      }
    }

    fileSink.write(
      "Map<Type, int> callbackIdMapByType =",
    );

    fileSink.writeStartBlock();

    for (String name in callbackStructs.map((cs) => cs.name)) {
      String typeName = name.clearSteamNaming().pascalCase;
      fileSink.write("$typeName: $typeName.callbackId,");
    }

    fileSink.writeEndBlock();

    fileSink.write(";");

    await fileSink.flush();
    await fileSink.close();
  }

  /// Generates code for common steam apis
  Future<void> generateSteamApi({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    SteamInitializer steamApi = SteamInitializer(
      name: "SteamApi",
      methods: [
        SteamMethod(
          name: "Init",
          nameFlat: "SteamAPI_InitFlat",
          returnType: "ESteamAPIInitResult",
          params: [
            SteamParam(
              name: "outErrorMessage",
              type: "SteamErrMsg *",
            ),
          ],
        ),
        SteamMethod(
          name: "ReleaseCurrentThreadMemory",
          nameFlat: "SteamAPI_ReleaseCurrentThreadMemory",
          returnType: "void",
        ),
        SteamMethod(
          name: "RestartAppIfNecessary",
          nameFlat: "SteamAPI_RestartAppIfNecessary",
          returnType: "bool",
          params: [
            SteamParam(
              name: "unOwnAppID",
              type: "uint32",
            ),
          ],
        ),
        // SteamMethod(
        //   name: "RunCallbacks",
        //   nameFlat: "SteamAPI_RunCallbacks",
        //   returnType: "void",
        // ),
        SteamMethod(
          name: "Shutdown",
          nameFlat: "SteamAPI_Shutdown",
          returnType: "void",
        ),
        SteamMethod(
          name: "GetHSteamPipe",
          nameFlat: "SteamAPI_GetHSteamPipe",
          returnType: "HSteamPipe",
        ),
        SteamMethod(
          name: "GetHSteamUser",
          nameFlat: "SteamAPI_GetHSteamUser",
          returnType: "HSteamUser",
        ),
      ],
    );

    await steamApi.generateFile(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
  }

  /// Generates code for steam game server
  Future<void> generateSteamGameServer({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    SteamInitializer gameServer = SteamInitializer(
      name: "SteamGameServer",
      methods: [
        SteamMethod(
          name: "Init",
          nameFlat: "SteamGameServer_Init",
          returnType: "bool",
          params: [
            SteamParam(
              name: "unIP",
              type: "uint32",
            ),
            SteamParam(
              name: "usSteamPort",
              type: "uint16",
            ),
            SteamParam(
              name: "usGamePort",
              type: "uint16",
            ),
            SteamParam(
              name: "usQueryPort",
              type: "uint16",
            ),
            SteamParam(
              name: "eServerMode",
              type: "EServerMode",
            ),
            SteamParam(
              name: "pchVersionString",
              type: "const char *",
            ),
          ],
        ),
        SteamMethod(
          name: "ReleaseCurrentThreadMemory",
          nameFlat: "SteamGameServer_ReleaseCurrentThreadMemory",
          returnType: "void",
        ),
        // SteamMethod(
        //   name: "RunCallbacks",
        //   nameFlat: "SteamGameServer_RunCallbacks",
        //   returnType: "void",
        // ),
        SteamMethod(
          name: "Shutdown",
          nameFlat: "SteamGameServer_Shutdown",
          returnType: "void",
        ),
        SteamMethod(
          name: "GetHSteamPipe",
          nameFlat: "SteamGameServer_GetHSteamPipe",
          returnType: "HSteamPipe",
        ),
        SteamMethod(
          name: "GetHSteamUser",
          nameFlat: "SteamGameServer_GetHSteamUser",
          returnType: "HSteamUser",
        ),
      ],
    );

    await gameServer.generateFile(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
  }

  /// Generates code for dispatch
  Future<void> generateDispatch({
    required String path,
    required IOSink exportSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
  }) async {
    SteamInitializer dispatch = SteamInitializer(
      name: "Dispatch",
      methods: [
        SteamMethod(
          name: "Init",
          nameFlat: "SteamAPI_ManualDispatch_Init",
          returnType: "void",
        ),
        SteamMethod(
          name: "RunFrame",
          nameFlat: "SteamAPI_ManualDispatch_RunFrame",
          returnType: "void",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
          ],
        ),
        SteamMethod(
          name: "GetNextCallback",
          nameFlat: "SteamAPI_ManualDispatch_GetNextCallback",
          returnType: "bool",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
            SteamParam(
              name: "pCallbackMsg",
              type: "CallbackMsg_t *",
            ),
          ],
        ),
        SteamMethod(
          name: "FreeLastCallback",
          nameFlat: "SteamAPI_ManualDispatch_FreeLastCallback",
          returnType: "void",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
          ],
        ),
        SteamMethod(
          name: "GetAPICallResult",
          nameFlat: "SteamAPI_ManualDispatch_GetAPICallResult",
          returnType: "bool",
          params: [
            SteamParam(
              name: "hSteamPipe",
              type: "HSteamPipe",
            ),
            SteamParam(
              name: "hSteamAPICall",
              type: "SteamAPICall_t",
            ),
            SteamParam(
              name: "pCallback",
              type: "void *",
            ),
            SteamParam(
              name: "cubCallback",
              type: "int",
            ),
            SteamParam(
              name: "iCallbackExpected",
              type: "int",
            ),
            SteamParam(
              name: "pbFailed",
              type: "bool *",
            ),
          ],
        ),
      ],
    );

    await dispatch.generateFile(
      path: path,
      exportSink: exportSink,
      enumSet: enumSet,
      structSet: structSet,
      callbackStructSet: callbackStructSet,
    );
  }

  /// Generates exception for enums
  Future<void> generateUnknownEnumValueException({
    required String path,
    required IOSink exportSink,
  }) async {
    String filePath = p.join(path, "unknown_enum_value_exception.dart");
    exportSink.writeExport(
      path: "unknown_enum_value_exception.dart",
    );

    File file = File(filePath);
    await file.create(recursive: true);

    IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

    fileSink.writeln(
      "// ignore_for_file: public_member_api_docs",
    );

    fileSink.write("""
        class UnknownEnumValueException implements Exception {
          final String message;

          const UnknownEnumValueException(this.message);
        }
      """);

    await fileSink.flush();
    await fileSink.close();
  }

  /// Generates utility functions for ffi
  // Future<void> generateUtility({
  //   required String path,
  //   required IOSink exportSink,
  // }) async {
  //   String filePath = p.join(path, "utils.dart");
  //   exportSink.writeExport(
  //     path: "utils.dart",
  //   );

  //   File file = File(filePath);
  //   await file.create(recursive: true);

  //   IOSink fileSink = file.openWrite(mode: FileMode.writeOnly);

  //   fileSink.writeImport(
  //     packageName: "dart:ffi",
  //   );
  //   fileSink.writeImport(
  //     packageName: "package:ffi/ffi.dart",
  //   );

  //   fileSink.write(
  //     """extension PointerToStringList on Pointer<Pointer<Utf8>> {
  //     List<String> toDartStringList({
  //         required int length,
  //       }) =>
  //           Iterable<int>.generate(length)
  //               .map((index) => this[index].toDartString())
  //               .toList();
  //     }

  //     extension StringListToPointer on Iterable<String> {
  //       Pointer<Pointer<Utf8>> toNativeUtf8List() {
  //         List<Pointer<Utf8>> utf8PointerList =
  //             this.map((str) => str.toNativeUtf8()).toList();

  //         Pointer<Pointer<Utf8>> pointerPointer =
  //             malloc.allocate(sizeOf<Pointer<Utf8>>() * utf8PointerList.length);

  //         int index = 0;
  //         for (String _ in this) {
  //           pointerPointer[index] = utf8PointerList[index];
  //           index += 1;
  //         }

  //         return pointerPointer;
  //       }
  //     }
  //     """,
  //   );

  //   await fileSink.flush();
  //   await fileSink.close();
  // }
}
