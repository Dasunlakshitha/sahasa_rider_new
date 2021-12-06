// ignore_for_file: prefer_typing_uninitialized_variables

class NewOrders {
  bool done;
  List<Body> body;
  String message;

  NewOrders({done, body, message});

  NewOrders.fromJson(Map<String, dynamic> json) {
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
  var orderNo;
  var deliveryTime;
  var orderType;
  var address;
  var id;
  var contactName;
  var lastUpdated;
  List<Partners> partners;

  Body(
      {this.orderNo,
      this.deliveryTime,
      this.orderType,
      this.address,
      this.id,
      this.contactName,
      this.lastUpdated,
      this.partners});

  Body.fromJson(Map<String, dynamic> json) {
    orderNo = json['order_no'];
    deliveryTime = json['delivery_time'];
    orderType = json['order_type'];
    address = json['address'];
    id = json['id'];
    contactName = json['contact_name'];
    lastUpdated = json['last_updated'];
    if (json['partners'] != null) {
      partners = List<Partners>();
      json['partners'].forEach((v) {
        partners.add(Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_no'] = orderNo;
    data['delivery_time'] = deliveryTime;
    data['order_type'] = orderType;
    data['address'] = address;
    data['id'] = id;
    data['contact_name'] = contactName;
    data['last_updated'] = lastUpdated;
    if (partners != null) {
      data['partners'] = partners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partners {
  var name;

  Partners({name});

  Partners.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = name;
    return data;
  }
}
