import 'dart:convert';

String sendData(List<dynamic> messages) {
  // List<String> userMessages = List<String>.from(messages);
  // print(userMessages);

  String array_strings = jsonEncode(messages);
  return (array_strings);
}
