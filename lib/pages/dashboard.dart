import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../blocs/BlocProvider.dart';
import 'placetomarketlist.dart';
import 'wallet.dart';
import 'default.dart';
import 'farmerlist.dart';

class Dashboard extends StatefulWidget {
  final String aggregatorAginID;
  final String firstName;
  final String lastName;

  const Dashboard(
      {Key key,
      @required this.aggregatorAginID,
      @required this.firstName,
      @required this.lastName})
      : super(key: key);

  @override
  _DashboardState createState() =>
      _DashboardState(aggregatorAginID, firstName, lastName);
}

class _DashboardState extends State<Dashboard> {
  Color color = new Color(0xff00b965);
  int _currentIndex = 0;
  GlobalKey dashboardBottomNavigationKey =
      new GlobalKey(debugLabel: 'btm_app_bar');
  final String aggregatorAginID;
  final String firstName;
  final String lastName;

  _DashboardState(this.aggregatorAginID, this.firstName, this.lastName);

  @override
  Widget build(BuildContext context) {
    /*Map data = {};
    data = data.isNotEmpty ? data : ModalRoute.of(context).settings.arguments;
    String aggregatorAginID = data['aggregatorAginID'].toString();
    String firstName = data['firstName'].toString();
    String lastName = data['lastName'].toString();*/
    final IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(
                          Icons.account_circle,
                        ),
                      ),
                      Text(
                        '$firstName $lastName',
                        style: TextStyle(color: Colors.white),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.notifications_active,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).primaryColor,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                child: IconButton(
                                  icon: new Image.asset(
                                      'assets/images/input.png'),
                                  color: Colors.white,
                                  onPressed: () {},
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Sell Inputs',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                child: IconButton(
                                  icon: new Image.asset(
                                      'assets/images/market.png'),
                                  color: Colors.white,
                                  onPressed: () {
                                    IncrementBloc bloc =
                                        BlocProvider.of<IncrementBloc>(context);
                                    bloc.incrementCounter.add(2);
                                    //Navigator.pushNamed(context, '/market');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Place To Market',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                child: IconButton(
                                  icon: new Image.asset(
                                      'assets/images/produce.png'),
                                  color: Colors.white,
                                  onPressed: () {
                                    IncrementBloc bloc =
                                        BlocProvider.of<IncrementBloc>(context);
                                    bloc.incrementCounter.add(2);
                                    //Navigator.pushNamed(context, '/farmerlist', arguments: {'aggregatorAginID' : aggregatorAginID});
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Register Produce',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                child: IconButton(
                                  icon: new Image.asset(
                                      'assets/images/group_white.png'),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/newfarmergroup');
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Register Group',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Column(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorDark,
                                child: IconButton(
                                  icon: new Image.asset(
                                      'assets/images/user_add.png'),
                                  color: Colors.white,
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/newfarmer',
                                        arguments: {
                                          'aggregatorAginID': aggregatorAginID,
                                        });
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  'Register Farmer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        key: dashboardBottomNavigationKey,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        //fixedColor: Theme.of(context).primaryColor,
        selectedItemColor: Theme.of(context).primaryColor,
        currentIndex: _currentIndex,
        onTap: (newIndex) => setState(() {
          _currentIndex = newIndex;
          bloc.incrementCounter.add(newIndex);
        }),
        items: [
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            label: "Home",
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_basket,
              size: 30,
            ),
            label: "Market Listing",
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.view_list,
              size: 30,
            ),
            label: "Farmers List",
          ),
          new BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet,
              size: 30,
            ),
            label: "Wallet",
          )
        ],
      ),
      body: SafeArea(
        child: StreamBuilder<int>(
            stream: bloc.outCounter,
            initialData: 0,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                print(snapshot.data);
                _currentIndex = snapshot.data;
              }

              return IndexedStack(
                index: _currentIndex,
                children: <Widget>[
                  new Default(aggregatorAginID),
                  new PlaceToMarketList(aggregatorAginID),
                  new FarmerList(aggregatorAginID),
                  new Wallet(),
                ],
              );
            }),

        /* child: IndexedStack(
          index: _currentIndex,
          children: <Widget>[
            new Default(aggregatorAginID),
            new PlaceToMarketList(),
            new FarmerList(),
            new Wallet(),
          ],
        ),*/
      ),
    );
  }
}

class IncrementBloc implements BlocBase {
  int _counter;

  //
  // Stream to handle the counter
  //
  StreamController<int> _counterController = StreamController<int>();
  StreamSink<int> get _inAdd => _counterController.sink;
  Stream<int> get outCounter => _counterController.stream;

  //
  // Stream to handle the action on the counter
  //
  StreamController _actionController = StreamController();
  StreamSink get incrementCounter => _actionController.sink;

  //
  // Constructor
  //
  IncrementBloc() {
    _counter = 0;
    _actionController.stream.listen(_handleLogic);
  }

  void dispose() {
    _actionController.close();
    _counterController.close();
  }

  void _handleLogic(data) {
    _counter = data;
    _inAdd.add(_counter);
  }
}
