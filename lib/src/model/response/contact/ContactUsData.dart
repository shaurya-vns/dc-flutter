class ContactUsData {
  ContactUsData({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.phoneNumber,
    this.subject,
    this.message,
    this.status,
    this.adminRemark,
    this.user,
  });

  ContactUsData.fromJson(dynamic json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    subject = json['subject'];
    message = json['message'];
    status = json['status'];
    adminRemark = json['adminRemark'];
    user = json['user'];
  }

  int? id;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? phoneNumber;
  String? subject;
  String? message;
  int? status;
  String? adminRemark;
  int? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    map['name'] = name;
    map['phoneNumber'] = phoneNumber;
    map['subject'] = subject;
    map['message'] = message;
    map['status'] = status;
    map['adminRemark'] = adminRemark;
    map['user'] = user;
    return map;
  }
}
