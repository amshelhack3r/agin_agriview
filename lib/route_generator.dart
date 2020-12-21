import 'package:flutter/material.dart';

import 'pages/aggregator.dart';
import 'pages/allproducelist.dart';
import 'pages/auth/login.dart';
import 'pages/dashboard.dart';
import 'pages/farm.dart';
import 'pages/farmdetail.dart';
import 'pages/farmer.dart';
import 'pages/farmerdetail.dart';
import 'pages/farmergroup.dart';
import 'pages/farmerlist.dart';
import 'pages/farmproduce.dart';
import 'pages/farmslist.dart';
import 'pages/otp.dart';
import 'pages/placetomarket.dart';
import 'pages/producedetail.dart';
import 'pages/producelist.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case 'LoginPage':
        return MaterialPageRoute(
          builder: (context) => Login(),
        );

      case '/RegisterPage':
        return MaterialPageRoute(
          builder: (context) => Aggregator(),
        );

      case '/FarmerListPage':
        return MaterialPageRoute(
          builder: (context) => FarmerList(args),
        );

      case '/ProduceListPage':
        return MaterialPageRoute(
          builder: (context) => ProduceList(),
        );

      case '/AllProducePage':
        return MaterialPageRoute(
          builder: (context) => AllProduceList(),
        );

      case '/FarmsListPage':
        return MaterialPageRoute(
          builder: (context) => FarmsList(),
        );

      case '/NewProducePage':
        return MaterialPageRoute(
          builder: (context) => FarmProduce(),
        );

      case '/NewFarmerPage':
        return MaterialPageRoute(
          builder: (context) => Farmer(),
        );

      case '/NewFarmerGroupPage':
        return MaterialPageRoute(
          builder: (context) => Farmergroup(),
        );

      case '/NewFarmPage':
        return MaterialPageRoute(
          builder: (context) => Farm(),
        );

      case '/DashboardPage':
        return MaterialPageRoute(
          builder: (context) => Dashboard(),
        );

      case '/DetailFarmerPage':
        return MaterialPageRoute(
          builder: (context) => FarmerDetail(),
        );
      case '/DetailFarmPage':
        return MaterialPageRoute(
          builder: (context) => FarmDetail(),
        );
      case '/DetailProducePage':
        return MaterialPageRoute(
          builder: (context) => ProduceDetail(),
        );
      case '/PlaceMarketPage':
        return MaterialPageRoute(
          builder: (context) => PlaceToMarket(),
        );
      case '/OtpPage':
        return MaterialPageRoute(
          builder: (context) => Otp(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Login(),
        );
    }
  }
}
