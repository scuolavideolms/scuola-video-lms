import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webinar/app/models/course_model.dart';
import 'package:webinar/app/pages/main_page/main_page.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/user_service/cart_service.dart';
import 'package:webinar/app/widgets/main_widget/home_widget/cart_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/common/utils/currency_utils.dart';
import 'package:webinar/config/assets.dart';
import 'package:webinar/config/colors.dart';
import 'package:webinar/config/styles.dart';
import 'package:webinar/locator.dart';

import '../../../../../common/enums/error_enum.dart';
import '../../../../models/cart_model.dart';
import '../home_page.dart';

class CartPage extends StatefulWidget {
  static const String pageName = '/cart';
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  bool isLoading = false;
  bool isLoadingWebCheckout = false;
  CartModel? data;
  int? discountId;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  final InAppPurchase inAppPurchase = InAppPurchase.instance;

  late final StreamSubscription<List<PurchaseDetails>> _subscription;
  @override
  void initState() {
    super.initState();




    getData();
    UserProvider user = locator<UserProvider>();
    if (user.cartData != null) {
      print("Cart data successfully saved in locator:");
    } else {
      print("Cart data not found in locator.");
    }

  }


  @override
  // void dispose() {
  //   _subscription.cancel();
  //
  //   super.dispose();
  // }

  // @override
  // void dispose() {
  //   _subscription.cancel();
  //   super.dispose();
  // }
var product_id;




  int? webinarId;

  getData() async {
    setState(() {
      isLoading = true;
    });

   await CartService.getCart();

    //

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchase) async {
    // 🔸 For iOS: Minimal local verification
    if (purchase.status == PurchaseStatus.purchased || purchase.status == PurchaseStatus.restored) {
      return true;
    }
    return false;
  }







