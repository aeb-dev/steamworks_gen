# steamworks_gen
A package that generates steam_api binding from steam_api.json. Check the resulting library [here](https://github.com/aeb-dev/steamworks)

# Usage
- Add `steamworks_gen` to your `pubspec.yaml`: `dart pub add -d steamworks_gen`
- Add `package:ffi` to your `pubspec.yaml`: `dart pub add ffi`
- Run the tool: `dart run steamworks_gen <parameters>`