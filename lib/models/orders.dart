class OrdersMdl {
  bool done;
  List<Body> body;
  String message;

  OrdersMdl({this.done, this.body, this.message});

  OrdersMdl.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = List<Body>();
      json['body'].forEach((v) {
        body.add(Body.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['done'] = done;
    if (body != null) {
      data['body'] = body.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Body {
  var id;
  var orderNo;
  var contactName;
  var contactNo;
  var address;
  var comment;
  var accountId;
  var status;
  var date;
  var lastUpdated;
  var nic;
  var distance;
  var returnNote;
  var deliveryPersonId;
  var distanceValue;
  var canceledReason;
  var contactNoSecondary;
  var partnerId;
  var deliveryTime;
  var advancePaymentAmount;
  var convenienceFee;
  var travellingDistance;
  var serviceCharge;
  var longitude;
  var latitude;
  var orderStatus;
  List<Partners> partners;

  Body(
      {this.id,
      this.orderNo,
      this.contactName,
      this.contactNo,
      this.address,
      this.comment,
      this.accountId,
      this.status,
      this.date,
      this.lastUpdated,
      this.nic,
      this.distance,
      this.returnNote,
      this.deliveryPersonId,
      this.distanceValue,
      this.canceledReason,
      this.contactNoSecondary,
      this.partnerId,
      this.deliveryTime,
      this.advancePaymentAmount,
      this.convenienceFee,
      this.travellingDistance,
      this.serviceCharge,
      this.longitude,
      this.latitude,
      this.orderStatus,
      this.partners});

  Body.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    orderNo = json['order_no'];
    contactName = json['contact_name'];
    contactNo = json['contact_no'];
    address = json['address'];
    comment = json['comment'];
    accountId = json['account_id'];
    status = json['status'];
    date = json['date'];
    lastUpdated = json['last_updated'];
    nic = json['nic'];
    distance = json['distance'];
    returnNote = json['return_note'];
    deliveryPersonId = json['delivery_person_id'];
    distanceValue = json['distance_value'];
    canceledReason = json['canceled_reason'];
    contactNoSecondary = json['contact_no_secondary'];
    partnerId = json['partner_id'];
    deliveryTime = json['delivery_time'];
    advancePaymentAmount = json['advance_payment_amount'];
    convenienceFee = json['convenience_fee'];
    travellingDistance = json['travelling_distance'];
    serviceCharge = json['service_charge'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    orderStatus = json['order_status'];
    if (json['partners'] != null) {
      partners = List<Partners>();
      json['partners'].forEach((v) {
        partners.add(Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['order_no'] = orderNo;
    data['contact_name'] = contactName;
    data['contact_no'] = contactNo;
    data['address'] = address;
    data['comment'] = comment;
    data['account_id'] = accountId;
    data['status'] = status;
    data['date'] = date;
    data['last_updated'] = lastUpdated;
    data['nic'] = nic;
    data['distance'] = distance;
    data['return_note'] = returnNote;
    data['delivery_person_id'] = deliveryPersonId;
    data['distance_value'] = distanceValue;
    data['canceled_reason'] = canceledReason;
    data['contact_no_secondary'] = contactNoSecondary;
    data['partner_id'] = partnerId;
    data['delivery_time'] = deliveryTime;
    data['advance_payment_amount'] = advancePaymentAmount;
    data['convenience_fee'] = convenienceFee;
    data['travelling_distance'] = travellingDistance;
    data['service_charge'] = serviceCharge;
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['order_status'] = orderStatus;
    if (partners != null) {
      data['partners'] = partners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partners {
  String name;

  Partners({this.name});

  Partners.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    return data;
  }
}
