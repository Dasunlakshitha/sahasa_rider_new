class Order {
  bool done;
  Body body;
  String message;

  Order({this.done, this.body, this.message});

  Order.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'] != null ? Body.fromJson(json['body']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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

  Body({
    this.id,
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
      items = List<Items>();
      json['items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
    subTotal = json['sub_total'];
    remain = json['remain'];
    latitude = json['latitude'];
    longitude = json['longitude'];
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
    data['service_charge'] = serviceCharge;
    data['order_status'] = orderStatus;
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    data['sub_total'] = subTotal;
    data['remain'] = remain;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class Items {
  var name;
  var contactNo;
  var partnerLat;
  var partnerLong;
  List<OrderItems> orderItems;

  Items({name, contactNo, orderItems});

  Items.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    contactNo = json['contact_no'];
    partnerLat = json['partner_lat'];
    partnerLong = json['partner_long'];
    if (json['order_items'] != null) {
      orderItems = new List<OrderItems>();
      json['order_items'].forEach((v) {
        orderItems.add(OrderItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['contact_no'] = contactNo;
    data['partner_lat'] = partnerLat;
    data['partner_long'] = partnerLong;
    if (orderItems != null) {
      data['order_items'] = orderItems.map((v) => v.toJson()).toList();
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
    data['id'] = id;
    data['name'] = name;
    data['quantity'] = quantity;
    data['order_id'] = orderId;
    data['total_amount'] = totalAmount;
    data['item_id'] = itemId;
    data['unit'] = unit;
    data['package_id'] = packageId;
    data['item_status'] = itemStatus;
    return data;
  }
}
