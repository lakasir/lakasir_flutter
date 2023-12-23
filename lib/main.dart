import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lakasir/screens/about/about_screen.dart';
import 'package:lakasir/screens/about/edit_screen.dart';
import 'package:lakasir/screens/auth_screen.dart';
import 'package:lakasir/screens/domain/register_domain_screen.dart';
import 'package:lakasir/screens/forgot_screen.dart';
import 'package:lakasir/screens/members/add_screen.dart';
import 'package:lakasir/screens/members/edit_screen.dart';
import 'package:lakasir/screens/members/member_screen.dart';
import 'package:lakasir/screens/products/add_screen.dart';
import 'package:lakasir/screens/products/detail_screen.dart';
import 'package:lakasir/screens/products/detail_stock_screen.dart';
import 'package:lakasir/screens/products/edit_screen.dart';
import 'package:lakasir/screens/products/product_screen.dart';
import 'package:lakasir/screens/profile/edit_screen.dart';
import 'package:lakasir/screens/profile/profile_screen.dart';
import 'package:lakasir/screens/setting/category_screen.dart';
import 'package:lakasir/screens/setting/setting_screen.dart';
import 'package:lakasir/screens/transactions/carts/cashier_cart_menu_screen.dart';
import 'package:lakasir/screens/transactions/carts/payment_screen.dart';
import 'package:lakasir/screens/transactions/cashier_menu_screen.dart';
import 'package:lakasir/screens/transactions/history/detail_screen.dart';
import 'package:lakasir/screens/transactions/history/history_screen.dart';
import 'package:lakasir/screens/transactions/invoice_screen.dart';
import 'package:lakasir/screens/transactions/transaction_menu_screen.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final isAuthenticated = await getToken();
  final bool setup = await isSetup();
  await dotenv.load();
  runApp(
    MyApp(
      isAuthenticated: isAuthenticated ?? "",
      setup: setup,
    ),
  );
}

class MyApp extends StatelessWidget {
  final String isAuthenticated;
  final bool setup;

  const MyApp({super.key, this.isAuthenticated = "", this.setup = false});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Lakasir',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          background: Colors.white,
        ),
        fontFamily: 'SourceSans',
        useMaterial3: true,
      ),
      initialRoute: '/auth',
      routes: {
        '/domain/register': (context) => const RegisterDomainScreen(),
        '/auth': (context) => const AuthScreen(),
        '/forgot': (context) => const ForgotScreen(),
        '/menu/transaction': (context) => const TransactionMenuScreen(),
        '/menu/transaction/history': (context) => HistoryScreen(),
        '/menu/transaction/history/detail': (context) =>
            const HistoryDetailScreen(),
        '/menu/transaction/cashier': (context) => const CashierMenuScreen(),
        '/menu/transaction/cashier/cart': (context) =>
            const CashierCartMenuScreen(),
        '/menu/transaction/cashier/payment': (context) => const PaymentScreen(),
        '/menu/transaction/cashier/receipt': (context) => const InvoiceScreen(),
        '/menu/product': (context) => const ProductScreen(),
        '/menu/product/add': (context) => const AddProductScreen(),
        '/menu/product/detail': (context) => const DetailScreen(),
        '/menu/product/stock': (context) => const DetailStockScreen(),
        '/menu/product/edit': (context) => const EditProductScreen(),
        '/menu/profile': (context) => const ProfileScreen(),
        '/menu/profile/edit': (context) => const EditProfileScreen(),
        '/menu/about': (context) => const AboutScreen(),
        '/menu/about/edit': (context) => const EditAboutScreen(),
        '/menu/member': (context) => const MemberScreen(),
        '/menu/member/add': (context) => const AddMemberScreen(),
        '/menu/member/edit': (context) => const EditMemberScreen(),
        '/menu/setting': (context) => const SettingScreen(),
        '/menu/setting/category': (context) => const CategoryScreen(),
      },
    );
  }
}
