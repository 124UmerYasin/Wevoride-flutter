import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:wevoride/constant/collection_name.dart';
import 'package:wevoride/constant/constant.dart';
import 'package:wevoride/constant/send_notification.dart';
import 'package:wevoride/constant/show_toast_dialog.dart';
import 'package:wevoride/model/booking_model.dart';
import 'package:wevoride/model/map/city_list_model.dart';
import 'package:wevoride/model/review_model.dart';
import 'package:wevoride/model/user_model.dart';
import 'package:wevoride/utils/fire_store_utils.dart';

class PublishedDetailsController extends GetxController {
  @override
  void onInit() {
    getArgument();
    super.onInit();
  }

  Rx<BookingModel> bookingModel = BookingModel().obs;
  RxList<BookedUserModel> bookingUserList = <BookedUserModel>[].obs;

  RxList<CityModel> stopOver = <CityModel>[].obs;
  Rx<UserModel> publisherUserModel = UserModel().obs;

  getArgument() async {
    dynamic argumentData = Get.arguments;
    if (argumentData != null) {
      bookingModel.value = argumentData['bookingModel'];
    }

    getUserData();

    FireStoreUtils.fireStore.collection(CollectionName.booking).doc(bookingModel.value.id).snapshots().listen(
      (event) {
        stopOver.clear();
        if (event.data() != null) {
          bookingModel.value = BookingModel.fromJson(event.data()!);
          stopOver.add(bookingModel.value.pickupLocation!);
          stopOver.addAll(bookingModel.value.stopOver!);
          stopOver.add(bookingModel.value.dropLocation!);
        }
      },
    );

    FireStoreUtils.fireStore.collection(CollectionName.booking).doc(bookingModel.value.id).collection("bookedUser").snapshots().listen((value) {
      bookingUserList.clear();
      for (var element in value.docs) {
        BookedUserModel documentModel = BookedUserModel.fromJson(element.data());
        bookingUserList.add(documentModel);
      }
    });

    await FireStoreUtils.getUserProfile(bookingModel.value.createdBy.toString()).then((value) {
      publisherUserModel.value = value!;
    });
  }

  changeStatus(CityModel cityModel, int index) async {
    if (cityModel.isArrived != true) {
      ShowToastDialog.showLoader("Please wait");
      cityModel.isArrived = true;
      if (index == 0) {
        bookingModel.value.status = Constant.onGoing;
      }
      if (index == stopOver.length - 1) {
        bookingModel.value.status = Constant.completed;
      }
      stopOver.removeAt(index);
      stopOver.insert(index, cityModel);
      stopOver.removeAt(0);
      stopOver.removeAt(stopOver.length - 1);
      bookingModel.value.stopOver = stopOver;

      await FireStoreUtils.setBooking(bookingModel.value);
      ShowToastDialog.closeLoader();
      
      // Only send notification when driver clicks "Reached" (trip completed)
      // This is when index == stopOver.length - 1 and status becomes "completed"
      if (index == stopOver.length - 1 && bookingModel.value.status == Constant.completed) {
        // Small delay to ensure database update is complete before sending notifications
        await Future.delayed(const Duration(milliseconds: 500));
        
        // Send notification to all passengers for this completed trip
        // This will trigger the payment screen for passengers
        bookingUserList.forEach(
          (element) async {
            await FireStoreUtils.getUserProfile(element.id.toString()).then((value) async {
              if (value != null) {
                UserModel userModel = value;
                // Send notification with booking ID in payload for reference
                await SendNotification.sendOneNotification(
                  token: userModel.fcmToken.toString(), 
                  type: Constant.ride_arrive, 
                  payload: {"bookingId": bookingModel.value.id ?? ""}
                );
              }
            });
          },
        );
      } else {
        // For other stops (Start button when index == 0, or Arrived for intermediate stops)
        // Send notification only to passengers at that specific stop (for arrival updates)
        // But this should NOT trigger payment screen - only informational
        CityModel nextStationCity;
        if (index == 0 || index == stopOver.length - 1) {
          nextStationCity = stopOver[index];
        } else {
          nextStationCity = stopOver[index + 1];
        }
        bookingUserList.forEach(
          (element) async {
            bool isSame = await checkSameCity(
              nextStationCity.geometry!.location!.lat!,
              nextStationCity.geometry!.location!.lng!,
              element.stopOver!.startLocation!.lat!,
              element.stopOver!.startLocation!.lng!,
            );
            if (isSame) {
              await FireStoreUtils.getUserProfile(element.id.toString()).then((value) async {
                if (value != null) {
                  UserModel userModel = value;
                  // Note: This notification is just for arrival updates, not for payment
                  // The payment screen will only show when trip is completed (Reached button)
                  await SendNotification.sendOneNotification(token: userModel.fcmToken.toString(), type: Constant.ride_arrive, payload: {});
                }
              });
            }
          },
        );
      }

      // if (index == 0) {
      //   bookingModel.value.pickupLocation = cityModel;
      //   await FireStoreUtils.setBooking(bookingModel.value);
      // } else if (index == 0) {
      //   bookingModel.value.dropLocation = cityModel;
      //   await FireStoreUtils.setBooking(bookingModel.value);
      // } else {
      //
      // }
    }
  }

