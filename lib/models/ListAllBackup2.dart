class ListAllBackup2 {
/*
{
  "backup_id": 1,
  "portal_id": 1,
  "status": 2,
  "message": "Backup failed: Connection issue!",
  "backup_time": "2022-04-15 10:50:10",
  "portal_name": "Moco",
  "portal_url": "http://13.238.226.225/use-case-to-improve-user-experience-using-screen-flows-in-salesforce/",
  "customer_name": "Ali Arif"
}
*/

  int? backupId;
  int? portalId;
  int? status;
  String? message;
  String? backupTime;
  String? portalName;
  String? portalUrl;
  String? customerName;

  ListAllBackup2({
    this.backupId,
    this.portalId,
    this.status,
    this.message,
    this.backupTime,
    this.portalName,
    this.portalUrl,
    this.customerName,
  });
  ListAllBackup2.fromJson(Map<dynamic, dynamic> json) {
    backupId = json['backup_id']?.toInt();
    portalId = json['portal_id']?.toInt();
    status = json['status']?.toInt();
    message = json['message']?.toString();
    backupTime = json['backup_time']?.toString();
    portalName = json['portal_name']?.toString();
    portalUrl = json['portal_url']?.toString();
    customerName = json['customer_name']?.toString();
  }
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['backup_id'] = backupId;
    data['portal_id'] = portalId;
    data['status'] = status;
    data['message'] = message;
    data['backup_time'] = backupTime;
    data['portal_name'] = portalName;
    data['portal_url'] = portalUrl;
    data['customer_name'] = customerName;
    return data;
  }
}