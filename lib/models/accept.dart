class AcceptOrder {
  bool done;
  var body;
  String message;

  AcceptOrder({this.done, this.message});

  AcceptOrder.fromJson(Map<String, dynamic> json) {
    done = json['done'];
    body = json['body'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['done'] = done;
    data['body'] = body;
    data['message'] = message;
    return data;
  }
}
