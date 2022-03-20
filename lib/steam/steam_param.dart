/// Parameter definition for steam api
class SteamParam {
  /// name of the parameter
  late String name;

  /// c type of the parameter
  late String type;

  /// flat type of the parameter
  late String typeFlat;

  // late String outStruct;
  // late String outArrayCall;
  // late String arrayCount;
  // late String outStringCount;
  // late String outString;
  // late String desc;
  // late String outArrayCount;
  // late String outBufferCount;
  // late String bufferCount;

  /// Creates a [SteamParam]. This constructor is used
  /// for manual [SteamParam] creation
  SteamParam({
    required this.name,
    required this.type,
    this.typeFlat = "",
  });

  /// Creates a [SteamParam] from json
  SteamParam.fromJson(Map<String, dynamic> json) {
    name = json["paramname"];
    type = json["paramtype"];
    typeFlat = json["paramtype_flat"] ?? "";
    // outStruct = json["out_struct"] ?? "";
    // outArrayCall = json["out_array_call"] ?? "";
    // arrayCount = json["array_count"] ?? "";
    // outStringCount = json["out_string_count"] ?? "";
    // outString = json["out_string"] ?? "";
    // desc = json["desc"] ?? "";
    // outArrayCount = json["out_array_count"] ?? "";
    // outBufferCount = json["out_buffer_count"] ?? "";
    // bufferCount = json["buffer_count"] ?? "";
  }
}