  publishRide() async {
    ShowToastDialog.showLoader("Please wait");
    if (bookingUserList.isEmpty) {
      await FireStoreUtils.setBooking(bookingModel.value).then((value) {
        ShowToastDialog.closeLoader();
        Get.back(result: true);
      });
    } else {
      bookingUserList.forEach(
        (element) async {
          BookedUserModel bookingUserModel = element;
          UserModel? userModel;

          await FireStoreUtils.getUserProfile(bookingUserModel.id.toString()).then((value) {
            userModel = value!;
          });
          // if (bookingUserModel.paymentStatus == true) {
          //   if (bookingUserModel.paymentType!.toLowerCase() != "cash") {
          //     WalletTransactionModel transactionModel = WalletTransactionModel(
          //         id: Constant.getUuid(),
          //         amount: calculateAmount(bookingUserModel).toString(),
          //         createdDate: Timestamp.now(),
          //         paymentType: "Wallet",
          //         transactionId: bookingModel.value.id,
          //         isCredit: false,
          //         type: "publisher",
          //         userId: bookingModel.value.createdBy.toString(),
          //         note: "Amount refunded for ${userModel!.fullName()} ride");
          //
          //     await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
          //       if (value == true) {
          //         await FireStoreUtils.updateOtherUserWallet(amount: "-${calculateAmount(bookingUserModel).toString()}", id: bookingModel.value.createdBy.toString());
          //       }
          //     });
          //     if (bookingUserModel.adminCommission != null &&
          //         bookingUserModel.adminCommission!.enable == true) {
          //       WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          //           id: Constant.getUuid(),
          //           amount:
          //           "${Constant.calculateOrderAdminCommission(amount: double.parse(bookingUserModel.subTotal.toString()).toString(), adminCommission: bookingUserModel.adminCommission)}",
          //           createdDate: Timestamp.now(),
          //           paymentType: "Wallet",
          //           isCredit: true,
          //           transactionId: bookingModel.value.id,
          //           type: "publisher",
          //           userId: bookingModel.value.createdBy.toString(),
          //           note: "Admin commission credited for  ${userModel!.fullName()} ride");
          //
          //       await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
          //         if (value == true) {
          //           await FireStoreUtils.updateOtherUserWallet(
          //               amount: "${Constant.calculateOrderAdminCommission(amount: bookingUserModel.subTotal.toString(), adminCommission: bookingUserModel.adminCommission)}",
          //               id: bookingModel.value.createdBy.toString());
          //         }
          //       });
          //     }
          //
          //   } else {
          //     if (bookingUserModel.adminCommission != null &&
          //         bookingUserModel.adminCommission!.enable == true) {
          //       WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          //           id: Constant.getUuid(),
          //           amount:
          //           "${Constant.calculateOrderAdminCommission(amount: double.parse(bookingUserModel.subTotal.toString()).toString(), adminCommission: bookingUserModel.adminCommission)}",
          //           createdDate: Timestamp.now(),
          //           paymentType: "Wallet",
          //           isCredit: true,
          //           transactionId: bookingModel.value.id,
          //           userId: bookingModel.value.createdBy.toString(),
          //           type: "publisher",
          //           note: "Admin commission credited for  ${userModel!.fullName()} ride");
          //       await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
          //         if (value == true) {
          //           await FireStoreUtils.updateOtherUserWallet(
          //               amount: "-${Constant.calculateOrderAdminCommission(amount: bookingUserModel.subTotal.toString(), adminCommission: bookingUserModel.adminCommission)}",
          //               id: bookingModel.value.createdBy.toString());
          //         }
          //       });
          //     }
          //
          //   }
          //
          //   WalletTransactionModel transactionModel = WalletTransactionModel(
          //       id: Constant.getUuid(),
          //       amount: calculateAmount(bookingUserModel).toString(),
          //       createdDate: Timestamp.now(),
          //       paymentType: "Wallet",
          //       transactionId: bookingModel.value.id,
          //       isCredit: true,
          //       userId: userModel!.id.toString(),
          //       type: "customer",
          //       note: "Amount refunded for ${publisherUserModel.value.fullName()} ride");
          //
          //   await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
          //     if (value == true) {
          //       await FireStoreUtils.updateOtherUserWallet(amount: calculateAmount(bookingUserModel).toString(), id: userModel!.id.toString());
          //     }
          //   });
          // }

          await FireStoreUtils.setCancelledUserBooking(bookingModel.value, bookingUserModel);
          await FireStoreUtils.removeUserBooking(bookingModel.value, bookingUserModel);

          await SendNotification.sendChatNotification(
              token: userModel!.fcmToken ?? "",
              title: publisherUserModel.value.fullName().toString(),
              body: "We regret to inform you that your booking with us has been cancelled.",
              payload: {});
        },
      );
      bookingModel.value.bookedSeat = "0";
      bookingModel.value.bookedUserId!.clear();

      await FireStoreUtils.setBooking(bookingModel.value).then((value) {
        ShowToastDialog.closeLoader();
        Get.back(result: true);
      });
    }
  }

