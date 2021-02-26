import 'package:flutter/material.dart';

import 'pages/add_farm.dart';
import 'pages/authstate.dart';
import 'pages/farmer_dashboard.dart';
import 'pages/home.dart';
import 'pages/market_listing.dart';
import 'pages/place_to_market.dart';
import 'pages/produce_page.dart';
import 'pages/product_single.dart';
import 'pages/register_farmer.dart';
import 'pages/splash.dart';
import 'pages/wallet/wallet_dashboard.dart';
import 'utils/transition.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/SplashPage':
        return MaterialPageRoute(
          builder: (context) => SplashWidget(),
        );

      case '/AuthPage':
        return slideAnimation(Auth());

      case '/WalletDashboard':
        return slideAnimation(WalletDashboard(
          mobile: args,
        ));

      case '/MarketForm':
        return slideAnimation(MarketForm(
          details: args,
        ));
// animation =
      //     CurvedAnimation(parent: animation, curve: Curves.elasticInOut);
      case '/HomePage':
        return fadeAnimation(HomePage(args));

      case '/MarketListingPage':
        return fadeAnimation(MarketListingPage(args));

      case '/ProductInfoPage':
        return fadeAnimation(ProductInfo(args));

      case '/RegisterFarmerPage':
        return fadeAnimation(RegisterFarmerPage());

      case '/FarmerInfo':
        return fadeAnimation(FarmerDashboard(args));

      case '/AddFarmPage':
        return fadeAnimation(
          AddFarm(
            farmer: args,
          ),
        );

      case '/ProducePage':
        return fadeAnimation(
          ProducePage(args),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => SplashWidget(),
        );
    }
  }
}
