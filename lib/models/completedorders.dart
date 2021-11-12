class CompletedOrders {
  bool done;
  List<Body> body;
  String message;

  CompletedOrders({done, body, message});

  CompletedOrders.fromJson(Map<String, dynamic> json) {
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
  var orderType;
  var id;
  var deliveryTime;
  var orderNo;
  var address;
  var status;
  var date;
  var lastUpdated;

  Body(
      {this.orderType,
      this.id,
      this.deliveryTime,
      this.orderNo,
      this.address,
      this.status,
      this.date,
      this.lastUpdated});

  Body.fromJson(Map<String, dynamic> json) {
    orderType = json['order_type'];
    id = json['id'];
    deliveryTime = json['delivery_time'];
    orderNo = json['order_no'];
    address = json['address'];
    status = json['status'];
    date = json['date'];
    lastUpdated = json['last_updated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['order_type'] = orderType;
    data['id'] = id;
    data['delivery_time'] = deliveryTime;
    data['order_no'] = orderNo;
    data['address'] = address;
    data['status'] = status;
    data['date'] = date;
    data['last_updated'] = lastUpdated;
    return data;
  }
}
