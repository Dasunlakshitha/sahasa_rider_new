class ConfirmOrders {
  bool done;
  List<Body> body;
  String message;

  ConfirmOrders({this.done, this.body, this.message});

  ConfirmOrders.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    if (json['body'] != null) {
      body = new List<Body>();
      json['body'].forEach((v) {
        body.add(new Body.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    if (this.body != null) {
      data['body'] = this.body.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class Body {
  var orderType;
  var id;
  var contactName;
  var deliveryTime;
  var orderNo;
  var address;
  var lastUpdated;
  var orderStatus;
  List<Partners> partners;

  Body(
      {this.orderType,
      this.id,
      this.contactName,
      this.deliveryTime,
      this.orderNo,
      this.address,
      this.lastUpdated,
      this.orderStatus,
      this.partners});

  Body.fromJson(Map<String, dynamic> json) {
    orderType = json['order_type'];
    id = json['id'];
    contactName = json['contact_name'];
    deliveryTime = json['delivery_time'];
    orderNo = json['order_no'];
    address = json['address'];
    lastUpdated = json['last_updated'];
    orderStatus = json['order_status'];
    if (json['partners'] != null) {
      partners = new List<Partners>();
      json['partners'].forEach((v) {
        partners.add(new Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_type'] = this.orderType;
    data['id'] = this.id;
    data['contact_name'] = this.contactName;
    data['delivery_time'] = this.deliveryTime;
    data['order_no'] = this.orderNo;
    data['address'] = this.address;
    data['last_updated'] = this.lastUpdated;
    data['order_status'] = this.orderStatus;
    if (this.partners != null) {
      data['partners'] = this.partners.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Partners {
  var name;

  Partners({this.name});

  Partners.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    return data;
  }
}
