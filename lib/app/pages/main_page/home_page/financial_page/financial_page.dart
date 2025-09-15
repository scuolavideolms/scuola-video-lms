import 'dart:async';
import 'package:flutter/material.dart';
//import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webinar/app/models/offline_payment_model.dart';
import 'package:webinar/app/models/payout_model.dart';
import 'package:webinar/app/models/sales_model.dart';
import 'package:webinar/app/models/summary_model.dart';
import 'package:webinar/app/pages/main_page/home_page/payment_status_page/payment_status_page.dart';
import 'package:webinar/app/providers/user_provider.dart';
import 'package:webinar/app/services/user_service/financial_service.dart';
import 'package:webinar/app/widgets/main_widget/financial_widget.dart/financial_widget.dart';
import 'package:webinar/common/common.dart';
import 'package:webinar/common/components.dart';
import 'package:webinar/common/data/api_public_data.dart';
import 'package:webinar/common/data/app_data.dart';
import 'package:webinar/common/data/app_language.dart';
import 'package:webinar/common/utils/app_text.dart';
import 'package:webinar/common/utils/constants.dart';
import 'package:webinar/locator.dart';

class FinancialPage extends StatefulWidget {
  static const String pageName = '/financial';
  const FinancialPage({super.key});

  @override
  State<FinancialPage> createState() => _FinancialPageState();
}

class _FinancialPageState extends State<FinancialPage>  with SingleTickerProviderStateMixin{

  late TabController tabController;
  SaleModel? saleData;
  SummaryModel? summaryData;
  PayoutModel? payoutData;
  List<OfflinePaymentModel> offlinePayments = [];

  bool isLoadingSummaryData = true;
  bool isLoadingOfflinePaymentData = true;
  bool isLoadingPayoutData = true;
  bool isLoadingSalesData = true;
 
  bool isLoadingCharge = false;

  late StreamSubscription _sub;

  @override
  void initState() {
    super.initState();

    if(locator<UserProvider>().profile?.roleName == PublicData.userRole){
      tabController = TabController(length: 3, vsync: this);
    }else{
      tabController = TabController(length: 4, vsync: this);
    }

    getSummaryData();
    getOfflinePaymentData();
    
    if(locator<UserProvider>().profile?.roleName != PublicData.userRole){
      getSalesData();
    }
    getPayoutData();

   // initUniLinks();
  }
  // Future<Map<String, dynamic>?> createPayment(String amount,
  //     String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': (int.parse(amount) * 100).toString(),
  //       'currency': currency,
  //       'payment_method_types[]': 'card',
  //     };
  //
  //     var response = await http.post(
  //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //       headers: {
  //         "Authorization": 'Bearer sk_test_51NRgYUHyFGpID0glhMajndFau0AEM9VwlefdzyDPBnnAJMUiwbQJWJcKlEZN6AwPhOLbiySoHrHfCH11CF8SbQha00eLmQLSCP',
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var paymentIntent = json.decode(response.body);
  //
  //       print("PaymentIntent created: ${paymentIntent['id']}");
  //       return paymentIntent;
  //     } else {
  //       var errorResponse = json.decode(response.body);
  //       print("Error: ${errorResponse['error']['message']}");
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //   }
  //   return null;
  // }

  // Future<void> makePayment() async {
  //   try {
  //     paymentIntents = await createPayment(widget.data!.packagePrice, "AED");
  //
  //     if (paymentIntents != null) {
  //       await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: paymentIntents!['client_secret'],
  //           googlePay: PaymentSheetGooglePay(
  //
  //             currencyCode: "USD",
  //             merchantCountryCode: "AED",
  //           ),
  //           merchantDisplayName: "Talasuf",
  //         ),
  //
  //       );
  //
  //
  //       try {
  //         await Stripe.instance.presentPaymentSheet();
  //         await orderbooking(context);
  //         print("Payment successful!");
  //       } catch (e) {
  //         print("Error presenting payment sheet: $e");
  //       }
  //     } else {
  //       print("Payment Intent creation failed.");
  //     }
  //   } catch (e) {
  //     print("Payment failed: $e");
  //   }
  // }
  // Future<Map<String, dynamic>?> createPayment(String amount,
  //     String currency) async {
  //   try {
  //     Map<String, dynamic> body = {
  //       'amount': (int.parse(amount) * 100).toString(),
  //       'currency': currency,
  //       'payment_method_types[]': 'card',
  //     };
  //
  //     var response = await http.post(
  //       Uri.parse("https://api.stripe.com/v1/payment_intents"),
  //       headers: {
  //         "Authorization": 'Bearer sk_test_51NRgYUHyFGpID0glhMajndFau0AEM9VwlefdzyDPBnnAJMUiwbQJWJcKlEZN6AwPhOLbiySoHrHfCH11CF8SbQha00eLmQLSCP',
  //         "Content-Type": "application/x-www-form-urlencoded",
  //       },
  //       body: body,
  //     );
  //
  //     if (response.statusCode == 200) {
  //       var paymentIntent = json.decode(response.body);
  //
  //       print("PaymentIntent created: ${paymentIntent['id']}");
  //       return paymentIntent;
  //     } else {
  //       var errorResponse = json.decode(response.body);
  //       print("Error: ${errorResponse['error']['message']}");
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //   }
  //   return null;
  // }
  //
  // Future<void> makePayment() async {
  //   try {
  //     paymentIntents = await createPayment(widget.data!.packagePrice, "AED");
  //
  //     if (paymentIntents != null) {
  //       await Stripe.instance.initPaymentSheet(
  //         paymentSheetParameters: SetupPaymentSheetParameters(
  //           paymentIntentClientSecret: paymentIntents!['client_secret'],
  //           googlePay: PaymentSheetGooglePay(
  //
  //             currencyCode: "USD",
  //             merchantCountryCode: "AED",
  //           ),
  //           merchantDisplayName: "Talasuf",
  //         ),
  //
  //       );
  //
  //
  //       try {
  //         await Stripe.instance.presentPaymentSheet();
  //         await orderbooking(context);
  //         print("Payment successful!");
  //       } catch (e) {
  //         print("Error presenting payment sheet: $e");
  //       }
  //     } else {
  //       print("Payment Intent creation failed.");
  //     }
  //   } catch (e) {
  //     print("Payment failed: $e");
  //   }
  // }

