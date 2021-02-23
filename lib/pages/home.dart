import 'package:flutter/material.dart';

import '../utils/hex_color.dart';
import 'dashboard.dart';
import 'farmers_list.dart';
import 'market_place.dart';
import 'wallet/wallet_login.dart';

class HomePage extends StatefulWidget {
  final int index;
  HomePage(this.index, {Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageController;
  int currentNavBarIndex;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentNavBarIndex = (widget.index == null) ? 0 : widget.index;
    _pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _pageController.animateToPage(currentNavBarIndex,
          duration: Duration(milliseconds: 100), curve: Curves.easeIn);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          DashboardPage(),
          MarketPlaceList(),
          FarmersListPage(),
          WalletLogin()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => Navigator.pushNamed(context, "/HomePage"),
        child: Icon(
          Icons.eco,
          color: Colors.green[600],
          size: 40,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  _buildBottomNavBar() {
    return Container(
      height: 70,
      child: BottomAppBar(
        color: HexColor("#F2F2F2"),
        elevation: 10,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _buildBottomNavBarItem(icon: Icons.home, index: 0, text: "Home"),
            _buildBottomNavBarItem(
                icon: Icons.store, index: 1, text: "Markets"),
            SizedBox(
              width: 20,
            ),
            _buildBottomNavBarItem(
                icon: Icons.library_books, index: 2, text: "Farmer List"),
            _buildBottomNavBarItem(
                icon: Icons.account_balance_wallet, index: 3, text: "Wallet"),
          ],
        ),
      ),
    );
  }

  _buildBottomNavBarItem({int index, String text, IconData icon}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          currentNavBarIndex = index;
          _pageController.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.easeIn);
        });
      },
      child: Container(
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: currentNavBarIndex == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey,
            ),
            Text(
              text,
              style: TextStyle(
                color: currentNavBarIndex == index
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
