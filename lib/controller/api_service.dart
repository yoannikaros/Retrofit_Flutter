import 'package:chopper/chopper.dart';
part 'api_service.chopper.dart';

final String baseUrlku = 'http://192.168.100.208:4000';

@ChopperApi()
abstract class ApiService extends ChopperService {
  @Post(path: '/auth/login')
  Future<Response<dynamic>> login(@Body() Map<String, dynamic> body);

  @Get(path: '/users/{id}')
  Future<Response<dynamic>> getDataById(
      @Path('id') int id, @Header('Authorization') String token);

  @Post(path: '/users')
  Future<Response<dynamic>> addUser(
      @Header('Authorization') String token, @Body() Map<String, dynamic> body);

  static ApiService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse(baseUrlku), // Ganti dengan URL API yang valid
      services: [_$ApiService()],
      converter: JsonConverter(),
    );

    return _$ApiService(client);
  }
}
