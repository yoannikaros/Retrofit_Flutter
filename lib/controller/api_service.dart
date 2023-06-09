import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: "http://192.168.100.111:4000/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @POST("auth/login")
  @FormUrlEncoded()
  Future<LoginResponse> login(
    @Field("username") String username,
    @Field("password") String password,
  );
}

@JsonSerializable()
class LoginResponse {
  String message;
  int userId;
  String token;

  LoginResponse({
    required this.message,
    required this.userId,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
