///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class UpdateProModelData {
/*
{
  "name": "Test2",
  "email": "test2@gmail.com",
  "phone": "7898654514",
  "country": "Algeria",
  "is_admin": 0
}
*/

  String? name;
  String? email;
  String? phone;
  String? country;
  int? isAdmin;

  UpdateProModelData({
    this.name,
    this.email,
    this.phone,
    this.country,
    this.isAdmin,
  });
  UpdateProModelData.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    email = json['email']?.toString();
    phone = json['phone']?.toString();
    country = json['country']?.toString();
    isAdmin = json['is_admin']?.toInt();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['country'] = country;
    data['is_admin'] = isAdmin;
    return data;
  }
}

class UpdateProModel {
/*
{
  "success": true,
  "data": {
    "name": "Test2",
    "email": "test2@gmail.com",
    "phone": "7898654514",
    "country": "Algeria",
    "is_admin": 0
  },
  "message": "Customer updated successfully."
}
*/

  bool? success;
  UpdateProModelData? data;
  String? message;

  UpdateProModel({
    this.success,
    this.data,
    this.message,
  });
  UpdateProModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = (json['data'] != null) ? UpdateProModelData.fromJson(json['data']) : null;
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
