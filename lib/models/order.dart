  class Order {
  bool done;
  Body body;
  String message;

    Order({this.done, this.body, this.message});

  Order.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['done'] = this.done;
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    data['message'] = this.message;
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
  var serviceCharge;
  var orderStatus;
  List<Items> items;
  var subTotal;
  var remain;
  var latitude;
  var longitude;

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
      this.serviceCharge,
      this.orderStatus,
      this.items,
      this.subTotal,
      this.remain,
      this.latitude,
      this.longitude,
      });

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
    serviceCharge = json['service_charge'];
    orderStatus = json['order_status'];
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    remain = json['remain'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['order_no'] = this.orderNo;
    data['contact_name'] = this.contactName;
    data['contact_no'] = this.contactNo;
    data['address'] = this.address;
    data['comment'] = this.comment;
    data['account_id'] = this.accountId;
    data['status'] = this.status;
    data['date'] = this.date;
    data['last_updated'] = this.lastUpdated;
    data['nic'] = this.nic;
    data['distance'] = this.distance;
    data['return_note'] = this.returnNote;
    data['delivery_person_id'] = this.deliveryPersonId;
    data['distance_value'] = this.distanceValue;
    data['canceled_reason'] = this.canceledReason;
    data['contact_no_secondary'] = this.contactNoSecondary;
    data['partner_id'] = this.partnerId;
    data['delivery_time'] = this.deliveryTime;
    data['advance_payment_amount'] = this.advancePaymentAmount;
    data['convenience_fee'] = this.convenienceFee;
    data['service_charge'] = this.serviceCharge;
    data['order_status'] = this.orderStatus;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['sub_total'] = this.subTotal;
    data['remain'] = this.remain;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class Items {
  var name;
  var contactNo;
  var partnerLat;
  var partnerLong;
  List<OrderItems> orderItems;

  Items({this.name, this.contactNo, this.orderItems});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNo = json['contact_no'];
    partnerLat = json['partner_lat'];
    partnerLong = json['partner_long'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(new OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['contact_no'] = this.contactNo;
    data['partner_lat'] = this.partnerLat;
    data['partner_long'] = this.partnerLong;
    if (this.orderItems != null) {
      data['order_items'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  var id;
  var name;
  var quantity;
  var orderId;
  var totalAmount;
  var itemId;
  var unit;
  var packageId;
  var itemStatus;

  OrderItems(
      {this.id,
      this.name,
      this.quantity,
      this.orderId,
      this.totalAmount,
      this.itemId,
      this.unit,
      this.packageId,
      this.itemStatus});

  OrderItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    quantity = json['quantity'];
    orderId = json['order_id'];
    totalAmount = json['total_amount'];
    itemId = json['item_id'];
    unit = json['unit'];
    packageId = json['package_id'];
    itemStatus = json['item_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['quantity'] = this.quantity;
    data['order_id'] = this.orderId;
    data['total_amount'] = this.totalAmount;
    data['item_id'] = this.itemId;
    data['unit'] = this.unit;
    data['package_id'] = this.packageId;
    data['item_status'] = this.itemStatus;
    return data;
  }
}