  deleteRide() async {
    ShowToastDialog.showLoader("Please wait");
    if (bookingUserList.isEmpty) {
      await FireStoreUtils.deleteBooking(bookingModel.value).then(
        (value) {
          ShowToastDialog.closeLoader();
          Get.back(result: true);
          Get.back(result: true);
        },
      );
    } else {
      bookingUserList.forEach(
        (element) async {
          BookedUserModel bookingUserModel = element;
          UserModel? userModel;

          await FireStoreUtils.getUserProfile(bookingUserModel.id.toString()).then((value) {
            userModel = value!;
          });

          // if (bookingUserModel.paymentStatus == true) {
          //   if (bookingUserModel.paymentType!.toLowerCase() != "cash") {
          //     WalletTransactionModel transactionModel = WalletTransactionModel(
          //         id: Constant.getUuid(),
          //         amount: calculateAmount(bookingUserModel).toString(),
          //         createdDate: Timestamp.now(),
          //         paymentType: "Wallet",
          //         transactionId: bookingModel.value.id,
          //         isCredit: false,
          //         type: "publisher",
          //         userId: bookingModel.value.createdBy.toString(),
          //         note: "Amount refunded for ${userModel!.fullName()} ride");
          //
          //     await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
          //       if (value == true) {
          //         await FireStoreUtils.updateOtherUserWallet(amount: "-${calculateAmount(bookingUserModel).toString()}", id: bookingModel.value.createdBy.toString());
          //       }
          //     });
          //     if (bookingUserModel.adminCommission != null &&
          //         bookingUserModel.adminCommission!.enable == true) {
          //       WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          //           id: Constant.getUuid(),
          //           amount:
          //           "${Constant.calculateOrderAdminCommission(amount: double.parse(bookingUserModel.subTotal.toString()).toString(), adminCommission: bookingUserModel.adminCommission)}",
          //           createdDate: Timestamp.now(),
          //           paymentType: "Wallet",
          //           isCredit: true,
          //           transactionId: bookingModel.value.id,
          //           userId: bookingModel.value.createdBy.toString(),
          //           type: "publisher",
          //           note: "Admin commission credited for  ${userModel!.fullName()} ride");
          //
          //       await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
          //         if (value == true) {
          //           await FireStoreUtils.updateOtherUserWallet(
          //               amount: "${Constant.calculateOrderAdminCommission(amount: bookingUserModel.subTotal.toString(), adminCommission: bookingUserModel.adminCommission)}",
          //               id: bookingModel.value.createdBy.toString());
          //         }
          //       });
          //     }
          //
          //   } else {
          //     if (bookingUserModel.adminCommission != null &&
          //         bookingUserModel.adminCommission!.enable == true) {
          //       WalletTransactionModel adminCommissionWallet = WalletTransactionModel(
          //           id: Constant.getUuid(),
          //           amount:
          //           "${Constant.calculateOrderAdminCommission(amount: double.parse(bookingUserModel.subTotal.toString()).toString(), adminCommission: bookingUserModel.adminCommission)}",
          //           createdDate: Timestamp.now(),
          //           paymentType: "Wallet",
          //           isCredit: true,
          //           transactionId: bookingModel.value.id,
          //           type: "publisher",
          //           userId: bookingModel.value.createdBy.toString(),
          //           note: "Admin commission credited for  ${userModel!.fullName()} ride");
          //       await FireStoreUtils.setWalletTransaction(adminCommissionWallet).then((value) async {
          //         if (value == true) {
          //           await FireStoreUtils.updateOtherUserWallet(
          //               amount: "-${Constant.calculateOrderAdminCommission(amount: bookingUserModel.subTotal.toString(), adminCommission: bookingUserModel.adminCommission)}",
          //               id: bookingModel.value.createdBy.toString());
          //         }
          //       });
          //     }
          //
          //   }
          //
          //   WalletTransactionModel transactionModel = WalletTransactionModel(
          //       id: Constant.getUuid(),
          //       amount: calculateAmount(bookingUserModel).toString(),
          //       createdDate: Timestamp.now(),
          //       paymentType: "Wallet",
          //       transactionId: bookingModel.value.id,
          //       isCredit: true,
          //       userId: userModel!.id.toString(),
          //       type: "customer",
          //       note: "Amount refunded for ${publisherUserModel.value.fullName()} ride");
          //
          //   await FireStoreUtils.setWalletTransaction(transactionModel).then((value) async {
          //     if (value == true) {
          //       await FireStoreUtils.updateOtherUserWallet(amount: calculateAmount(bookingUserModel).toString(), id: userModel!.id.toString());
          //     }
          //   });
          // }

          await FireStoreUtils.setCancelledUserBooking(bookingModel.value, bookingUserModel);
          await FireStoreUtils.removeUserBooking(bookingModel.value, bookingUserModel);
          await SendNotification.sendChatNotification(
              token: userModel!.fcmToken ?? "",
              title: publisherUserModel.value.fullName().toString(),
              body: "We regret to inform you that your booking with us has been cancelled.",
              payload: {});
        },
      );

      await FireStoreUtils.fireStore.collection(CollectionName.booking).doc("bookedUser").delete();
      await FireStoreUtils.fireStore.collection(CollectionName.booking).doc("cancelledUser").delete();

      await FireStoreUtils.deleteBooking(bookingModel.value).then(
        (value) {
          ShowToastDialog.closeLoader();
          Get.back(result: true);
          Get.back(result: true);
        },
      );
    }
  }

