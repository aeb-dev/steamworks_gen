import "dart:io";

import "package:args/args.dart";
import "package:cli_util/cli_logging.dart";
import "package:steamworks_gen/steamworks_gen.dart" as steamworks_gen;

Logger logger = Logger.standard();

void printUsage(ArgParser parser) {
  logger.stdout("Usage: steamworks_gen [arguments] <steam_api.json path>");
  logger.stdout(parser.usage);
}

void printError(String message, ArgParser parser) {
  logger.stderr(message);
  printUsage(parser);
}

Future<void> main(List<String> arguments) async {
  ArgParser parser = ArgParser()
    ..addOption(
      "output",
      abbr: "o",
      help: "Output folder path",
    )
    ..addOption(
      "target",
      abbr: "t",
      help: "Target platform",
      allowed: [
        "win",
        "linux",
        "mac",
        "arm",
      ],
      defaultsTo: "win",
    )
    ..addFlag(
      "help",
      abbr: "h",
      help: "Print usage information",
      negatable: false,
    );

  ArgResults argResults;
  try {
    argResults = parser.parse(arguments);

    if (argResults.wasParsed("help")) {
      logger.stdout("Generates steamworks in darty way\n");
      printUsage(parser);
      exit(0);
    }

    if (!argResults.wasParsed("output")) {
      throw Exception("Please provide output -o option\n");
    }

    if (argResults.rest.length != 1) {
      throw Exception("Missing argument: steam api json path\n");
    }
  } on String catch (e) {
    printError(e, parser);
    exit(1);
  } on Exception catch (e) {
    printError("$e", parser);
    exit(1);
  }

  String output = argResults["output"];
  String target = argResults["target"];

  await steamworks_gen.generate(argResults.rest.first, output, target);

  // double format call required because of 'require_trailing_commas'
  await Process.run("dart", ["pub", "remove", "ffi"]);
  await Process.run("dart", ["pub", "add", "ffi"]);
  await Process.run("dart", ["pub", "get"]);
  await Process.run("dart", ["format", "."], workingDirectory: output);
  await Process.run("dart", ["fix", "--apply"], workingDirectory: output);
  await Process.run("dart", ["format", "."], workingDirectory: output);
}
