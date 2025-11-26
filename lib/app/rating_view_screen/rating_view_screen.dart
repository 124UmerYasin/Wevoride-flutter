import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/rating_view_controller.dart';
import 'package:wevoride/model/review_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/themes/responsive.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:wevoride/utils/fire_store_utils.dart';
import 'package:wevoride/utils/network_image_widget.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

class RatingViewScreen extends StatelessWidget {
  const RatingViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetX(
        init: RatingViewController(),
        builder: (controller) {
          return CustomScaffold(
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              titleSpacing: 0,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.chevron_left_outlined,
                  color: themeChange.getThem() ? AppThemeData.grey50 : AppThemeData.grey900,
                ),
              ),
              title: Text(
                "Ratings".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.semiBold, fontSize: 16),
              ),
              elevation: 0,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: themeChange.getThem() ? AppThemeData.grey700 : AppThemeData.grey200,
                  height: 4.0,
                ),
              ),
            ),
            body: controller.isLoading.value
                ? Constant.loader()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: controller.ratingList.isEmpty
                        ? Constant.showEmptyView(message: "Rating not fond", isDarkMode: themeChange.getThem())
                        : ListView.builder(
                            itemCount: controller.ratingList.length,
                            itemBuilder: (context, index) {
                              ReviewModel reviewModel = controller.ratingList[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(color: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100, borderRadius: const BorderRadius.all(Radius.circular(10))),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: double.parse(reviewModel.rating.toString()),
                                            minRating: 0,
                                            ignoreGestures: true,
                                            direction: Axis.horizontal,
                                            itemCount: 5,
                                            itemSize: 22,
                                            allowHalfRating: true,
                                            itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                                            itemBuilder: (context, _) => const Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                            ),
                                            onRatingUpdate: (double value) {},
                                          ),
                                          Text(
                                            Constant.timestampToDate(reviewModel.date!).tr,
                                            style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium, fontSize: 14),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 12,
                                      ),
                                      Text(
                                        "${reviewModel.comment}".tr,
                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.medium, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FutureBuilder<UserModel?>(
                                          future: FireStoreUtils.getUserProfile(reviewModel.userId.toString()),
                                          builder: (context, snapshot) {
                                            switch (snapshot.connectionState) {
                                              case ConnectionState.waiting:
                                                return const SizedBox();
                                              case ConnectionState.done:
                                                if (snapshot.hasError) {
                                                  return Text(snapshot.error.toString());
                                                } else if (snapshot.data == null) {
                                                  return const SizedBox();
                                                } else {
                                                  UserModel? userModel = snapshot.data;
                                                  return Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(60),
                                                        child: NetworkImageWidget(
                                                          imageUrl: userModel!.profilePic.toString(),
                                                          height: Responsive.width(10, context),
                                                          width: Responsive.width(10, context),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        userModel.fullName().toString(),
                                                        style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 16),
                                                      ),
                                                    ],
                                                  );
                                                }
                                              default:
                                                return Text('Error'.tr);
                                            }
                                          })
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
          );
        });
  }
}
