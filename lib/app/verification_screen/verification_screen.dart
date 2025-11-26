import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/controller/verification_controller.dart';
import 'package:wevoride/model/document_model.dart';
import 'package:wevoride/model/user_verification_model.dart';
import 'package:wevoride/themes/app_them_data.dart';
import 'package:wevoride/utils/dark_theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:wevoride/widgets/custom_scaffold.dart';

import 'verification_details_upload_screen.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder<VerificationController>(
        init: VerificationController(),
        builder: (controller) {
          return CustomScaffold(
            backgroundColor: themeChange.getThem() ? AppThemeData.grey800 : AppThemeData.grey100,
            appBar: AppBar(
              backgroundColor: themeChange.getThem() ? AppThemeData.grey900 : AppThemeData.grey50,
              centerTitle: false,
              automaticallyImplyLeading: false,
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
                "Account Verification".tr,
                style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18),
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
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: controller.isLoading.value
                  ? Constant.loader()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Upload Required Documents".tr,
                          style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800, fontFamily: AppThemeData.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Complete your registration by uploading the following documents.".tr,
                          style: TextStyle(color: themeChange.getThem() ? AppThemeData.grey200 : AppThemeData.grey700, fontFamily: AppThemeData.regular),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ListView.builder(
                          itemCount: controller.documentList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            DocumentModel documentModel = controller.documentList[index];
                            // ignore: unused_local_variable
                            Documents documents = Documents();

                            var contain = controller.driverDocumentList.where((element) => element.documentId == documentModel.id);
                            if (contain.isNotEmpty) {
                              documents = controller.driverDocumentList.firstWhere((itemToCheck) => itemToCheck.documentId == documentModel.id);
                            }

                            return InkWell(
                              onTap: () {
                                Get.to(const VerificationDetailsUploadScreen(), arguments: {'documentModel': documentModel});
                              },
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset("assets/icons/ic_document.svg"),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${documentModel.title}",
                                              style: TextStyle(
                                                color: themeChange.getThem() ? AppThemeData.grey100 : AppThemeData.grey800,
                                                fontFamily: AppThemeData.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "${documentModel.frontSide == true ? "Front" : ""} ${documentModel.backSide == true ? "And Back" : ""} Photo",
                                              style: TextStyle(
                                                color: themeChange.getThem() ? AppThemeData.grey300 : AppThemeData.grey600,
                                                fontFamily: AppThemeData.regular,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey)
                                    ],
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Divider(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
            ),
          );
        });
  }
}
