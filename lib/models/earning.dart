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
    onlineCash = json['online_cash'];
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pick_cash'] = this.pickCash;
    data['order_cash'] = this.orderCash;
    data['total_pickup'] = this.totalPickup;
    data['delivery_cash'] = this.deliveryCash;
    data['total_cash_orders'] = this.totalCashOrders;
    data['total_cash_delivery'] = this.totalCashDelivery;
    data['total_online_orders'] = this.totalOnlineOrders;
    data['total_online_delivery'] = this.totalOnlineDelivery;
    data['online_cash'] = this.onlineCash;
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    data['totalOnlineBonus'] = this.totalOnlineBonus;
    data['totalCashBonus'] = this.totalCashBonus;
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
    orderCash = json['order_cash'];
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
    onlineCash = json['online_cash'];
    orderDate = json['order_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pick_cash'] = this.pickCash;
    data['order_cash'] = this.orderCash;
    data['total_pickup'] = this.totalPickup;
    data['delivery_cash'] = this.deliveryCash;
    data['end_cash_bonus'] = this.endCashBonus;
    data['end_online_bonus'] = this.endOnlineBonus;
    data['start_cash_bonus'] = this.startCashBonus;
    data['total_cash_orders'] = this.totalCashOrders;
    data['start_online_bonus'] = this.startOnlineBonus;
    data['total_cash_delivery'] = this.totalCashDelivery;
    data['total_online_orders'] = this.totalOnlineOrders;
    data['total_online_delivery'] = this.totalOnlineDelivery;
    data['online_bonus'] = this.onlineBonus;
    data['cash_bonus'] = this.cashBonus;
    data['online_cash'] = this.onlineCash;
    data['order_date'] = this.orderDate;
    return data;
  }
}
