import 'package:dio/dio.dart';
import '../../services/api/api_services.dart';

class AuthRepository
{
    final ApiServices _apiServices = ApiServices();
    CancelToken? _cancelToken;


    Future<void> cancelChat() async {
        _cancelToken?.cancel();
    }
}
