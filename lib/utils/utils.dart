import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

String formatPrice(dynamic price, {bool isSymbol = true}) {
  return NumberFormat.currency(
    locale: 'id_ID',
    symbol: isSymbol ? 'Rp. ' : '',
    decimalDigits: 0,
  ).format(price);
}

Future<Locale> getLocale() async {
  final prefs = await SharedPreferences.getInstance();

  return Locale(prefs.getString('locale') ?? Locale(Get.deviceLocale!.toString()).languageCode);
}

Future<void> setLocale(String locale) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setString('locale', locale);
}

Future<String> getLanguageCode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('locale') ?? Get.deviceLocale!.toString();
}
