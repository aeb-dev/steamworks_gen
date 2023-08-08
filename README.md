<p>
  <a title="Pub" href="https://pub.dev/packages/steamworks_gen" ><img src="https://img.shields.io/pub/v/steamworks_gen.svg?style=popout" /></a>
</p>

# steamworks_gen
A package that generates steam_api binding from steam_api.json. Check the resulting library [here](https://github.com/aeb-dev/steamworks)

# Usage
- Add `steamworks_gen` to your `pubspec.yaml`: `dart pub add -d steamworks_gen`
- Add `package:ffi` to your `pubspec.yaml`: `dart pub add ffi`
- Run the tool: `dart run steamworks_gen <parameters>`

Example:
`dart run steamworks_gen -o generated steam_api.json`
