import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants
{
    static String baseUrl = dotenv.env['BASE_URL']!;

    // ------------------ AI-Chat Endpoints ------------------

    static const String demo = "/demo"; // POST

    // Headers
    static const String contentType = 'application/json';
    static const String authorization = 'Authorization';
    static const String acceptLanguage = 'Accept-Language';

    //Timeouts
    static const int connectTimerOutsMs = 15000;
    static const int receiveTimerOutsMs = 15000;
    static const int sendTimerOutsMs = 15000;
}

