import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PurchaseProviderModel with ChangeNotifier{
  InAppPurchase _iap  = InAppPurchase.instance;
  bool available = true;
  late StreamSubscription subscription;
  final String myProductID = 'test_one_month';

  List _purchases = [];
  List get purchases => _purchases;
  set purchases(List value) {
    _purchases = value;
    notifyListeners();
  }

  List _products = [];
  List get products => _products;
  set products(List value) {
    _products = value;
    notifyListeners();
  }


  PurchaseProviderModel(){
    subscription = _iap.purchaseStream.listen((purchaseDetailsList) {
      // Handle the purchased subscriptions
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      subscription.cancel();
    }, onError: (error) {
      // handle the error
    });
    initialize();
  }

  void initialize() async{
    available = await _iap.isAvailable();
    if(available){
      await _getProducts();
    }
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print(purchaseDetails.status);
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print("pending");
        //  _showPendingUI();
          break;
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
        // bool valid = await _verifyPurchase(purchaseDetails);
        // if (!valid) {
        //   _handleInvalidPurchase(purchaseDetails);
        // }
          print(purchaseDetails.verificationData.localVerificationData);
          print("restored");
          break;
        case PurchaseStatus.error:
          print(purchaseDetails.error!);
          // _handleError(purchaseDetails.error!);
          break;
        default:
          break;
      }

      /*if (purchaseDetails.pendingCompletePurchase) {
        print("pendingCompletePurchase");
        await _iap.completePurchase(purchaseDetails);
      }*/
    });
  }

  Future<void> _getProducts() async {
    Set<String> ids = Set.from([myProductID]);
    ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    products = response.productDetails;
  }

  void buy({required ProductDetails product}) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    _iap.buyNonConsumable(
      purchaseParam: purchaseParam,
    );
  }

}