  // Future<void> initUniLinks() async {
  //
  //   _sub = linkStream.listen((String? link) {
  //     if(link != null){
  //
  //       if(link == 'academyapp://payment-success'){
  //         getSummaryData();
  //         nextRoute(PaymentStatusPage.pageName, arguments: 'success');
  //       }else if(link == 'academyapp://payment-failed'){
  //         nextRoute(PaymentStatusPage.pageName, arguments: 'failed');
  //       }
  //
  //     }
  //   }, onError: (err) {});
  //
  // }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  getSummaryData() async {

    setState(() {
      isLoadingSummaryData = true;
    });
    
    summaryData = await FinancialService.getSummaryData();
    
    setState(() {
      isLoadingSummaryData = false;
    });
  }

  getPayoutData() async {

    setState(() {
      isLoadingPayoutData = true;
    });
    
    payoutData = await FinancialService.getPayoutData();
    
    setState(() {
      isLoadingPayoutData = false;
    });
  }

  getSalesData() async {

    setState(() {
      isLoadingSalesData = true;
    });
    
    saleData = await FinancialService.getSalesData();
    
    setState(() {
      isLoadingSalesData = false;
    });
  }

  getOfflinePaymentData() async {

    setState(() {
      isLoadingOfflinePaymentData = true;
    });
    
    offlinePayments = await FinancialService.getOfflinePayments();
    
    setState(() {
      isLoadingOfflinePaymentData = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return directionality(
      child: Scaffold(

        appBar: appbar(title: appText.financial),

        body: Column(
          children: [

            tabBar(
              (i){

              }, 
              tabController,
              [
                Tab(text: appText.summary, height: 32),
               // Tab(text: appText.offlinePayment, height: 32),
                
                if(locator<UserProvider>().profile?.roleName != PublicData.userRole)...{
                  Tab(text: appText.sales, height: 32),
                },

                Tab(text: appText.payout, height: 32),
              ]
            ),

            Expanded(
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: tabController,
                children: [

                  isLoadingSummaryData
                  ? loading()
                  : FinancialWidget.summaryPage(summaryData, getSummaryData, isLoadingCharge, () async {
                      isLoadingCharge = true;
                      setState(() {});

                      String? link = await FinancialService.webLinkCharge();

                      isLoadingCharge = false;
                      setState(() {});

                      if(link != null){
                        String token = await AppData.getAccessToken();

                        Map<String, String> headers = {
                          "Authorization": "Bearer $token",
                          "Content-Type" : "application/json", 
                          'Accept' : 'application/json',
                          'x-api-key' : Constants.apiKey,
                          'x-locale' : locator<AppLanguage>().currentLanguage.toLowerCase(),
                        };

                        await launchUrlString(
                          link,
                          mode: LaunchMode.externalApplication,
                          webViewConfiguration: WebViewConfiguration(
                            headers: headers,
                          )
                        );

                      }
                    }),

                 // isLoadingOfflinePaymentData
                //  ? loading()
                  //: FinancialWidget.offlinePaymentPage(offlinePayments),

                  if(locator<UserProvider>().profile?.roleName != PublicData.userRole)...{
                    isLoadingSalesData
                    ? loading()
                    : FinancialWidget.salesPage(saleData),
                  },

                  isLoadingPayoutData
                  ? loading()
                  : FinancialWidget.payoutPage(payoutData, getPayoutData),

                ]
              )
            )

          ],
        ),
      )
    );
  }
}