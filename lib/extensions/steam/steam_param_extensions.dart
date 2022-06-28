import "dart:io";

import "package:recase/recase.dart";

import "../../steam/steam_param.dart";
import "../file_extensions.dart";
import "../string_extensions.dart";
import "../token.dart";

/// Extensions on [SteamParam] to generate ffi code
extension SteamFieldExtensions on SteamParam {
  /// Generates necessary imports for a [SteamParam]
  void generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    String importPath =
        type.clearClassAccess().clearPointerOrConst().trim().importPath(
              enumSet: enumSet,
              structSet: structSet,
              callbackStructSet: callbackStructSet,
              interfaceSet: interfaceSet,
            );

    if (importPath.isNotEmpty) {
      fileSink.writeImport(packageName: importPath);
    }
  }

  /// Generates necessary code for a [SteamParam]
  void generate({
    required IOSink fileSink,
    bool withDart = false,
    bool withFunctionDart = false,
    bool withFunctionC = false,
    bool withName = false,
    bool withCaller = false,
  }) {
    Token token = type.toToken();

    if (withDart) {
      fileSink.write(token.typeDart);
    }

    if (withFunctionDart) {
      fileSink.write(token.typeFfiDart);
    }

    if (withFunctionC) {
      fileSink.write(token.typeFfiC);
    }

    if (withName) {
      fileSink.write(" ${name.clearSteamNaming().camelCase}");
    }

    if (withCaller) {
      fileSink.write(
        " ${token.caller.replaceAll("{0}", name.clearSteamNaming().camelCase)}",
      );
    }

    fileSink.write(",");
  }

  /// Generates necessary code for a [SteamParam] as [String]
  String generateString({
    bool withDart = false,
    bool withFunctionDart = false,
    bool withFunctionC = false,
    bool withName = false,
    bool withCaller = false,
  }) {
    Token token = type.toToken();
    StringBuffer sb = StringBuffer();
    if (withDart) {
      sb.write(token.typeDart);
    }

    if (withFunctionDart) {
      sb.write(token.typeFfiDart);
    }

    if (withFunctionC) {
      sb.write(token.typeFfiC);
    }

    if (withName) {
      sb.write(" ${name.clearSteamNaming().camelCase}");
    }

    if (withCaller) {
      sb.write(
        " ${token.caller.replaceAll("{0}", name.clearSteamNaming().camelCase)}",
      );
    }

    sb.write(",");

    return sb.toString();
  }
}

/// Extensions on [Iterable<SteamParam>] to generate ffi code
extension SteamParamIterableExtensions on Iterable<SteamParam> {
  /// Generates respective imports for each [SteamParam]
  void generateImport({
    required IOSink fileSink,
    Set<String> enumSet = const {},
    Set<String> structSet = const {},
    Set<String> callbackStructSet = const {},
    Set<String> interfaceSet = const {},
  }) {
    for (SteamParam param in this) {
      param.generateImport(
        fileSink: fileSink,
        enumSet: enumSet,
        structSet: structSet,
        callbackStructSet: callbackStructSet,
        interfaceSet: interfaceSet,
      );
    }
  }

  /// Generates respective code for each [SteamParam]
  void generate({
    required IOSink fileSink,
    bool withDart = false,
    bool withFunctionDart = false,
    bool withFunctionC = false,
    bool withName = false,
    bool withCaller = false,
  }) {
    for (SteamParam param in this) {
      param.generate(
        fileSink: fileSink,
        withDart: withDart,
        withFunctionDart: withFunctionDart,
        withFunctionC: withFunctionC,
        withName: withName,
        withCaller: withCaller,
      );
    }
  }

  /// Generates respective code for each [SteamParam] as String
  String generateString({
    bool withDart = false,
    bool withFunctionDart = false,
    bool withFunctionC = false,
    bool withName = false,
    bool withCaller = false,
  }) =>
      this
          .map(
            (p) => p.generateString(
              withDart: withDart,
              withFunctionDart: withFunctionDart,
              withFunctionC: withFunctionC,
              withName: withName,
              withCaller: withCaller,
            ),
          )
          .join();
}
