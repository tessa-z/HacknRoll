import 'package:flutter_dotenv/flutter_dotenv.dart';

class Secret {
  static String ANDROID_CLIENT_ID = DotEnv().env['ANDROID_CLIENT_ID'];

  static String getId() => Secret.ANDROID_CLIENT_ID;
}

String API_KEY = DotEnv().env['API_KEY'];
const BASE_URL = 'https://texttospeech.googleapis.com/v1/';
const VOICE_NAME = 'en-US-Wavenet-I';
const AUDIO_ENCODING = 'MP3';
const LANGUAGE_CODE = 'en-us';
//const SSML_GENDER = 'MALE';
const END_POINT = 'text:synthesize';
