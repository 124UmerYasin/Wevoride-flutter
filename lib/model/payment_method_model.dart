class PaymentModel {
  FlutterWave? flutterWave;
  PayStack? payStack;
  Strip? strip;
  Wallet? wallet;
  MercadoPago? mercadoPago;
  RazorpayModel? razorpay;
  Paytm? paytm;
  Payfast? payfast;
  Wallet? cash;
  Paypal? paypal;
  Xendit? xendit;
  OrangePay? orangePay;
  Midtrans? midtrans;

  PaymentModel(
      {this.flutterWave,
      this.midtrans,
      this.payStack,
      this.strip,
      this.wallet,
      this.mercadoPago,
      this.razorpay,
      this.paytm,
      this.payfast,
      this.cash,
      this.paypal,
      this.xendit,
      this.orangePay});

  PaymentModel.fromJson(Map<String, dynamic> json) {
    flutterWave = json['flutterWave'] != null ? FlutterWave.fromJson(json['flutterWave']) : null;
    payStack = json['payStack'] != null ? PayStack.fromJson(json['payStack']) : null;
    strip = json['strip'] != null ? Strip.fromJson(json['strip']) : null;
    wallet = json['wallet'] != null ? Wallet.fromJson(json['wallet']) : null;
    mercadoPago = json['mercadoPago'] != null ? MercadoPago.fromJson(json['mercadoPago']) : null;
    razorpay = json['razorpay'] != null ? RazorpayModel.fromJson(json['razorpay']) : null;
    paytm = json['paytm'] != null ? Paytm.fromJson(json['paytm']) : null;
    payfast = json['payfast'] != null ? Payfast.fromJson(json['payfast']) : null;
    cash = json['cash'] != null ? Wallet.fromJson(json['cash']) : null;
    paypal = json['paypal'] != null ? Paypal.fromJson(json['paypal']) : null;
    xendit = json['xendit'] != null ? Xendit.fromJson(json['xendit']) : null;
    orangePay = json['orangePay'] != null ? OrangePay.fromJson(json['orangePay']) : null;
    midtrans = json['midtrans'] != null ? Midtrans.fromJson(json['midtrans']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (flutterWave != null) {
      data['flutterWave'] = flutterWave!.toJson();
    }
    if (payStack != null) {
      data['payStack'] = payStack!.toJson();
    }
    if (strip != null) {
      data['strip'] = strip!.toJson();
    }
    if (wallet != null) {
      data['wallet'] = wallet!.toJson();
    }
    if (mercadoPago != null) {
      data['mercadoPago'] = mercadoPago!.toJson();
    }
    if (razorpay != null) {
      data['razorpay'] = razorpay!.toJson();
    }
    if (paytm != null) {
      data['paytm'] = paytm!.toJson();
    }
    if (payfast != null) {
      data['payfast'] = payfast!.toJson();
    }
    if (cash != null) {
      data['cash'] = cash!.toJson();
    }
    if (paypal != null) {
      data['paypal'] = paypal!.toJson();
    }
    if (midtrans != null) {
      data['midtrans'] = midtrans!.toJson();
    }
    if (orangePay != null) {
      data['orangePay'] = orangePay!.toJson();
    }
    if (xendit != null) {
      data['xendit'] = xendit!.toJson();
    }
    return data;
  }
}

class FlutterWave {
  String? secretKey;
  bool? enable;
  String? name;
  String? publicKey;
  String? encryptionKey;
  bool? isSandbox;
  bool? isWithdrawEnabled;

  FlutterWave({this.secretKey, this.enable, this.name, this.publicKey, this.encryptionKey, this.isSandbox, this.isWithdrawEnabled});

  FlutterWave.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    encryptionKey = json['encryptionKey'];
    isSandbox = json['isSandbox'];
    isWithdrawEnabled = json['isWithdrawEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['encryptionKey'] = encryptionKey;
    data['isSandbox'] = isSandbox;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class PayStack {
  String? secretKey;
  bool? enable;
  String? name;
  String? callbackURL;
  String? publicKey;
  bool? isSandbox;
  bool? isWithdrawEnabled;
  String? webhookURL;

  PayStack({this.secretKey, this.enable, this.name, this.callbackURL, this.publicKey, this.isSandbox, this.webhookURL, this.isWithdrawEnabled});

  PayStack.fromJson(Map<String, dynamic> json) {
    secretKey = json['secretKey'];
    enable = json['enable'];
    name = json['name'];
    callbackURL = json['callbackURL'];
    publicKey = json['publicKey'];
    isSandbox = json['isSandbox'];
    webhookURL = json['webhookURL'];
    isWithdrawEnabled = json['isWithdrawEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['secretKey'] = secretKey;
    data['enable'] = enable;
    data['name'] = name;
    data['callbackURL'] = callbackURL;
    data['publicKey'] = publicKey;
    data['isSandbox'] = isSandbox;
    data['webhookURL'] = webhookURL;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class Strip {
  String? clientpublishableKey;
  String? stripeSecret;
  bool? enable;
  String? name;
  bool? isSandbox;
  bool? isWithdrawEnabled;

  Strip({this.clientpublishableKey, this.stripeSecret, this.enable, this.name, this.isSandbox, this.isWithdrawEnabled});

  Strip.fromJson(Map<String, dynamic> json) {
    clientpublishableKey = json['clientpublishableKey'];
    stripeSecret = json['stripeSecret'];
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    isWithdrawEnabled = json['isWithdrawEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientpublishableKey'] = clientpublishableKey;
    data['stripeSecret'] = stripeSecret;
    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class Wallet {
  bool? enable;
  String? name;

  Wallet({this.enable, this.name});

  Wallet.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    return data;
  }
}

class MercadoPago {
  bool? enable;
  String? name;
  String? publicKey;
  String? accessToken;
  bool? isSandbox;
  bool? isWithdrawEnabled;

  MercadoPago({this.enable, this.name, this.publicKey, this.accessToken, this.isSandbox, this.isWithdrawEnabled});

  MercadoPago.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    publicKey = json['publicKey'];
    accessToken = json['accessToken'];
    isSandbox = json['isSandbox'];
    isWithdrawEnabled = json['isWithdrawEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['name'] = name;
    data['publicKey'] = publicKey;
    data['accessToken'] = accessToken;
    data['isSandbox'] = isSandbox;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class RazorpayModel {
  bool? enable;
  String? razorpayKey;
  bool? isSandbox;
  String? razorpaySecret;
  String? name;
  bool? isWithdrawEnabled;

  RazorpayModel({this.name, this.enable, this.razorpayKey, this.isSandbox, this.razorpaySecret, this.isWithdrawEnabled});

  RazorpayModel.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    razorpayKey = json['razorpayKey'];
    isSandbox = json['isSandbox'];
    razorpaySecret = json['razorpaySecret'];
    name = json['name'];
    isWithdrawEnabled = json['isWithdrawEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['razorpayKey'] = razorpayKey;
    data['isSandbox'] = isSandbox;
    data['razorpaySecret'] = razorpaySecret;
    data['name'] = name;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class Paytm {
  bool? enable;
  String? paytmMID;
  bool? isSandbox;
  String? merchantKey;
  String? name;

  Paytm({this.name, this.enable, this.paytmMID, this.isSandbox, this.merchantKey});

  Paytm.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    paytmMID = json['paytmMID'];
    isSandbox = json['isSandbox'];
    merchantKey = json['merchantKey'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['enable'] = enable;
    data['paytmMID'] = paytmMID;
    data['isSandbox'] = isSandbox;
    data['merchantKey'] = merchantKey;
    data['name'] = name;
    return data;
  }
}

class Payfast {
  String? merchantId;
  bool? enable;
  String? name;
  String? returnUrl;
  String? notifyUrl;
  bool? isSandbox;
  String? cancelUrl;
  String? merchantKey;
  bool? isWithdrawEnabled;

  Payfast({this.merchantId, this.enable, this.name, this.returnUrl, this.notifyUrl, this.isSandbox, this.cancelUrl, this.merchantKey, this.isWithdrawEnabled});

  Payfast.fromJson(Map<String, dynamic> json) {
    merchantId = json['merchantId'];
    enable = json['enable'];
    name = json['name'];
    returnUrl = json['return_url'];
    notifyUrl = json['notify_url'];
    isSandbox = json['isSandbox'];
    cancelUrl = json['cancel_url'];
    merchantKey = json['merchantKey'];
    isWithdrawEnabled = json['isWithdrawEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['merchantId'] = merchantId;
    data['enable'] = enable;
    data['name'] = name;
    data['return_url'] = returnUrl;
    data['notify_url'] = notifyUrl;
    data['isSandbox'] = isSandbox;
    data['cancel_url'] = cancelUrl;
    data['merchantKey'] = merchantKey;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class Paypal {
  bool? enable;
  String? name;
  String? paypalSecret;
  String? paypalClient;
  String? image;
  bool? isSandbox;
  bool? isWithdrawEnabled;

  Paypal({this.name, this.enable, this.paypalSecret, this.isSandbox, this.paypalClient, this.image, this.isWithdrawEnabled});

  Paypal.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    paypalSecret = json['paypalSecret'];
    paypalClient = json['paypalClient'];
    isSandbox = json['isSandbox'];
    image = json['image'];
    isWithdrawEnabled = json['isWithdrawEnabled'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['paypalSecret'] = paypalSecret;
    data['isSandbox'] = isSandbox;
    data['paypalClient'] = paypalClient;
    data['image'] = image;
    data['isWithdrawEnabled'] = isWithdrawEnabled;
    return data;
  }
}

class Xendit {
  bool? enable;
  String? name;
  bool? isSandbox;
  String? apiKey;

  Xendit({
    this.name,
    this.enable,
    this.apiKey,
    this.isSandbox,
  });

  Xendit.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    apiKey = json['apiKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['apiKey'] = apiKey;
    return data;
  }
}

class Midtrans {
  bool? enable;
  String? name;
  bool? isSandbox;
  String? serverKey;

  Midtrans({
    this.name,
    this.enable,
    this.serverKey,
    this.isSandbox,
  });

  Midtrans.fromJson(Map<String, dynamic> json) {
    enable = json['enable'];
    name = json['name'];
    isSandbox = json['isSandbox'];
    serverKey = json['serverKey'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['enable'] = enable;
    data['name'] = name;
    data['isSandbox'] = isSandbox;
    data['serverKey'] = serverKey;
    return data;
  }
}

class OrangePay {
  String? clientId;
  String? clientSecret;
  String? merchantKey;
  String? auth;
  String? returnUrl;
  String? cancelUrl;
  String? notifUrl;
  String? name;
  bool? enable;
  bool? isSandbox;

  OrangePay(
      {this.clientId = '',
      this.clientSecret = '',
      this.merchantKey,
      this.auth,
      this.returnUrl = '',
      this.cancelUrl = '',
      this.notifUrl = '',
      this.name,
      this.isSandbox = false,
      this.enable = false});

  OrangePay.fromJson(Map<String, dynamic> parsedJson) {
    clientId = parsedJson['clientId'];
    clientSecret = parsedJson['clientSecret'];
    merchantKey = parsedJson['merchantKey'];
    auth = parsedJson['auth'];
    enable = parsedJson['enable'];
    returnUrl = parsedJson['returnUrl'];
    cancelUrl = parsedJson['cancelUrl'];
    notifUrl = parsedJson['notifyUrl'];
    isSandbox = parsedJson['isSandbox'];
    name = parsedJson['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientId'] = clientId;
    data['clientSecret'] = clientSecret;
    data['merchantKey'] = merchantKey;
    data['auth'] = auth;
    data['enable'] = enable;
    data['returnUrl'] = returnUrl;
    data['cancelUrl'] = cancelUrl;
    data['notifyUrl'] = notifUrl;
    data['isSandbox'] = isSandbox;
    data['name'] = name;

    return data;
  }
}
