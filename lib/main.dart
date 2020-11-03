import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transactions.dart';
import './widgets/transactionList.dart';

import './models/transcation.dart';
import './widgets/chart.dart';
import './widgets/banner.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expense',
      theme: ThemeData(
          primarySwatch: Colors.red,
          accentColor: Colors.orange,
          cardTheme: CardTheme(
              elevation: 10,
              shadowColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          fontFamily: 'OpenSans',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                button: TextStyle(
                  color: Colors.white,
                ),
                headline5: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
          errorColor: Colors.red,
          backgroundColor: Colors.white,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            textTheme: ThemeData.dark().textTheme.copyWith(
                    title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            centerTitle: true,
            elevation: 10,
            shadowColor: Colors.blueGrey,
          )),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // String titleInput;
  // String amountInput;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final titleController = TextEditingController();
  bool boolChart = false;
  final amountController = TextEditingController();
  final List<Transaction> _userTransactions = [
    // Transaction(
    //   id: 't1',
    //   title: 'New Shoes',
    //   amount: 69.9,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: 't2',
    //   title: 'New Dress',
    //   amount: 60.9,
    //   date: DateTime.now(),
    // ),
  ];
  List<Transaction> get _recentTransaction {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(
        Duration(days: 7),
      ));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double amount, DateTime chosenDate) {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: amount,
      date: chosenDate,
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showCupertinoModalPopup(
        context: ctx,
        // isScrollControlled: true,
        // shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.vertical(
        //   top: Radius.circular(20),
        // )),
        
        
        builder: (_) {
          return NewTransactions(_addNewTransaction);
        });
  }


  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarColor(Colors.red.withOpacity(0));
    //FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expense'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (isLandscape)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Show Chart',
                          style: theme.textTheme.headline5,
                        ),
                        Switch.adaptive(
                          value: boolChart,
                          onChanged: (val) {
                            setState(() {
                              boolChart = val;
                            });
                          },
                        ),
                      ]),
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),

                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expense'),
            actions: <Widget>[
              if (isLandscape)
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Show Chart',
                        style: theme.textTheme.headline5,
                      ),
                      Switch.adaptive(
                        value: boolChart,
                        onChanged: (val) {
                          setState(() {
                            boolChart = val;
                          });
                        },
                      ),
                    ]),
            ],
          );
    final txList = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .7,
        child: TransactionList(_userTransactions, _deleteTransaction));
    final pageBody = SafeArea(child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!isLandscape)
            Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    .3,
                child: Chart(
                  _recentTransaction,
                )),
          if (!isLandscape) txList,
          if (isLandscape)
            boolChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        .7,
                    child: Chart(
                      _recentTransaction,
                    ))
                : Container(
                    height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top),
                    child:
                        TransactionList(_userTransactions, _deleteTransaction)),
        ],
      ),
    ));

    return wrapWithBanner(
      Platform.isIOS
          ? CupertinoPageScaffold(
              child: pageBody,
              navigationBar: appBar,
            )
          : Scaffold(
              backgroundColor: theme.backgroundColor,
              appBar: appBar,
              body: pageBody,
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: Platform.isIOS
                  ? Container()
                  : FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: () {
                        _startAddNewTransaction(context);
                      },
                    ),
            ),
    );
  }
}
