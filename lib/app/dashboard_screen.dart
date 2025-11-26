import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/controller/dashboard_controller.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';
import 'package:wevoride/widgets/safe_bottom_widget.dart';
import 'package:provider/provider.dart';

class DashBoardScreen extends StatelessWidget {
  const DashBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    // Initialize controller as permanent singleton if not already initialized
    // This ensures the listener works on all screens
    DashboardScreenController.initialize();
    
    return GetX<DashboardScreenController>(
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            body: controller.pageList[controller.selectedIndex.value],
            bottomNavigationBar: SafeBottomNavigationBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                showUnselectedLabels: true,
                showSelectedLabels: true,
                selectedFontSize: 12,
                selectedLabelStyle: const TextStyle(fontFamily: AppThemeData.bold),
                unselectedLabelStyle: const TextStyle(fontFamily: AppThemeData.bold),
                currentIndex: controller.selectedIndex.value,
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: themeChange.getThem() ? AppThemeData.primary300 : AppThemeData.primary300,
                unselectedItemColor: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                onTap: (int index) {
                  controller.selectedIndex.value = index;
                },
                items: [
                navigationBarItem(
                  themeChange,
                  index: 0,
                  assetIcon: "assets/icons/ic_car.svg",
                  label: 'Search'.tr,
                  controller: controller,
                ),
                navigationBarItem(
                  themeChange,
                  index: 1,
                  assetIcon: "assets/icons/ic_my_ride.svg",
                  label: 'My Rides'.tr,
                  controller: controller,
                ),
                navigationBarItem(
                  themeChange,
                  index: 2,
                  assetIcon: "assets/icons/ic_wallet.svg",
                  label: 'Wallet'.tr,
                  controller: controller,
                ),
                navigationBarItem(
                  themeChange,
                  index: 3,
                  assetIcon: "assets/icons/ic_inbox.svg",
                  label: 'Inbox'.tr,
                  controller: controller,
                ),
                navigationBarItem(
                  themeChange,
                  index: 4,
                  assetIcon: "assets/icons/ic_user.svg",
                  label: 'Profile'.tr,
                  controller: controller,
                ),
              ],
              ),
            ),
          );
        });
  }

  BottomNavigationBarItem navigationBarItem(themeChange, {required int index, required String label, required String assetIcon, required DashboardScreenController controller}) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Stack(
          children: [
            SvgPicture.asset(
              assetIcon,
              height: 22,
              width: 22,
              color: controller.selectedIndex.value == index
                  ? themeChange.getThem()
                      ? AppThemeData.primary300
                      : AppThemeData.primary300
                  : themeChange.getThem()
                      ? AppThemeData.grey300
                      : AppThemeData.grey600,
            ),
            index == 3 && int.parse(controller.count.value) != 0
                ? Positioned(
                    right: 0,
                    child: SizedBox(
                      width: 12,
                      height: 12,
                      child: ClipOval(
                        child: Container(
                          decoration: BoxDecoration(color: AppThemeData.primary300),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      label: label,
    );
  }
}