  Rx<ReviewModel> reviewModel = ReviewModel().obs;
  Rx<UserModel> userModel = UserModel().obs;
  getReview() async {
    await FireStoreUtils.getReview(bookingId: bookingModel.value.id ?? "", senderId: userModel.value.id ?? '').then((value) {
      if (value != null) {
        reviewModel.value = value;
      }
    });
  }

  getUserData() async {
    await FireStoreUtils.getUserProfile(bookingModel.value.createdBy.toString()).then((value) {
      publisherUserModel.value = value!;
    });
  }

  double calculateAmount(BookedUserModel bookingUserModel) {
    RxString taxAmount = "0.0".obs;
    if (bookingUserModel.taxList != null) {
      for (var element in bookingUserModel.taxList!) {
        taxAmount.value = (double.parse(taxAmount.value) + Constant().calculateTax(amount: bookingUserModel.subTotal.toString(), taxModel: element))
            .toStringAsFixed(Constant.currencyModel!.decimalDigits!);
      }
    }
    return (double.parse(bookingUserModel.subTotal.toString())) + double.parse(taxAmount.value);
  }

  Future<bool> checkSameCity(double lat1, double lon1, double lat2, double lon2) async {
    bool isSame = false;
    try {
      // Get the placemarks for the first location
      List<Placemark> placemarks1 = await placemarkFromCoordinates(lat1, lon1);
      // Get the placemarks for the second location
      List<Placemark> placemarks2 = await placemarkFromCoordinates(lat2, lon2);

      if (placemarks1.isNotEmpty && placemarks2.isNotEmpty) {
        String city1 = placemarks1[0].locality ?? '';
        String city2 = placemarks2[0].locality ?? '';

        if (city1.isNotEmpty && city2.isNotEmpty) {
          if (city1 == city2) {
            isSame = true;
          } else {
            isSame = false;
          }
        } else {
          isSame = false;
        }
      } else {
        isSame = false;
      }
    } catch (e) {
      isSame = false;
    }
    return isSame;
  }
}
