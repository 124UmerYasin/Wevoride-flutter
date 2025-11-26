class AdminCommission {
  String? amount;
  bool? enable;
  String? type;

  AdminCommission({this.amount, this.enable, this.type});

  AdminCommission.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    enable = json['enable'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['enable'] = enable;
    data['type'] = type;
    return data;
  }
}
