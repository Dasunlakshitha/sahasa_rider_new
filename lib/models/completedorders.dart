class CompletedOrders {
  bool done;
  List<Body> body;
  String message;

  CompletedOrders({this.done, this.body, this.message});

  CompletedOrders.fromJson(Map<String, dynamic> json) {
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_type'] = this.orderType;
    data['id'] = this.id;
    data['delivery_time'] = this.deliveryTime;
    data['order_no'] = this.orderNo;
    data['address'] = this.address;
    data['status'] = this.status;
    data['date'] = this.date;
    data['last_updated'] = this.lastUpdated;
    return data;
  }
}
