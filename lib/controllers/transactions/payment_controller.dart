import 'package:get/get.dart';
import 'package:lakasir/Exceptions/validation.dart';
import 'package:lakasir/api/requests/pagination_request.dart';
import 'package:lakasir/api/requests/payment_request.dart';
import 'package:lakasir/controllers/products/product_controller.dart';
import 'package:lakasir/controllers/transactions/cart_controller.dart';
import 'package:lakasir/controllers/transactions/history_controller.dart';
import 'package:lakasir/services/payment_service.dart';
import 'package:lakasir/utils/colors.dart';

class PaymentController extends GetxController {
  final _productController = Get.put(ProductController());
  final _paymentService = PaymentSerivce();
  final _cartController = Get.put(CartController());
  final _transactionController = Get.put(HistoryController());
  final RxBool isLoading = false.obs;

  void store() async {
    try {
      isLoading(true);
      await _paymentService.store(PaymentRequest(
        payedMoney: _cartController.cartSessions.value.payedMoney,
        friendPrice: false,
        tax: _cartController.cartSessions.value.tax,
        memberId: _cartController.cartSessions.value.member?.id,
        products: _cartController.cartSessions.value.cartItems
            .map(
              (e) => PaymentRequestItem(
                productId: e.product.id,
                qty: e.qty,
              ),
            )
            .toList(),
      ));
      _cartController.cartSessions.value = CartSession(
        cartItems: [],
      );
      _cartController.cartSessions.refresh();
      _productController.getProducts();
      _transactionController.fetchTransaction(
        PaginationRequest(
          page: 1,
          perPage: _transactionController.perPage,
        ),
      );
      Get.offAllNamed("/auth");
      Get.toNamed("/menu/transaction/cashier");
      Get.rawSnackbar(
        message: 'Selling success',
        backgroundColor: success,
        duration: const Duration(seconds: 2),
      );
      isLoading(false);
    } catch (e) {
      isLoading(false);
      if (e is ValidationException) {
      }
    }
  }
}
