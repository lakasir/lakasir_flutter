import 'package:lakasir/api/api_service.dart';
import 'package:lakasir/utils/auth.dart';

class SecureInitialPriceService {
  Future<void> verifyPassword(String text) async{
    await ApiService(await getDomain()).postData(
      'setting/secure-initial-price/verify',
      {'password': text},
    );
  }
}
