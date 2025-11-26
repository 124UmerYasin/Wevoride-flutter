import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:paged_vertical_calendar/paged_vertical_calendar.dart';
import 'package:wevoride/controller/calender_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class DatepickerScreen extends StatelessWidget {
  const DatepickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX<CalenderController>(
        init: CalenderController(),
        builder: (controller) {
          return CustomScaffold(
              appBar: AppBar(
                backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
                centerTitle: true,
                leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.close)),
                title: Text(
                  "When are you going?".tr,
                  style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 18),
                ),
              ),
              body: PagedVerticalCalendar(
                dayAspectRatio: 1,
                dayBuilder: (context, date) {
                  if (date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                    return const SizedBox();
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40),
                              color: controller.selectedDay.value != date
                                  ? Colors.transparent
                                  : themeChange.getThem()
                                      ? AppThemeData.primary300
                                      : AppThemeData.grey800),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          child: Text(
                            DateFormat('d').format(date),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                  color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                  fontSize: 14,
                                ),
                          )),
                    ],
                  );
                },
                monthBuilder: (context, month, year) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          DateFormat('MMMM yyyy').format(DateTime(year, month)),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                fontSize: 18,
                              ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            weekText('Su', themeChange),
                            weekText('Mo', themeChange),
                            weekText('Tu', themeChange),
                            weekText('We', themeChange),
                            weekText('Th', themeChange),
                            weekText('Fr', themeChange),
                            weekText('Sa', themeChange),
                          ],
                        ),
                      ),
                    ],
                  );
                },
                initialDate: controller.selectedDay.value,
                minDate: DateTime.now(),
                maxDate: DateTime.now().add(const Duration(days: 365)),
                onDayPressed: (date) {
                  if (!date.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
                    controller.selectedDay.value = date;
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Get.back(result: controller.selectedDay.value);
                    });
                  }
                },
              ));
        });
  }
}

Widget weekText(String text, DarkThemeProvider themeChange) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text(
      text,
      style: TextStyle(
        color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
        fontSize: 18,
        fontFamily: AppThemeData.medium,
      ),
    ),
  );
}
