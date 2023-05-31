///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ResponseError {
/*
{
  "code": 300606,
  "message": "Oh! User with the similar email-id already exist. Try giving a different email-id."
} 
*/

  int? code;
  String? message;

  ResponseError({
    this.code,
    this.message,
  });
  ResponseError.fromJson(Map<String, dynamic> json) {
    code = json['code']?.toInt();
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['code'] = code;
    data['message'] = message;
    return data;
  }
}