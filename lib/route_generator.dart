import 'package:flutter/material.dart';

import 'pages/authstate.dart';
import 'pages/dashboard.dart';
import 'pages/farmer_info.dart';
import 'pages/home.dart';
import 'pages/market_listing.dart';
import 'pages/product_single.dart';
import 'pages/register_farmer.dart';
import 'pages/splash.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/SplashPage':
        return MaterialPageRoute(
          builder: (context) => SplashWidget(),
        );

      case '/AuthPage':
        return MaterialPageRoute(
          builder: (context) => Auth(),
        );

      case '/HomePage':
        return MaterialPageRoute(
          builder: (context) => HomePage(),
        );

      case '/DashboardPage':
        return MaterialPageRoute(
          builder: (context) => DashboardPage(),
        );

      case '/MarketListingPage':
        return MaterialPageRoute(
          builder: (context) => MarketListingPage(args),
        );

      case '/ProductInfoPage':
        return MaterialPageRoute(
          builder: (context) => ProductInfo(),
        );

      case '/RegisterFarmerPage':
        return MaterialPageRoute(
          builder: (context) => RegisterFarmerPage(),
        );

      case '/FarmerInfo':
        return MaterialPageRoute(
          builder: (context) => FarmerInfo(),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashWidget(),
        );
    }
  }
}
