import 'dart:io';
import 'dart:convert';
import '../secrets.dart';
import '../models/audio_content.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

Future<String> textToSpeech(String text, String audioFileName) async {
  String filepath;
  //if user fails to add arguments to commandline output error message
  if (text == null || text == '') {
    print(
        'error: arguments missing ( -t "say something" -f "filename")');
  } else {
    try {
      //query google voice api and get response which is base 64 encoded.
      final apiResult =
          await _getAudioBase64Output(text: text, file: audioFileName);
      print('');
      print('---------------------------------------');
      print('Output saved to: $audioFileName.wav');
      print('---------------------------------------');
      //decode base64 file and save as binary audio file (mp3)
      var bytes = base64.decode(apiResult.audioContent);
      filepath = await getFilePath(audioFileName);
      final file = File(filepath);
      await file.writeAsBytes(bytes);
      // await file.writeAsBytes(bytes.buffer.asUint8List());
    } catch (e) {
      //output error
      print('error: networking error');
      print(e.toString());
    }
  }
  return filepath;
}

Future<AudioOutputBase64Encoded> _getAudioBase64Output(
    {@required String text, String file = 'output'}) async {
  //create api URL from global constants
  var _apiURL = '$BASE_URL$END_POINT?key=$API_KEY';
  //create json body from global constants and input variables
  var body =
      '{"input": {"text":"$text"},"voice": {"languageCode": "$LANGUAGE_CODE", "name": "$VOICE_NAME"},"audioConfig": {"audioEncoding": "$AUDIO_ENCODING"}}';

  //send post request to google text to speech api
  Future request = http.post(_apiURL, body: body);
  //get response
  var response = await _getResponse(request);
  //return our mapped response from our AudioOutputBase64Encoded model
  return AudioOutputBase64Encoded.fromJson(response);
}

Future _getResponse(Future<http.Response> request) {
  //return our response if good (200 code) or throw error if failed
  return request.then((response) {
    //print(response.statusCode);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw (jsonDecode(response.body));
  });
}

Future<String> getFilePath(String filename) async {
    // Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    // String appDocumentsPath = appDocumentsDirectory.path; // 2
    // String filePath = '$appDocumentsPath/assets/$filename.mp3'; // 3
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/audio.mp3';
    return filePath;
  }