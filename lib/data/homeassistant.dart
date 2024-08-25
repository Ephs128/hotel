import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class Homeassistant {
  final _hostUrl = "http://192.168.100.90:8123";
  final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJiOWM0MWM4OTEwNTM0Y2YzOTkwZDhkZjUyYzhlNjRmMCIsImlhdCI6MTcyNDI4ODQ2NSwiZXhwIjoyMDM5NjQ4NDY1fQ.1s84ZYxd1ovWtPm8ZYbI88vbsHKil8o1-r58f580IWM";

  Future<void> turnOnSwitch(String deviceId) async {
    log("calling homeassistant api");
    var client = http.Client();
    var uri = Uri.parse('$_hostUrl/api/services/switch/turn_on');
    var response = await client.post(
      uri, 
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': "Bearer $token",
      },
      body: jsonEncode({
        "entity_id": deviceId,
      }),
    );
    if (response.statusCode == 200) {
      log("enviado correctamente al servidor");
    } else {
      log("error: ${response.body}");
    }
  }
}