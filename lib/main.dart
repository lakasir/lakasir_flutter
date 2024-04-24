import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:lakasir/controllers/notification_controller.dart';
import 'package:lakasir/messages.dart';
import 'package:lakasir/models/lakasir_database.dart';
import 'package:lakasir/screens/about/about_screen.dart';
import 'package:lakasir/screens/about/edit_screen.dart';
import 'package:lakasir/screens/auth_screen.dart';
import 'package:lakasir/screens/domain/register_domain_screen.dart';
import 'package:lakasir/screens/forgot_screen.dart';
import 'package:lakasir/screens/members/add_screen.dart';
import 'package:lakasir/screens/members/edit_screen.dart';
import 'package:lakasir/screens/members/member_screen.dart';
import 'package:lakasir/screens/notifications/notification_screen.dart';
import 'package:lakasir/screens/products/add_screen.dart';
import 'package:lakasir/screens/products/detail_screen.dart';
import 'package:lakasir/screens/products/detail_stock_screen.dart';
import 'package:lakasir/screens/products/edit_screen.dart';
import 'package:lakasir/screens/products/product_screen.dart';
import 'package:lakasir/screens/profile/edit_screen.dart';
import 'package:lakasir/screens/profile/profile_screen.dart';
import 'package:lakasir/screens/setting/category_screen.dart';
import 'package:lakasir/screens/setting/hide_initial_price_screen.dart';
import 'package:lakasir/screens/setting/layout_screen.dart';
import 'package:lakasir/screens/setting/notifications/setting_notification_screen.dart';
import 'package:lakasir/screens/setting/printers/add_printer_page_screen.dart';
import 'package:lakasir/screens/setting/printers/printer_page_screen.dart';
import 'package:lakasir/screens/setting/selling_method_screen.dart';
import 'package:lakasir/screens/setting/setting_screen.dart';
import 'package:lakasir/screens/transactions/carts/cashier_cart_menu_screen.dart';
import 'package:lakasir/screens/transactions/carts/payment_screen.dart';
import 'package:lakasir/screens/transactions/cashier_menu_screen.dart';
import 'package:lakasir/screens/transactions/history/detail_screen.dart';
import 'package:lakasir/screens/transactions/history/history_screen.dart';
import 'package:lakasir/screens/transactions/invoice_screen.dart';
import 'package:lakasir/screens/transactions/reports/cashier_screen.dart';
import 'package:lakasir/screens/transactions/transaction_menu_screen.dart';
import 'package:lakasir/services/login_service.dart';
import 'package:lakasir/utils/auth.dart';
import 'package:lakasir/utils/colors.dart';
import 'package:lakasir/utils/utils.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_options.dart';

final _messageStreamController = BehaviorSubject<RemoteMessage>();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debug("Listen notificaiton in background");
  await Firebase.initializeApp();
  await LakasirDatabase.initialize();
  if (message.notification != null) {
    createNotification(message.data);
  }
}

void createNotification(Map<String, dynamic> messageData) async {
  final NotificationController notificationController =
      Get.put(NotificationController());
  for (var i = 1; i <= messageData.length; i++) {
    var data = jsonDecode(messageData["data$i"]);

    notificationController.create(NotificationRequest(
      title: data["name"],
      body: data["stock"].toString(),
      data: data["id"].toString(),
    ));
  }
  await Get.forceAppUpdate();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LakasirDatabase.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  debug('Permission granted: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debug("Listen notificaiton in foreground");
    _messageStreamController.sink.add(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debug("message clicked");
    Get.toNamed('/notifications');
  });
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  final isAuthenticated = await getToken();
  final bool setup = await isSetup();
  await dotenv.load();
  LoginService loginService = LoginService();
  if (isAuthenticated != null) {
    String? token = await messaging.getToken();
    debug("Registered Token=$token");
    loginService.setFcmToken(token!);
  }
  runApp(
    MyApp(
      isAuthenticated: isAuthenticated ?? "",
      setup: setup,
      locale: await getLocale(),
    ),
  );
}

class MyApp extends StatefulWidget {
  final String isAuthenticated;
  final bool setup;
  final Locale locale;

  const MyApp({
    super.key,
    this.isAuthenticated = "",
    this.setup = false,
    this.locale = const Locale('en'),
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final NotificationController notificationController =
      Get.put(NotificationController());
  _MyAppState() {
    _messageStreamController.listen((message) {
      if (message.notification != null) {
        createNotification(message.data);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      notificationController.fetch();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: Messages(),
      locale: widget.locale,
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
        '/menu/transaction/reports/cashier': (context) =>
            const CashierReportScreen(),
        '/menu/transaction': (context) => const TransactionMenuScreen(),
        '/menu/transaction/history': (context) => const HistoryScreen(),
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
        '/menu/setting/hide_initial_price': (context) =>
            const HideInitialPriceScreen(),
        '/menu/setting/layout': (context) => const LayoutScreen(),
        '/menu/setting/category': (context) => const CategoryScreen(),
        '/menu/setting/selling_method': (context) => SellingMethodScreen(),
        '/menu/setting/print': (context) => const PrinterPageScreen(),
        '/menu/setting/print/add': (context) => const AddPrinterPageScreen(),
        '/notifications': (context) => const NotificationScreen(),
        '/menu/setting/notification': (context) =>
            const SettingNotificationScreen(),
      },
    );
  }
}
