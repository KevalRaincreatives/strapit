///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class ShLoginModelData {
/*
{
  "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjZiYWIwZjAzYmI0YzlkZmYyN2U2MzdlOTgxMjQzZmZjNjI1MTBlNGIyZWFlZjI0OWQ4MjRjYzI2YTg5YTBjYTE5NjljODU1Njg5MWFhMWIiLCJpYXQiOjE2NDk3NTk1NjYuMjE3MzQ0LCJuYmYiOjE2NDk3NTk1NjYuMjE3MzUsImV4cCI6MTY4MTI5NTU2Ni4yMTIxMDksInN1YiI6IjEiLCJzY29wZXMiOltdfQ.TdooWaOXZNz_07xb76SwJ86us9RZsmo_QZ4V62GI5J_YsGL7m6zl4JzbWmWlAxweNJLswHgEIQkfHVsPdWPGkJajMJ-VCg51bfIhX3m-wC58_JAFi2tzqI4cZDIo4oAGMByVoqkLBtErmu3rfUIG86hsrhLMPlwpARLsIRg8zIo7lOF_PFDTflaWZ81Q982MN-Rsh_9mBMryMUHZROTeTlQyI7Qd8NckK8Zk0tIpGi5bFdlG9BTjSVJx048lEik9QpzR_eqmQ8y39fZMr4FVISHrP19jhsy0o69WfkXXZjASgpu4j7BRH2UiTwrjcHP_Sw5ORDwAoRpj5N3IQluJutdKZS67J_V2IjjtHiCmXsUDn2a6QJknaZUlCoo87jfcxweLcUND5n4SUypJNge4v6sCvDdtdIBNdvyHy82cbDwd30jJZCoEjv812fzAVS-8l2VSEwb08PPAkFXyrTvxFhGps0MH452j1H3IpeFAtJ58wMhALoFMQaee1gyn03vKZI4eqltyyEZ_8DiwINVdz7t2jm6Lg3oPqAH-H6KqljZGt1twvXFt8Ln80uCgDqh-7jqpIT_Ym0bm-6ode8uIZapP4DhDAq3IaNw6sd35Hm94XUiW54HhglmI4B8_08IlNShMPcmCNlzBei4g4dNJHrvtkI14zs-uzGmyZuqEs30",
  "name": "Admin",
  "email": "admin@rain.com",
  "phone": "9874566",
  "country": "UK",
  "is_admin": 1
}
*/

  String? token;
  String? name;
  String? email;
  String? phone;
  String? country;
  int? id;
  int? isAdmin;

  ShLoginModelData({
    this.token,
    this.name,
    this.email,
    this.phone,
    this.country,
    this.id,
    this.isAdmin,
  });
  ShLoginModelData.fromJson(Map<String, dynamic> json) {
    token = json['token']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    country = json['country']?.toString();
    id = json['id']?.toInt();
    isAdmin = json['is_admin']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['country'] = country;
    data['id'] = id;
    data['is_admin'] = isAdmin;
    return data;
  }
}

class ShLoginModel {
/*
{
  "success": true,
  "data": {
    "token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNjZiYWIwZjAzYmI0YzlkZmYyN2U2MzdlOTgxMjQzZmZjNjI1MTBlNGIyZWFlZjI0OWQ4MjRjYzI2YTg5YTBjYTE5NjljODU1Njg5MWFhMWIiLCJpYXQiOjE2NDk3NTk1NjYuMjE3MzQ0LCJuYmYiOjE2NDk3NTk1NjYuMjE3MzUsImV4cCI6MTY4MTI5NTU2Ni4yMTIxMDksInN1YiI6IjEiLCJzY29wZXMiOltdfQ.TdooWaOXZNz_07xb76SwJ86us9RZsmo_QZ4V62GI5J_YsGL7m6zl4JzbWmWlAxweNJLswHgEIQkfHVsPdWPGkJajMJ-VCg51bfIhX3m-wC58_JAFi2tzqI4cZDIo4oAGMByVoqkLBtErmu3rfUIG86hsrhLMPlwpARLsIRg8zIo7lOF_PFDTflaWZ81Q982MN-Rsh_9mBMryMUHZROTeTlQyI7Qd8NckK8Zk0tIpGi5bFdlG9BTjSVJx048lEik9QpzR_eqmQ8y39fZMr4FVISHrP19jhsy0o69WfkXXZjASgpu4j7BRH2UiTwrjcHP_Sw5ORDwAoRpj5N3IQluJutdKZS67J_V2IjjtHiCmXsUDn2a6QJknaZUlCoo87jfcxweLcUND5n4SUypJNge4v6sCvDdtdIBNdvyHy82cbDwd30jJZCoEjv812fzAVS-8l2VSEwb08PPAkFXyrTvxFhGps0MH452j1H3IpeFAtJ58wMhALoFMQaee1gyn03vKZI4eqltyyEZ_8DiwINVdz7t2jm6Lg3oPqAH-H6KqljZGt1twvXFt8Ln80uCgDqh-7jqpIT_Ym0bm-6ode8uIZapP4DhDAq3IaNw6sd35Hm94XUiW54HhglmI4B8_08IlNShMPcmCNlzBei4g4dNJHrvtkI14zs-uzGmyZuqEs30",
    "name": "Admin",
    "email": "admin@rain.com",
    "phone": "9874566",
    "country": "UK",
    "is_admin": 1
  },
  "message": "User login successfully."
}
*/

  bool? success;
  ShLoginModelData? data;
  String? message;

  ShLoginModel({
    this.success,
    this.data,
    this.message,
  });
  ShLoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] != null) ? ShLoginModelData.fromJson(json['data']) : null;
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}
