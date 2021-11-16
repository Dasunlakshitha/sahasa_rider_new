class Earning {
  bool done;
  Body body;
  String message;

  Earning({this.done, this.body, this.message});

  Earning.fromJson(Map<String, dynamic> json) {
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
  var pickCash;
  var orderCash;
  var totalPickup;
  var deliveryCash;
  var totalCashOrders;
  var totalCashDelivery;
  var totalOnlineOrders;
  var totalOnlineDelivery;
  var onlineCash;
  List<Items> items;
  var totalOnlineBonus;
  var totalCashBonus;

  Body(
      {this.pickCash,
      this.orderCash,
      this.totalPickup,
      this.deliveryCash,
      this.totalCashOrders,
      this.totalCashDelivery,
      this.totalOnlineOrders,
      this.totalOnlineDelivery,
      this.onlineCash,
      this.items,
      this.totalOnlineBonus,
      this.totalCashBonus});

  Body.fromJson(Map<String, dynamic> json) {
    pickCash = json['pick_cash'];
    orderCash = json['order_cash'];
    totalPickup = json['total_pickup'];
    deliveryCash = json['delivery_cash'];
    totalCashOrders = json['total_cash_orders'];
    totalCashDelivery = json['total_cash_delivery'];
    totalOnlineOrders = json['total_online_orders'];
    totalOnlineDelivery = json['total_online_delivery'];
    onlineCash = json['online_cash'] ?? 0;
    if (json['items'] != null) {
      items = new List<Items>();
      json['items'].forEach((v) {
        items.add(new Items.fromJson(v));
      });
    }
    totalOnlineBonus = json['totalOnlineBonus'];
    totalCashBonus = json['totalCashBonus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['pick_cash'] = pickCash;
    data['order_cash'] = orderCash;
    data['total_pickup'] = totalPickup;
    data['delivery_cash'] = deliveryCash;
    data['total_cash_orders'] = totalCashOrders;
    data['total_cash_delivery'] = totalCashDelivery;
    data['total_online_orders'] = totalOnlineOrders;
    data['total_online_delivery'] = totalOnlineDelivery;
    data['online_cash'] = onlineCash;
    if (items != null) {
      data['items'] = items.map((v) => v.toJson()).toList();
    }
    data['totalOnlineBonus'] = totalOnlineBonus;
    data['totalCashBonus'] = totalCashBonus;
    return data;
  }
}

class Items {
  var pickCash;
  var orderCash;
  var totalPickup;
  var deliveryCash;
  var endCashBonus;
  var endOnlineBonus;
  var startCashBonus;
  var totalCashOrders;
  var startOnlineBonus;
  var totalCashDelivery;
  var totalOnlineOrders;
  var totalOnlineDelivery;
  var onlineBonus;
  var cashBonus;
  var onlineCash;
  var orderDate;

  Items(
      {this.pickCash,
      this.orderCash,
      this.totalPickup,
      this.deliveryCash,
      this.endCashBonus,
      this.endOnlineBonus,
      this.startCashBonus,
      this.totalCashOrders,
      this.startOnlineBonus,
      this.totalCashDelivery,
      this.totalOnlineOrders,
      this.totalOnlineDelivery,
      this.onlineBonus,
      this.cashBonus,
      this.onlineCash,
      this.orderDate});

  Items.fromJson(Map<String, dynamic> json) {
    pickCash = json['pick_cash'];
    orderCash = json['order_cash'] ?? 0;
    totalPickup = json['total_pickup'];
    deliveryCash = json['delivery_cash'];
    endCashBonus = json['end_cash_bonus'];
    endOnlineBonus = json['end_online_bonus'];
    startCashBonus = json['start_cash_bonus'];
    totalCashOrders = json['total_cash_orders'];
    startOnlineBonus = json['start_online_bonus'];
    totalCashDelivery = json['total_cash_delivery'];
    totalOnlineOrders = json['total_online_orders'];
    totalOnlineDelivery = json['total_online_delivery'];
    onlineBonus = json['online_bonus'];
    cashBonus = json['cash_bonus'];
    onlineCash = json['online_cash'] ?? 0;
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pick_cash'] = pickCash;
    data['order_cash'] = orderCash;
    data['total_pickup'] = totalPickup;
    data['delivery_cash'] = deliveryCash;
    data['end_cash_bonus'] = endCashBonus;
    data['end_online_bonus'] = endOnlineBonus;
    data['start_cash_bonus'] = startCashBonus;
    data['total_cash_orders'] = totalCashOrders;
    data['start_online_bonus'] = startOnlineBonus;
    data['total_cash_delivery'] = totalCashDelivery;
    data['total_online_orders'] = totalOnlineOrders;
    data['total_online_delivery'] = totalOnlineDelivery;
    data['online_bonus'] = onlineBonus;
    data['cash_bonus'] = cashBonus;
    data['online_cash'] = onlineCash;
    data['order_date'] = orderDate;
    return data;
  }
}
