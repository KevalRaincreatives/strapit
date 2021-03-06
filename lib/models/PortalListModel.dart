///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class PortalListModelData {
/*
{
  "id": 1,
  "name": "Moco",
  "url": "http://13.238.226.225/use-case-to-improve-user-experience-using-screen-flows-in-salesforce/",
  "username": "admin@rain.com",
  "password": "123456",
  "port": "22",
  "key": null,
  "root_folder": "/root",
  "created_at": "2022-04-12T07:36:00.000000Z",
  "updated_at": "2022-04-12T07:46:52.000000Z",
  "user_id": 2,
  "plan_start_date": null,
  "plan_end_date": null,
  "host": "",
  "mysql_host": "",
  "mysql_username": "",
  "mysql_password": "",
  "mysql_database": "",
  "mysql_port": "",
  "customer_name": "Ali Arif"
}
*/

  int? id;
  String? name;
  String? url;
  String? username;
  String? password;
  String? port;
  String? key;
  String? rootFolder;
  String? createdAt;
  String? updatedAt;
  int? userId;
  String? planStartDate;
  String? planEndDate;
  String? host;
  String? mysqlHost;
  String? mysqlUsername;
  String? mysqlPassword;
  String? mysqlDatabase;
  String? mysqlPort;
  String? portal_type;
  String? customerName;

  PortalListModelData({
    this.id,
    this.name,
    this.url,
    this.username,
    this.password,
    this.port,
    this.key,
    this.rootFolder,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.planStartDate,
    this.planEndDate,
    this.host,
    this.mysqlHost,
    this.mysqlUsername,
    this.mysqlPassword,
    this.mysqlDatabase,
    this.mysqlPort,
    this.portal_type,
    this.customerName,
  });
  PortalListModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    name = json['name']?.toString();
    url = json['url']?.toString();
    username = json['username']?.toString();
    password = json['password']?.toString();
    port = json['port']?.toString();
    key = json['key']?.toString();
    rootFolder = json['root_folder']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    userId = json['user_id']?.toInt();
    planStartDate = json['plan_start_date']?.toString();
    planEndDate = json['plan_end_date']?.toString();
    host = json['host']?.toString();
    mysqlHost = json['mysql_host']?.toString();
    mysqlUsername = json['mysql_username']?.toString();
    mysqlPassword = json['mysql_password']?.toString();
    mysqlDatabase = json['mysql_database']?.toString();
    mysqlPort = json['mysql_port']?.toString();
    portal_type= json['portal_type']?.toString();
    customerName = json['customer_name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['url'] = url;
    data['username'] = username;
    data['password'] = password;
    data['port'] = port;
    data['key'] = key;
    data['root_folder'] = rootFolder;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['user_id'] = userId;
    data['plan_start_date'] = planStartDate;
    data['plan_end_date'] = planEndDate;
    data['host'] = host;
    data['mysql_host'] = mysqlHost;
    data['mysql_username'] = mysqlUsername;
    data['mysql_password'] = mysqlPassword;
    data['mysql_database'] = mysqlDatabase;
    data['mysql_port'] = mysqlPort;
    data['portal_type']=portal_type;
    data['customer_name'] = customerName;
    return data;
  }
}

class PortalListModel {
/*
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Moco",
      "url": "http://13.238.226.225/use-case-to-improve-user-experience-using-screen-flows-in-salesforce/",
      "username": "admin@rain.com",
      "password": "123456",
      "port": "22",
      "key": null,
      "root_folder": "/root",
      "created_at": "2022-04-12T07:36:00.000000Z",
      "updated_at": "2022-04-12T07:46:52.000000Z",
      "user_id": 2,
      "plan_start_date": null,
      "plan_end_date": null,
      "host": "",
      "mysql_host": "",
      "mysql_username": "",
      "mysql_password": "",
      "mysql_database": "",
      "mysql_port": "",
      "customer_name": "Ali Arif"
    }
  ],
  "message": ""
}
*/

  bool? success;
  List<PortalListModelData?>? data;
  String? message;

  PortalListModel({
    this.success,
    this.data,
    this.message,
  });
  PortalListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <PortalListModelData>[];
      v.forEach((v) {
        arr0.add(PortalListModelData.fromJson(v));
      });
      this.data = arr0;
    }
    message = json['message']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success'] = success;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['data'] = arr0;
    }
    data['message'] = message;
    return data;
  }
}
