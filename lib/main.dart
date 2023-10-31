import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import './models/transaction.dart';
import './widgets/chart.dart';
import './widgets/new_transaction.dart';
import './widgets/transaction_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        fontFamily: 'Quicksand',
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontFamily: 'OpenSans'),
          bodyLarge: TextStyle(
            fontFamily: 'Quicksand',
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.purple,
        ).copyWith(
          secondary: Colors.pink[100],
        ),
        // appBarTheme: const AppBarTheme(titleTextStyle: TextStyle(fontFamily: 'OpenSans', fontSize: 20)) // Old ways of declaring font family for thr appBar Title
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _userTransactions = [];

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(const Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String title, double amount, DateTime chosenDate) {
    final newTx =
        Transaction(id: DateTime.now().toString(), title: title, amount: amount, date: chosenDate);

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((transaction) => transaction.id == id);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewTransaction(_addNewTransaction));
        });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Show Chart',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Switch.adaptive(
            activeColor: Theme.of(context).colorScheme.secondary,
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            },
          ),
        ],
      ),
      _showChart
          ? SizedBox(
              width: double.infinity,
              child: SizedBox(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.7,
                child: Chart(_recentTransactions),
              ),
            )
          : txListWidget
    ];
  }

  List<Widget> _buildPotraitContent(
      MediaQueryData mediaQuery, PreferredSizeWidget appBar, Widget txListWidget) {
    return [
      SizedBox(
        width: double.infinity,
        child: SizedBox(
          height:
              (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.3,
          child: Chart(_recentTransactions),
        ),
      ),
      txListWidget
    ];
  }

  PreferredSizeWidget _buildCupertinoNavBar() {
    return CupertinoNavigationBar(
      middle: const Text('Expense Tracker'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoButton(
            padding: const EdgeInsets.all(0),
            onPressed: (() => _startAddNewTransaction(context)),
            child: const Icon(CupertinoIcons.add),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildMaterialAppBar() {
    return AppBar(
      title: const Text('Expense Tracker'),
      actions: <Widget>[
        IconButton(
          onPressed: (() => _startAddNewTransaction(context)),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build() MyHomePageState');

    final mediaQuery = MediaQuery.of(context);

    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    final PreferredSizeWidget appBar =
        Platform.isIOS ? _buildCupertinoNavBar() : _buildMaterialAppBar();

    final txList = SizedBox(
      height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top) * 0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape) ..._buildLandscapeContent(mediaQuery, appBar, txList),
            if (!isLandscape) ..._buildPotraitContent(mediaQuery, appBar, txList),
          ],
        ),
      ),
    );
    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: appBar as ObstructingPreferredSizeWidget,
            child: pageBody,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: (() => _startAddNewTransaction(context)),
                    child: const Icon(Icons.add),
                  ),
          );
  }
}