  @override
  Widget build(BuildContext context) {


    return directionality(
      child: Consumer<UserProvider>(
        builder: (context, userProvdider, _) {

          return Scaffold(

            appBar: appbar(
              title: (userProvdider.cartData?.items?.length ?? 0) > 0
                ? '${appText.cart} (${userProvdider.cartData?.items?.length})'
                : appText.cart,
            ),

            body: isLoading
          ? loading()
          : Stack(
              children: [

                // items
                (userProvdider.cartData?.items?.isEmpty ?? true)
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(bottom: getSize().height * .2),
                  child: emptyState(AppAssets.emptyCardSvg, appText.cartIsEmpty, appText.cartIsEmptyDesc)
                )
              : Positioned.fill(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),

                    child: Column(
                      children: [

                        space(5),

                        ...List.generate(userProvdider.cartData?.items?.length ?? 0, (index) {


                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: red49,
                                  borderRadius: borderRadius()
                                ),
                                margin: padding(),

                                child: Slidable(
                                  key: ValueKey(index),
                                  startActionPane: ActionPane(
                                    motion: const ScrollMotion(),
                                    extentRatio: .3,

                                    children:  [

                                      GestureDetector(
                                        onTap: (){

                                          setState(() {
                                            isLoading = true;
                                          });

                                          CartService.deleteCourse(userProvdider.cartData!.items![index].id!).then((value) async {

                                            userProvdider.cartData!.items!.removeAt(index);

                                            await Future.delayed(const Duration(seconds: 1));

                                            setState(() {
                                              isLoading = false;
                                            });

                                            if(value){
                                              getData();
                                            }

                                          });

                                        },
                                        behavior: HitTestBehavior.opaque,
                                        child: SizedBox(
                                          width: 90,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              SvgPicture.asset(AppAssets.deleteSvg),

                                              space(4),

                                              Text(
                                                appText.remove,
                                                style: style10Regular().copyWith(color: Colors.white),
                                              ),

                                            ],
                                          ),
                                        ),
                                      )

                                    ],
                                  ),


                                  child: directionality(
                                    child: courseItemVertically(
                                      CourseModel(
                                        id: userProvdider.cartData?.items?[index].id,
                                        image: userProvdider.cartData?.items?[index].image,
                                        price: userProvdider.cartData?.items?[index].price,
                                        discountPercent: (userProvdider.cartData?.items?[index].discount) != null
                                            ? ((((userProvdider.cartData?.items?[index].price ?? 1) - (userProvdider.cartData?.items?[index].discount ?? 1)) / 100 ) * 100).toInt()
                                            : 0,
                                        rate: userProvdider.cartData?.items?[index].rate,
                                        title: userProvdider.cartData?.items?[index].title,

                                        reservedMeeting: userProvdider.cartData?.items?[index].type == 'meeting'
                                          ? '${userProvdider.cartData?.items?[index].day ?? ''} ${userProvdider.cartData?.items?[index].time?.start ?? ''}-${userProvdider.cartData?.items?[index].time?.end ?? ''} ${userProvdider.cartData?.items?[index].timezone ?? ''}'
                                          : null,
                                        reservedMeetingUserTimeZone: userProvdider.cartData?.items?[index].type == 'meeting'
                                          ? '${userProvdider.cartData?.items?[index].day ?? ''} ${userProvdider.cartData?.items?[index].timeUser?.start ?? ''}-${userProvdider.cartData?.items?[index].timeUser?.end ?? ''} ${locator<UserProvider>().profile?.timezone ?? ''}'
                                          : null,
                                      ),

                                      bottomMargin: 0,
                                      ignoreTap: true,
                                      height: userProvdider.cartData?.items?[index].type == 'meeting' ? 110 : 83,
                                      imageHeight: userProvdider.cartData?.items?[index].type == 'meeting' ? 110 : 83

                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),

                        // space(20),

                        if(userProvdider.cartData?.userGroup != null)...{
                          helperBox(AppAssets.discountSvg, '${userProvdider.cartData?.userGroup?.discount}% ${appText.userGroupDiscount}', '${userProvdider.cartData?.userGroup?.name}'),

                          space(16),
                        },

                        // if(userProvdider.cartData?.totalCashbackAmount != null)...{
                        //   helperBox(
                        //     AppAssets.walletSvg,
                        //     appText.getCashback,
                        //     '${appText.finalizeYourOrderAndGet} '
                        //     // '${CurrencyUtils.calculator(userProvdider.cartData?.totalCashbackAmount ?? 0, fractionDigits: 1)} ${appText.cashback}'
                        //     '${CurrencyUtils.calculator(userProvdider.cartData?.totalCashbackAmount ?? 0)} ${appText.cashback}'
                        //   ),
                        //
                        //   space(16),
                        // },

                        space(300),
                      ],
                    ),
                  )
                ),


                // amount
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    width: getSize().width,
                    padding: padding(vertical: 21),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        boxShadow(Colors.black.withOpacity(.1), y: -3, blur: 15)
                      ]
                    ),

                    child: Column(
                      children: [

                        // sub total
                        cartItem(
                          appText.subtotal,
                          CurrencyUtils.calculator(userProvdider.cartData?.amounts?.subTotal ?? 0)
                        ),

                        // Discount
                        cartItem(
                          appText.discount,
                          CurrencyUtils.calculator(userProvdider.cartData?.amounts?.totalDiscount ?? 0)
                        ),

                        // Tax
                        cartItem(
                          '${appText.tax} (${userProvdider.cartData?.amounts?.tax ?? 0}%)',
                          CurrencyUtils.calculator(userProvdider.cartData?.amounts?.taxPrice ?? 0)
                        ),

                        // Total
                        cartItem(
                          appText.total,
                          CurrencyUtils.calculator(userProvdider.cartData?.amounts?.total ?? 0)
                        ),

                        space(6),

                        if((userProvdider.cartData?.items?.isNotEmpty ?? false))...{

                          Row(
                            children: [

                              Expanded(
                                child: button(
                                    onTap: () async {
if(Platform.isAndroid) {
          setState(() {
          isLoadingWebCheckout = true;
          });

          String? link = await CartService.webCheckout();

          String token = await AppData.getAccessToken();

          setState(() {
          isLoadingWebCheckout = false;
          });

          Map<String, String> headers = {
          "Authorization": "Bearer $token",
          "Content-Type" : "application/json",
          'Accept' : 'application/json',
          'x-api-key' : Constants.apiKey,
          'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
          };

          await launchUrlString(
          link ?? '',
          mode: LaunchMode.externalApplication,
          webViewConfiguration: WebViewConfiguration(
          headers: headers,
          )
          );
            }

else {
  setState(() {
    isLoadingWebCheckout = true;
  });

  final items = userProvdider.cartData?.items;

  if (items == null || items.isEmpty) {
    print("Cart is empty or null.");
    setState(() => isLoadingWebCheckout = false);
    return;
  }

  if (items.length > 1) {
    print("More than 1 course");
    setState(() => isLoadingWebCheckout = false);
    showSnackBar(ErrorEnum.error, "You can only purchase one course at a time with in-app purchase.");
    return;
  }

  final productId = items.first.product_id;
  if (productId == null) {
    setState(() => isLoadingWebCheckout = false);
    showSnackBar(ErrorEnum.error, "This course is not available for in-app purchase.");
    return;
  }

  final InAppPurchase inAppPurchase = InAppPurchase.instance;
  final bool available = await inAppPurchase.isAvailable();
  if (!available) {
    setState(() => isLoadingWebCheckout = false);
    showSnackBar(ErrorEnum.error, "In-app purchases are currently not available.");
    return;
  }

  final ProductDetailsResponse response = await inAppPurchase.queryProductDetails({"course_$productId"});
  if (response.notFoundIDs.isNotEmpty || response.productDetails.isEmpty) {
    print("Product not found: ${response.notFoundIDs}");
    setState(() => isLoadingWebCheckout = false);
    showSnackBar(ErrorEnum.error, "The selected course could not be found for purchase.");
    return;
  }

  final ProductDetails productDetails = response.productDetails.first;
  final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);

  late StreamSubscription<List<PurchaseDetails>> purchaseSubscription;

  purchaseSubscription = inAppPurchase.purchaseStream.listen((purchases) async {
    for (var purchase in purchases) {
      switch (purchase.status) {
        case PurchaseStatus.restored:
          if (purchase.productID == items.first.product_id.toString()) {
            // 🔹 This course was already purchased via iOS
            setState(() => isLoadingWebCheckout = false);
            showSnackBar(ErrorEnum.success, "You have already purchased this course.");
            purchaseSubscription.cancel();
            return;
          }
          break;

        case PurchaseStatus.purchased:
        // 🔹 Continue with normal purchase + verification
          bool isValid = await _verifyPurchase(purchase);
          if (isValid) {
            await inAppPurchase.completePurchase(purchase);
            purchaseSubscription.cancel();

            setState(() {
              isLoadingWebCheckout = false;
              isLoading = true;
            });

            print("Api hit hy");

            Map<String, String>? data = await CartService.ioscheckout(
              items.first.price.toString(),
              items.first.product_id.toString(),
              items.first.price.toString(),
            );

            setState(() => isLoading = false);

            if (data?['status'] == "200") {
              showSnackBar(ErrorEnum.success, data?['status_message']);
              setState(() => userProvdider.cartData = null);
              nextRoute(MainPage.pageName);
            } else {
              showSnackBar(ErrorEnum.error, "Something went wrong while recording purchase.");
            }
          } else {
            setState(() => isLoadingWebCheckout = false);
            showSnackBar(ErrorEnum.error, "Purchase verification failed.");
          }
          break;

        case PurchaseStatus.pending:
          break;

        case PurchaseStatus.canceled:
          setState(() => isLoadingWebCheckout = false);
          purchaseSubscription.cancel();
          break;

        case PurchaseStatus.error:
          setState(() => isLoadingWebCheckout = false);
          purchaseSubscription.cancel();
          showSnackBar(ErrorEnum.error, "Purchase failed: ${purchase.error?.message}");
          break;
      }
    }
  });




  // Trigger purchase
  inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
}



                                    },
                                    width: getSize().width,
                                    height: 52,
                                    text: appText.checkout,
                                    bgColor: green77(),
                                    textColor: Colors.white,
                                    isLoading: isLoadingWebCheckout
                                ),
                              ),



                              space(0, width: 20),

                              Expanded(
                                child: button(
                                  onTap: () async {
                                    var res = await CartWidget.showCouponSheet();

                                    if(res != null){
                                      userProvdider.cartData?.amounts = res['amount'];
                                      discountId = res['discount_id'];

                                      setState(() {});
                                    }

                                  },
                                  width: getSize().width,
                                  height: 52,
                                  text: appText.addCoupon,
                                  bgColor: Colors.white,
                                  textColor: green77(),
                                  borderColor: green77()
                                )
                              ),
                            ],
                          ),

                          space(8),
                        },


                      ],
                    ),
                  )
                )

              ],
            ),
          );
        }
      ),
    );
  }




  Widget cartItem(String title, String price){
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Text(
            title,
            style: style16Regular(),
          ),


          Text(
            price,
            style: style16Regular().copyWith(color: greyB2),
          ),

        ],
      ),
    );
  }

}