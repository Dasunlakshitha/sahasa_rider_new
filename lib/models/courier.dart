  class Courier {
  bool done;
  Body body;
  String message;

    Courier({this.done, this.body, this.message});

  Courier.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ?  Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['done'] = done;
    if (body != null) {
      data['body'] = body.toJson();
    }
    data['message'] = message;
    return data;
  }
  }

class Body {
  var id;
  var accountId;
  var partnerId;
  var courierNo;
  var status;
  var address;
  var contactNo;
  var description;
  var instructions;
  var note;
  var dateCreated;
  var lastUpdated;
  var distanceValue;
  var deliveryPersonId;
  var orderStatus;
  List<Partner> partner;

  Body(
      {this.id,
      this.accountId,
      this.partnerId,
      this.courierNo,
      this.status,
      this.address,
      this.contactNo,
      this.description,
      this.instructions,
      this.note,
      this.dateCreated,
      this.lastUpdated,
      this.distanceValue,
      this.deliveryPersonId,
      this.orderStatus,
      this.partner});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountId = json['account_id'];
    partnerId = json['partner_id'];
    courierNo = json['courier_no'];
    status = json['status'];
    address = json['address'];
    contactNo = json['contact_no'];
    description = json['description'];
    instructions = json['instructions'];
    note = json['note'];
    dateCreated = json['date_created'];
    lastUpdated = json['last_updated'];
    distanceValue = json['distance_value'];
    deliveryPersonId = json['delivery_person_id'];
    orderStatus = json['order_status'];
    if (json['partner'] != null) {
      partner = new List<Partner>();
      json['partner'].forEach((v) {
        partner.add(new Partner.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account_id'] = this.accountId;
    data['partner_id'] = this.partnerId;
    data['courier_no'] = this.courierNo;
    data['status'] = this.status;
    data['address'] = this.address;
    data['contact_no'] = this.contactNo;
    data['description'] = this.description;
    data['instructions'] = this.instructions;
    data['note'] = this.note;
    data['date_created'] = this.dateCreated;
    data['last_updated'] = this.lastUpdated;
    data['distance_value'] = this.distanceValue;
    data['delivery_person_id'] = this.deliveryPersonId;
    data['order_status'] = this.orderStatus;
    if (this.partner != null) {
      data['partner'] = this.partner.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partner {
  var name;
  var contactNo;
  var partnerLat;
  var partnerLong;

  Partner({this.name, this.contactNo, this.partnerLat, this.partnerLong});

  Partner.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNo = json['contact_no'];
    partnerLat = json['partner_lat'];
    partnerLong = json['partner_long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_no'] = this.contactNo;
    data['partner_lat'] = this.partnerLat;
    data['partner_long'] = this.partnerLong;
    return data;
  }
}