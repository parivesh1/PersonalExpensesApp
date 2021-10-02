import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import '../widgets/transactions_list.dart';
import '../models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  // For setting available Orientations of the Device
  runApp(MyHome());
}

class MyHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Personal Expenses App",
      theme: ThemeData(
          primarySwatch: Colors.purple, // So that you can set variants
          accentColor: Colors.amber, // For Buttons..
          fontFamily: "Quicksand", // Added from pubspec.yaml
          textTheme: ThemeData.light().textTheme.copyWith(
              title: TextStyle(
                  fontFamily: "OpenSans",
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
              button: TextStyle(color: Colors.white)),
          appBarTheme: AppBarTheme(
              textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: "OpenSans",
                      fontSize: 20,
                      fontWeight: FontWeight.bold)))),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> transactions = [];

  void _addNewTransaction(String txTitle, double txAmount, DateTime dateTime) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: dateTime);
    setState(() {
      transactions.add(newTx);
    });
  }

  void deleteTx(String id) {
    setState(() {
      transactions.removeWhere((tx) => tx.id == id);
    });
  }

  void _startAddNewTrans(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
            child: NewTransaction(_addNewTransaction),
            behavior: HitTestBehavior.opaque,
            onTap: () {},
          );
        });
  }

  bool _showChart = false;

  List<Transaction> get _recentTx {
    return transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(
      title: Text(
        "Personal Expenses App",
      ),
      centerTitle: true,
      shadowColor: Theme.of(context).primaryColorLight,
      elevation: 10,
      actions: [
        IconButton(
            onPressed: () => _startAddNewTrans(context), icon: Icon(Icons.add))
      ],
    );

    final mediaQuery = MediaQuery.of(context);
    final isLandscape = (mediaQuery.orientation == Orientation.landscape);

    final txListWidget = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(transactions, deleteTx));

    final body = SafeArea(
        child: SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
        if (isLandscape)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Show Chart!", style: Theme.of(context).textTheme.title),
              Switch.adaptive(
                  activeColor: Theme.of(context).accentColor,
                  value: _showChart,
                  onChanged: (val) {
                    setState(() {
                      _showChart = val;
                    });
                  })
            ],
          ),
        if (!isLandscape)
          Container(
              height: (mediaQuery.size.height -
                      appBar.preferredSize.height -
                      mediaQuery.padding.top) *
                  0.3,
              child: Chart(_recentTx)),
        if (!isLandscape) txListWidget,
        if (isLandscape)
          _showChart == true
              ? Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      0.7,
                  child: Chart(_recentTx))
              : txListWidget
      ]),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: body,
            navigationBar: CupertinoNavigationBar(
              middle: Text(
                "Personal Expenses App",
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    child: Icon(CupertinoIcons.add),
                    onTap: () => _startAddNewTrans(context),
                  )
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            body: body,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () => _startAddNewTrans(context),
                    child: Icon(Icons.add),
                  ));
  }
}
