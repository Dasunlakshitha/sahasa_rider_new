class NewOrders {
  bool done;
  List<Body> body;
  String message;

  NewOrders({this.done, this.body, this.message});

  NewOrders.fromJson(Map<String, dynamic> json) {
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
      partners = new List<Partners>();
      json['partners'].forEach((v) {
        partners.add(new Partners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_no'] = this.orderNo;
    data['delivery_time'] = this.deliveryTime;
    data['order_type'] = this.orderType;
    data['address'] = this.address;
    data['id'] = this.id;
    data['contact_name'] = this.contactName;
    data['last_updated'] = this.lastUpdated;
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
