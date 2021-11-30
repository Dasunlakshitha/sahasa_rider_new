class Users {
  bool done;
  Body body;
  String message;

  Users({this.done, this.body, this.message});

  Users.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = Body.fromJson(json['body']);
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  User user;

  Body({this.user});

  Body.fromJson(Map<String, dynamic> json) {
    if (json['user'] != null) {
      user = User.fromJson(json['user']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user.toJson();
    }
    return data;
  }
}

class User {
  var id;
  var username;
  var isAvailable;
  var nic;
  var name;
  var contactNo;
  var vehicleNumber;
  var accountId;
  var vehicleType;

  User({
    this.id,
    this.username,
    this.isAvailable,
    this.nic,
    this.name,
    this.contactNo,
    this.vehicleNumber,
    this.accountId,
    this.vehicleType,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    isAvailable = json['is_available'];
    nic = json['nic'];
    name = json['name'];
    contactNo = json['contact_no'];
    vehicleNumber = json['vehicle_number'];
    accountId = json['account_id'];
    vehicleType = json['vehicle_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['is_available'] = isAvailable;
    data['nic'] = nic;
    data['name'] = name;
    data['contact_no'] = contactNo;
    data['vehicle_number'] = vehicleNumber;
    data['account_id'] = accountId;
    data['vehicle_type'] = vehicleType;
    return data;
  }
}
