import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:wevoride/app/payment/createRazorPayOrderModel.dart';

import 'package:wevoride/model/payment_method_model.dart';

class RazorPayController {
  Future<CreateRazorPayOrderModel?> createOrderRazorPay({required String amount, required RazorpayModel? razorpayModel}) async {
    final String orderId = DateTime.now().millisecondsSinceEpoch.toString();
    RazorpayModel razorPayData = razorpayModel!;
    print(razorPayData.razorpayKey);
    print("we Enter In");
    String url = "https://api.razorpay.com/v1/orders";
    final String basicAuth = 'Basic ${base64Encode(utf8.encode('${razorPayData.razorpayKey}:${razorPayData.razorpaySecret}'))}';
    print(orderId);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': basicAuth,
      },
      body: jsonEncode({
        "amount": (double.parse(amount) * 100).toStringAsFixed(0),
        "currency": "INR",
      }),
    );
    log("https://api.razorpay.com/v1/orders :: ${response.body}");
    if (response.statusCode == 500) {
      return null;
    } else {
      final data = jsonDecode(response.body);
      print(data);

      return CreateRazorPayOrderModel.fromJson(data);
    }
  }
}
