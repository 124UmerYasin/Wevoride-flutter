import 'package:get/get.dart';

class CalenderController extends GetxController {
  var selectedDay = DateTime.now().add(const Duration(hours: 1)).obs;
}
