import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './widgets/new_transactions.dart';
import './widgets/transactionList.dart';

import './models/transcation.dart';
import './widgets/chart.dart';
import './widgets/banner.dart';

void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expense',
      theme: ThemeData(
          snackBarTheme: SnackBarThemeData(
            elevation: 20,
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.amber,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              highlightColor: Colors.amberAccent,
              disabledColor: Colors.amber[100]),
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: Colors.black,
              selectionColor: Colors.black,
              selectionHandleColor: Colors.black),
          //dialogBackgroundColor: Colors.black,
          dialogTheme: DialogTheme(
              //backgroundColor: Colors.black,
              contentTextStyle: TextStyle(
                backgroundColor: Colors.white,
                color: Colors.amber,
                decorationColor: Colors.red,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          primarySwatch: Colors.red,
          accentColor: Colors.orange,
          cardTheme: CardTheme(
              elevation: 10,
              color: Colors.red,
              shadowColor: Colors.deepOrange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
          fontFamily: 'OpenSans',
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
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
          backgroundColor: Colors.black,
          appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            textTheme: ThemeData.dark().textTheme.copyWith(
                    headline6: TextStyle(
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
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final titleController = TextEditingController();
  bool boolChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("New state is $state");
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  final amountController = TextEditingController();
  final List<Transaction> _userTransactions = [];

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
        barrierDismissible: true,
        builder: (_) {
          return NewTransactions(_addNewTransaction);
        });
  }

  Widget _buildCupertinoNavigationbar(bool isLandscape, ThemeData theme) {
    return CupertinoNavigationBar(
      middle: const Text('Personal Expense'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (isLandscape)
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
    );
  }

  Widget _buildAppBarContent(bool isLandscape) {
    return AppBar(
      title: const Text('Personal Expense'),
      actions: <Widget>[
        if (isLandscape)
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              'Show Chart',
              // style: theme.textTheme.headline5,
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
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final theme = Theme.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? _buildCupertinoNavigationbar(isLandscape, theme)
        : _buildAppBarContent(isLandscape);
    final txList = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          .7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final chartPortrait = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .3,
        child: Chart(
          _recentTransaction,
        ));

    final switchChart = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .7,
        child: Chart(
          _recentTransaction,
        ));

    final switchTransactionList = Container(
      height: (mediaQuery.size.height -
          appBar.preferredSize.height -
          mediaQuery.padding.top),
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!isLandscape) chartPortrait,
          if (!isLandscape) txList,
          if (isLandscape) boolChart ? switchChart : switchTransactionList,
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
